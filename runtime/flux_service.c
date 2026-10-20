/* ==============================================================================
 * TheFlux Windows Service & Named Pipe IPC Bridge
 * Implementação: runtime/flux_service.c
 * ============================================================================== */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

#include "flux_service.h"

static SERVICE_STATUS g_ServiceStatus;
static SERVICE_STATUS_HANDLE g_StatusHandle = NULL;
static HANDLE g_ServiceStopEvent = NULL;
static FluxBytecodeExecutorFn g_Executor = NULL;
static volatile BOOL g_Running = TRUE;

/* Forward declarations */
static VOID WINAPI ServiceMain(DWORD argc, LPWSTR *argv);
static DWORD WINAPI ServiceCtrlHandler(DWORD ctrl, DWORD eventType, LPVOID eventData, LPVOID context);
static DWORD WINAPI PipeServerWorker(LPVOID param);

/* ==============================================================================
 * Service Installation & Management via SCM
 * ============================================================================== */

int flux_service_install(const wchar_t *exe_path) {
    SC_HANDLE scm = OpenSCManagerW(NULL, NULL, SC_MANAGER_ALL_ACCESS);
    if (!scm) {
        fwprintf(stderr, L"[-] Erro ao abrir SCM (requer Administrador): %lu\n", GetLastError());
        return 1;
    }

    wchar_t path_quoted[MAX_PATH + 32];
    swprintf(path_quoted, MAX_PATH + 32, L"\"%s\" --service run", exe_path);

    SC_HANDLE service = CreateServiceW(
        scm,
        FLUX_SERVICE_NAME,
        FLUX_SERVICE_DISPLAY,
        SERVICE_ALL_ACCESS,
        SERVICE_WIN32_OWN_PROCESS,
        SERVICE_AUTO_START,
        SERVICE_ERROR_NORMAL,
        path_quoted,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    );

    if (!service) {
        DWORD err = GetLastError();
        if (err == ERROR_SERVICE_EXISTS) {
            fwprintf(stderr, L"[*] Servico '%s' ja esta instalado.\n", FLUX_SERVICE_NAME);
            CloseServiceHandle(scm);
            return 0;
        }
        fwprintf(stderr, L"[-] Falha ao criar servico: %lu\n", err);
        CloseServiceHandle(scm);
        return 1;
    }

    SERVICE_DESCRIPTIONW desc;
    desc.lpDescription = L"TheFlux Virtual Machine High-Performance Resident Service (bytecode injection over Named Pipes)";
    ChangeServiceConfig2W(service, SERVICE_CONFIG_DESCRIPTION, &desc);

    CloseServiceHandle(service);
    CloseServiceHandle(scm);
    wprintf(L"[+] Servico '%s' instalado com sucesso!\n", FLUX_SERVICE_NAME);
    return 0;
}

int flux_service_uninstall(void) {
    SC_HANDLE scm = OpenSCManagerW(NULL, NULL, SC_MANAGER_ALL_ACCESS);
    if (!scm) {
        fwprintf(stderr, L"[-] Erro ao abrir SCM: %lu\n", GetLastError());
        return 1;
    }

    SC_HANDLE service = OpenServiceW(scm, FLUX_SERVICE_NAME, SERVICE_STOP | DELETE);
    if (!service) {
        fwprintf(stderr, L"[-] Servico '%s' nao encontrado.\n", FLUX_SERVICE_NAME);
        CloseServiceHandle(scm);
        return 1;
    }

    SERVICE_STATUS status;
    ControlService(service, SERVICE_CONTROL_STOP, &status);

    if (!DeleteService(service)) {
        fwprintf(stderr, L"[-] Falha ao remover servico: %lu\n", GetLastError());
        CloseServiceHandle(service);
        CloseServiceHandle(scm);
        return 1;
    }

    CloseServiceHandle(service);
    CloseServiceHandle(scm);
    wprintf(L"[+] Servico '%s' removido com sucesso.\n", FLUX_SERVICE_NAME);
    return 0;
}

int flux_service_start(void) {
    SC_HANDLE scm = OpenSCManagerW(NULL, NULL, SC_MANAGER_ALL_ACCESS);
    if (!scm) return 1;

    SC_HANDLE service = OpenServiceW(scm, FLUX_SERVICE_NAME, SERVICE_START);
    if (!service) {
        CloseServiceHandle(scm);
        return 1;
    }

    int ret = 0;
    if (!StartServiceW(service, 0, NULL)) {
        DWORD err = GetLastError();
        if (err != ERROR_SERVICE_ALREADY_RUNNING) {
            fwprintf(stderr, L"[-] Falha ao iniciar servico: %lu\n", err);
            ret = 1;
        } else {
            wprintf(L"[*] Servico ja esta em execucao.\n");
        }
    } else {
        wprintf(L"[+] Servico '%s' iniciado.\n", FLUX_SERVICE_NAME);
    }

    CloseServiceHandle(service);
    CloseServiceHandle(scm);
    return ret;
}

