/* ==============================================================================
 * TheFlux Windows Service & Named Pipe IPC Bridge
 * Header: runtime/flux_service.h
 * ============================================================================== */

#ifndef FLUX_SERVICE_H
#define FLUX_SERVICE_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#define FLUX_PIPE_NAME L"\\\\.\\pipe\\theflux_fvm"
#define FLUX_SERVICE_NAME L"TheFluxFvmService"
#define FLUX_SERVICE_DISPLAY L"TheFlux Virtual Machine Service"

#define FLUX_IPC_MAGIC 0x494D5646 /* 'FVMI' in little-endian */
#define FLUX_IPC_VERSION 1

/* Struct de resposta da execução IPC */
typedef struct {
    int32_t exit_code;
    uint64_t elapsed_us;
    char *stdout_buf;
    size_t stdout_len;
    char *stderr_buf;
    size_t stderr_len;
} FluxIpcResponse;

/* Callback de execução de bytecode pelo servidor */
typedef int (*FluxBytecodeExecutorFn)(
    const char *bytecode_json,
    const char *stdin_text,
    char **out_stdout,
    size_t *out_stdout_len,
    char **out_stderr,
    size_t *out_stderr_len
);

/* Windows Service Management */
int flux_service_install(const wchar_t *exe_path);
int flux_service_uninstall(void);
int flux_service_start(void);
int flux_service_stop(void);
int flux_service_run(FluxBytecodeExecutorFn executor);

/* Daemon Mode (Background Named Pipe Server sem privilégios de admin) */
int flux_daemon_run(FluxBytecodeExecutorFn executor);
int flux_daemon_stop(void);

/* Named Pipe Client (Injetor de Bytecode) */
int flux_ipc_inject(
    const char *bytecode_json,
    const char *stdin_text,
    FluxIpcResponse *response,
    int timeout_ms
);

void flux_ipc_response_free(FluxIpcResponse *resp);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_SERVICE_H */
