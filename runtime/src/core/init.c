/* ==============================================================================
 * TheFlux Native Runtime: Core Initialization & Global State
 * Source: runtime/src/core/init.c
 * ============================================================================== */

#include "flux/flux.h"
#include <stdlib.h>
#include <string.h>

static int s_argc = 0;
static char **s_argv = NULL;

void flux_runtime_init_args(int argc, char **argv) {
    s_argc = argc;
    s_argv = argv;
}

void flux_runtime_init(int argc, char **argv) {
    flux_runtime_init_args(argc, argv);
}

void flux_runtime_shutdown(void) {
    /* Cleanup any global state if necessary */
}

int flux_core_get_argc(void) {
    return s_argc;
}

char **flux_core_get_argv(void) {
    return s_argv;
}