int flux_service_stop(void) {
    SC_HANDLE scm = OpenSCManagerW(NULL, NULL, SC_MANAGER_ALL_ACCESS);
    if (!scm) return 1;

    SC_HANDLE service = OpenServiceW(scm, FLUX_SERVICE_NAME, SERVICE_STOP);
    if (!service) {
        CloseServiceHandle(scm);
        return 1;
    }

    SERVICE_STATUS status;
    int ret = 0;
    if (!ControlService(service, SERVICE_CONTROL_STOP, &status)) {
        fwprintf(stderr, L"[-] Falha ao parar servico: %lu\n", GetLastError());
        ret = 1;
    } else {
        wprintf(L"[+] Servico '%s' parado.\n", FLUX_SERVICE_NAME);
    }

    CloseServiceHandle(service);
    CloseServiceHandle(scm);
    return ret;
}

/* ==============================================================================
 * Windows Service Entry Point & Control Dispatcher
 * ============================================================================== */

static VOID ReportServiceStatus(DWORD currentState, DWORD win32ExitCode, DWORD waitHint) {
    static DWORD checkPoint = 1;
    g_ServiceStatus.dwCurrentState = currentState;
    g_ServiceStatus.dwWin32ExitCode = win32ExitCode;
    g_ServiceStatus.dwWaitHint = waitHint;

    if (currentState == SERVICE_START_PENDING) {
        g_ServiceStatus.dwControlsAccepted = 0;
    } else {
        g_ServiceStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN;
    }

    if (currentState == SERVICE_RUNNING || currentState == SERVICE_STOPPED) {
        g_ServiceStatus.dwCheckPoint = 0;
    } else {
        g_ServiceStatus.dwCheckPoint = checkPoint++;
    }

    SetServiceStatus(g_StatusHandle, &g_ServiceStatus);
}

static DWORD WINAPI ServiceCtrlHandler(DWORD ctrl, DWORD eventType, LPVOID eventData, LPVOID context) {
    (void)eventType; (void)eventData; (void)context;
    switch (ctrl) {
        case SERVICE_CONTROL_STOP:
        case SERVICE_CONTROL_SHUTDOWN:
            ReportServiceStatus(SERVICE_STOP_PENDING, NO_ERROR, 0);
            g_Running = FALSE;
            if (g_ServiceStopEvent) SetEvent(g_ServiceStopEvent);
            ReportServiceStatus(SERVICE_STOPPED, NO_ERROR, 0);
            return NO_ERROR;
        default:
            break;
    }
    return NO_ERROR;
}

static VOID WINAPI ServiceMain(DWORD argc, LPWSTR *argv) {
    (void)argc; (void)argv;
    g_StatusHandle = RegisterServiceCtrlHandlerExW(FLUX_SERVICE_NAME, ServiceCtrlHandler, NULL);
    if (!g_StatusHandle) return;

    ZeroMemory(&g_ServiceStatus, sizeof(g_ServiceStatus));
    g_ServiceStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;

    ReportServiceStatus(SERVICE_START_PENDING, NO_ERROR, 3000);

    g_ServiceStopEvent = CreateEventW(NULL, TRUE, FALSE, NULL);
    if (!g_ServiceStopEvent) {
        ReportServiceStatus(SERVICE_STOPPED, GetLastError(), 0);
        return;
    }

    ReportServiceStatus(SERVICE_RUNNING, NO_ERROR, 0);

    /* Executa o servidor de named pipe */
    PipeServerWorker((LPVOID)g_Executor);

    ReportServiceStatus(SERVICE_STOPPED, NO_ERROR, 0);
    CloseHandle(g_ServiceStopEvent);
}

int flux_service_run(FluxBytecodeExecutorFn executor) {
    g_Executor = executor;
    SERVICE_TABLE_ENTRYW serviceTable[] = {
        { (LPWSTR)FLUX_SERVICE_NAME, (LPSERVICE_MAIN_FUNCTIONW)ServiceMain },
        { NULL, NULL }
    };

    if (!StartServiceCtrlDispatcherW(serviceTable)) {
        return 1;
    }
    return 0;
}

/* ==============================================================================
 * Named Pipe IPC Protocol Handling
 * ============================================================================== */

/* Frame de Injeção:
 * [Magic: 4B 'FVMI']
 * [Version: 2B]
 * [Flags: 2B]
 * [Stdin Len: 4B]
 * [Bytecode Len: 4B]
 * [Stdin Bytes]
 * [Bytecode Bytes]
 */

