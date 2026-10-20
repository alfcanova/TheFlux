/* ==============================================================================
 * TheFlux Fast Virtual Machine CLI & Service (fluxvm.exe)
 * Arquivo: runtime/fvm/fvm_main.c
 * ============================================================================== */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "fvm_core.h"
#include "fvm_parser.h"
#include "../flux_service.h"

#define FLUXVM_VERSION "0.9.9"

static void print_usage(void) {
    printf("TheFlux Virtual Machine (fluxvm) v%s\n", FLUXVM_VERSION);
    printf("Uso: fluxvm [opcoes] <arquivo.fvmbc>\n\n");
    printf("Opcoes de Execucao:\n");
    printf("  <arquivo.fvmbc>             Executa arquivo de bytecode localmente\n");
    printf("  --inject <arquivo.fvmbc>    Injeta bytecode no Servico Windows via Named Pipe\n");
    printf("  --bench                     Mede e exibe tempo de execucao e operacoes\n");
    printf("  --stdin <texto>             Injeta texto de entrada via argumento\n");
    printf("  --version, -v               Exibe versao da FVM\n");
    printf("  --help, -h                  Exibe esta mensagem de ajuda\n\n");
    printf("Opcoes do Servico Windows (SCM):\n");
    printf("  --service install           Instala o servico no Windows SCM\n");
    printf("  --service uninstall         Remove o servico do Windows SCM\n");
    printf("  --service start             Inicia o servico Windows\n");
    printf("  --service stop              Para o servico Windows\n");
    printf("  --service run               Executado internamente pelo Windows SCM\n");
    printf("  --daemon                    Inicia servidor residente em console (sem admin)\n");
}

static char *read_entire_file(const char *path) {
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (sz <= 0) { fclose(f); return NULL; }
    char *buf = (char *)malloc(sz + 1);
    if (!buf) { fclose(f); return NULL; }
    size_t rd = fread(buf, 1, sz, f);
    buf[rd] = '\0';
    fclose(f);
    return buf;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        print_usage();
        return 0;
    }

    const char *input_file = NULL;
    const char *stdin_text = NULL;
    bool flag_inject = false;
    bool flag_bench = false;
    bool flag_service = false;
    bool flag_daemon = false;
    const char *service_action = NULL;

    for (int i = 1; i < argc; i++) {
        const char *arg = argv[i];
        if (strcmp(arg, "--help") == 0 || strcmp(arg, "-h") == 0) {
            print_usage();
            return 0;
        } else if (strcmp(arg, "--version") == 0 || strcmp(arg, "-v") == 0) {
            printf("%s\n", FLUXVM_VERSION);
            return 0;
        } else if (strcmp(arg, "--bench") == 0) {
            flag_bench = true;
        } else if (strcmp(arg, "--inject") == 0) {
            flag_inject = true;
            if (i + 1 < argc && argv[i + 1][0] != '-') {
                input_file = argv[++i];
            }
        } else if (strcmp(arg, "--stdin") == 0) {
            if (i + 1 < argc) stdin_text = argv[++i];
        } else if (strcmp(arg, "--service") == 0) {
            flag_service = true;
            if (i + 1 < argc) service_action = argv[++i];
        } else if (strcmp(arg, "--daemon") == 0) {
            flag_daemon = true;
        } else if (arg[0] == '-') {
            /* Opcao desconhecida */
        } else {
            input_file = arg;
        }
    }

    /* 1. Gerenciamento do Servico Windows */
    if (flag_service && service_action) {
        wchar_t exe_path[MAX_PATH];
        GetModuleFileNameW(NULL, exe_path, MAX_PATH);

        if (strcmp(service_action, "install") == 0) {
            return flux_service_install(exe_path);
        } else if (strcmp(service_action, "uninstall") == 0) {
            return flux_service_uninstall();
        } else if (strcmp(service_action, "start") == 0) {
            return flux_service_start();
        } else if (strcmp(service_action, "stop") == 0) {
            return flux_service_stop();
        } else if (strcmp(service_action, "run") == 0) {
            return flux_service_run(fvm_execute_json_buffer);
        } else {
            fprintf(stderr, "Acao desconhecida de servico: %s\n", service_action);
            return 1;
        }
    }

    /* 2. Modo Daemon Console */
    if (flag_daemon) {
        return flux_daemon_run(fvm_execute_json_buffer);
    }

    if (!input_file) {
        fprintf(stderr, "Erro: Nenhum arquivo .fvmbc especificado.\n");
        return 1;
    }

    char *bc_json = read_entire_file(input_file);
    if (!bc_json) {
        fprintf(stderr, "Erro: Nao foi possivel abrir o arquivo: %s\n", input_file);
        return 1;
    }

    /* 3. Modo Injeção no Servico via Named Pipe */
    if (flag_inject) {
        FluxIpcResponse resp;
        int status = flux_ipc_inject(bc_json, stdin_text, &resp, 2000);
        if (status == 0) {
            /* Sucesso via IPC */
            if (resp.stdout_buf && resp.stdout_len > 0) {
                fwrite(resp.stdout_buf, 1, resp.stdout_len, stdout);
                fflush(stdout);
            }
            if (resp.stderr_buf && resp.stderr_len > 0) {
                fwrite(resp.stderr_buf, 1, resp.stderr_len, stderr);
                fflush(stderr);
            }
            if (flag_bench) {
                printf("\n[Bench IPC] Turnaround: %.2f ms | Codigo: %d\n",
                       (double)resp.elapsed_us / 1000.0, resp.exit_code);
            }
            int code = resp.exit_code;
            flux_ipc_response_free(&resp);
            free(bc_json);
            return code;
        } else {
            /* Fallback transparente para execucao local se servico nao estiver ativo */
            if (flag_bench) {
                fprintf(stderr, "[*] Servico inativo (IPC status %d). Executando localmente...\n", status);
            }
        }
    }

    /* 4. Execucao Local Standalone */
    FvmState vm;
    fvm_state_init(&vm, stdin_text, stdout);

    FvmProgram prog;
    if (fvm_program_load_json(&prog, &vm.arena, bc_json) != 0) {
        fprintf(stderr, "Erro: Falha ao interpretar bytecode .fvmbc\n");
        fvm_state_cleanup(&vm);
        free(bc_json);
        return 1;
    }

    LARGE_INTEGER t0, t1, freq;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&t0);

    int exit_code = fvm_execute_program(&vm, &prog);

    QueryPerformanceCounter(&t1);
    double elapsed_ms = (double)(t1.QuadPart - t0.QuadPart) * 1000.0 / (double)freq.QuadPart;

    if (flag_bench) {
        printf("\n[Bench Local] Tempo: %.3f ms | Instrucoes: %llu\n",
               elapsed_ms, (unsigned long long)vm.instruction_count);
    }

    fvm_state_cleanup(&vm);
    free(bc_json);
    return exit_code;
}
