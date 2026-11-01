/* ==============================================================================
 * TheFlux Native Runtime: System, Process, Environment & Time
 * Header: runtime/include/flux/sys.h
 * ============================================================================== */

#ifndef FLUX_SYS_H
#define FLUX_SYS_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime Arg Init & Inspection */
void flux_runtime_init_args(int argc, char **argv);
void *flux_std_runtime_get_args(void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*));

/* Process & OS Execution */
int64_t flux_std_os_exec(const char *cmd);
int64_t flux_std_os_exit(int64_t code);
char *flux_std_os_get_env(const char *key);
int64_t flux_std_os_set_env(const char *key, const char *val);
int64_t flux_std_os_get_pid(void);
char *flux_std_os_platform(void);
char *flux_std_os_arch(void);

/* DateTime Functions */
int64_t flux_std_datetime_now(void);
char *flux_std_datetime_to_iso8601(int64_t epoch_sec);
int64_t flux_std_datetime_from_iso8601(const char *iso);
int64_t flux_std_datetime_monotonic_ms(void);
int64_t flux_std_datetime_monotonic_now(void);
int64_t flux_std_datetime_monotonic_elapsed(int64_t start_ns);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_SYS_H */