static void HandlePipeClient(HANDLE pipe, FluxBytecodeExecutorFn executor) {
    uint32_t header[4]; /* magic, (flags << 16 | version), stdin_len, bc_len */
    DWORD bytesRead = 0;

    if (!ReadFile(pipe, header, sizeof(header), &bytesRead, NULL) || bytesRead < sizeof(header)) {
        DisconnectNamedPipe(pipe);
        return;
    }

    if (header[0] != FLUX_IPC_MAGIC) {
        DisconnectNamedPipe(pipe);
        return;
    }

    uint32_t stdin_len = header[2];
    uint32_t bc_len = header[3];

    /* Limites de segurança: max 64MB */
    if (bc_len > 64 * 1024 * 1024 || stdin_len > 16 * 1024 * 1024) {
        DisconnectNamedPipe(pipe);
        return;
    }

    char *stdin_buf = (char *)malloc(stdin_len + 1);
    char *bc_buf = (char *)malloc(bc_len + 1);
    if (!stdin_buf || !bc_buf) {
        free(stdin_buf); free(bc_buf);
        DisconnectNamedPipe(pipe);
        return;
    }

    if (stdin_len > 0) {
        DWORD read_cur = 0;
        while (read_cur < stdin_len) {
            DWORD chunk = 0;
            if (!ReadFile(pipe, stdin_buf + read_cur, stdin_len - read_cur, &chunk, NULL) || chunk == 0) break;
            read_cur += chunk;
        }
    }
    stdin_buf[stdin_len] = '\0';

    if (bc_len > 0) {
        DWORD read_cur = 0;
        while (read_cur < bc_len) {
            DWORD chunk = 0;
            if (!ReadFile(pipe, bc_buf + read_cur, bc_len - read_cur, &chunk, NULL) || chunk == 0) break;
            read_cur += chunk;
        }
    }
    bc_buf[bc_len] = '\0';

    /* Executa o bytecode via executor FVM */
    char *out_stdout = NULL;
    size_t out_stdout_len = 0;
    char *out_stderr = NULL;
    size_t out_stderr_len = 0;

    LARGE_INTEGER t0, t1, freq;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&t0);

    int exit_code = executor(bc_buf, stdin_buf, &out_stdout, &out_stdout_len, &out_stderr, &out_stderr_len);

    QueryPerformanceCounter(&t1);
    uint64_t elapsed_us = (uint64_t)((t1.QuadPart - t0.QuadPart) * 1000000ULL / freq.QuadPart);

    free(bc_buf);
    free(stdin_buf);

    /* Envia resposta de volta */
    /* Resposta:
     * [ExitCode: 4B]
     * [ElapsedUs: 8B]
     * [StdoutLen: 4B]
     * [StderrLen: 4B]
     * [Stdout Bytes]
     * [Stderr Bytes]
     */
    uint32_t resp_hdr[5];
    resp_hdr[0] = (uint32_t)exit_code;
    resp_hdr[1] = (uint32_t)(elapsed_us & 0xFFFFFFFF);
    resp_hdr[2] = (uint32_t)(elapsed_us >> 32);
    resp_hdr[3] = (uint32_t)out_stdout_len;
    resp_hdr[4] = (uint32_t)out_stderr_len;

    DWORD written = 0;
    WriteFile(pipe, resp_hdr, sizeof(resp_hdr), &written, NULL);
    if (out_stdout && out_stdout_len > 0) {
        WriteFile(pipe, out_stdout, (DWORD)out_stdout_len, &written, NULL);
    }
    if (out_stderr && out_stderr_len > 0) {
        WriteFile(pipe, out_stderr, (DWORD)out_stderr_len, &written, NULL);
    }

    FlushFileBuffers(pipe);
    DisconnectNamedPipe(pipe);

    if (out_stdout) free(out_stdout);
    if (out_stderr) free(out_stderr);
}

static DWORD WINAPI PipeServerWorker(LPVOID param) {
    FluxBytecodeExecutorFn executor = (FluxBytecodeExecutorFn)param;

    while (g_Running) {
        HANDLE pipe = CreateNamedPipeW(
            FLUX_PIPE_NAME,
            PIPE_ACCESS_DUPLEX,
            PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
            PIPE_UNLIMITED_INSTANCES,
            65536,
            65536,
            5000,
            NULL
        );

        if (pipe == INVALID_HANDLE_VALUE) {
            Sleep(100);
            continue;
        }

        BOOL connected = ConnectNamedPipe(pipe, NULL) ? TRUE : (GetLastError() == ERROR_PIPE_CONNECTED);
        if (connected) {
            HandlePipeClient(pipe, executor);
        }
        CloseHandle(pipe);
    }
    return 0;
}

