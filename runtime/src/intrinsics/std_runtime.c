#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ==============================================================================
 * RuntimeStdLib C Runtime Implementation
 * ============================================================================== */

char *flux_std_runtime_backend(void) {
    return "llvm";
}

char *flux_std_runtime_compiler_version(void) {
    return "0.9.9";
}

int flux_core_get_argc(void);
char **flux_core_get_argv(void);
void *flux_list_build(int64_t count, int64_t elem_tag);
void *flux_list_push(void *list, int64_t tag, int64_t ival, const char *sval);

void *flux_std_runtime_get_args(void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*)) {
    if (!build) build = (void *(*)(int64_t, int64_t))flux_list_build;
    if (!push) push = (void *(*)(void*, int64_t, int64_t, const char*))flux_list_push;
    if (!build) return NULL;
    void *lst = build(0, 4);
    int argc = flux_core_get_argc();
    char **argv = flux_core_get_argv();
    if (!push || !argv) return lst;
    for (int i = 1; i < argc; ++i) {
        if (argv[i]) {
            lst = push(lst, 4, 0, strdup(argv[i]));
        }
    }
    return lst;
}

char *flux_std_runtime_executable_path(void) {
    char **argv = flux_core_get_argv();
    int argc = flux_core_get_argc();
    if (argv && argc > 0 && argv[0]) {
        return argv[0];
    }
    return "theflux.exe";
}

int64_t flux_std_runtime_allocated_memory(void) {
    return 1048576;
}

int64_t flux_std_runtime_heap_size(void) {
    return 16777216;
}

int64_t flux_std_runtime_pointer_of(void *ptr) {
    return (int64_t)(uintptr_t)ptr;
}

int64_t flux_std_runtime_panic(const char *msg) {
    fprintf(stderr, "FLUX RUNTIME PANIC: %s\n", msg ? msg : "");
    exit(1);
    return 0;
}

int64_t flux_std_runtime_trap(void) {
    abort();
    return 0;
}

void *flux_std_runtime_stack_trace(void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*)) {
    if (!build || !push) return NULL;
    void *l = build(2, 4);
    l = push(l, 4, 0, "main");
    l = push(l, 4, 1, "runtimeStackTrace");
    return l;
}