/* ==============================================================================
 * Daemon Mode (sem SCM, background user process)
 * ============================================================================== */

int flux_daemon_run(FluxBytecodeExecutorFn executor) {
    wprintf(L"[+] TheFlux FVM Daemon ativo no Named Pipe: %s\n", FLUX_PIPE_NAME);
    wprintf(L"[*] Pressione Ctrl+C para encerrar.\n");
    g_Running = TRUE;
    PipeServerWorker((LPVOID)executor);
    return 0;
}

int flux_daemon_stop(void) {
    /* Conecta e envia sinal de desligamento ou para o serviço */
    return flux_service_stop();
}

/* ==============================================================================
 * Named Pipe Client (Bytecode Injection)
 * ============================================================================== */

int flux_ipc_inject(
    const char *bytecode_json,
    const char *stdin_text,
    FluxIpcResponse *response,
    int timeout_ms
) {
    if (!bytecode_json || !response) return -1;
    ZeroMemory(response, sizeof(FluxIpcResponse));

    /* Espera o Named Pipe ficar disponível */
    if (!WaitNamedPipeW(FLUX_PIPE_NAME, timeout_ms)) {
        return -2; /* Serviço não está rodando */
    }

    HANDLE pipe = CreateFileW(
        FLUX_PIPE_NAME,
        GENERIC_READ | GENERIC_WRITE,
        0,
        NULL,
        OPEN_EXISTING,
        0,
        NULL
    );

    if (pipe == INVALID_HANDLE_VALUE) {
        return -2;
    }

    DWORD mode = PIPE_READMODE_MESSAGE;
    SetNamedPipeHandleState(pipe, &mode, NULL, NULL);

    size_t stdin_len = stdin_text ? strlen(stdin_text) : 0;
    size_t bc_len = strlen(bytecode_json);

    uint32_t header[4];
    header[0] = FLUX_IPC_MAGIC;
    header[1] = ((uint32_t)FLUX_IPC_VERSION & 0xFFFF);
    header[2] = (uint32_t)stdin_len;
    header[3] = (uint32_t)bc_len;

    DWORD written = 0;
    if (!WriteFile(pipe, header, sizeof(header), &written, NULL)) {
        CloseHandle(pipe);
        return -3;
    }

    if (stdin_len > 0) {
        WriteFile(pipe, stdin_text, (DWORD)stdin_len, &written, NULL);
    }
    WriteFile(pipe, bytecode_json, (DWORD)bc_len, &written, NULL);
    FlushFileBuffers(pipe);

    /* Lê a resposta */
    uint32_t resp_hdr[5];
    DWORD read_bytes = 0;
    if (!ReadFile(pipe, resp_hdr, sizeof(resp_hdr), &read_bytes, NULL) || read_bytes < sizeof(resp_hdr)) {
        CloseHandle(pipe);
        return -4;
    }

    response->exit_code = (int32_t)resp_hdr[0];
    response->elapsed_us = ((uint64_t)resp_hdr[2] << 32) | resp_hdr[1];
    uint32_t stdout_len = resp_hdr[3];
    uint32_t stderr_len = resp_hdr[4];

    if (stdout_len > 0) {
        response->stdout_buf = (char *)malloc(stdout_len + 1);
        if (response->stdout_buf) {
            DWORD cur = 0;
            while (cur < stdout_len) {
                DWORD c = 0;
                if (!ReadFile(pipe, response->stdout_buf + cur, stdout_len - cur, &c, NULL) || c == 0) break;
                cur += c;
            }
            response->stdout_buf[cur] = '\0';
            response->stdout_len = cur;
        }
    }

    if (stderr_len > 0) {
        response->stderr_buf = (char *)malloc(stderr_len + 1);
        if (response->stderr_buf) {
            DWORD cur = 0;
            while (cur < stderr_len) {
                DWORD c = 0;
                if (!ReadFile(pipe, response->stderr_buf + cur, stderr_len - cur, &c, NULL) || c == 0) break;
                cur += c;
            }
            response->stderr_buf[cur] = '\0';
            response->stderr_len = cur;
        }
    }

    CloseHandle(pipe);
    return 0;
}

void flux_ipc_response_free(FluxIpcResponse *resp) {
    if (!resp) return;
    if (resp->stdout_buf) { free(resp->stdout_buf); resp->stdout_buf = NULL; }
    if (resp->stderr_buf) { free(resp->stderr_buf); resp->stderr_buf = NULL; }
    resp->stdout_len = 0;
    resp->stderr_len = 0;
}
