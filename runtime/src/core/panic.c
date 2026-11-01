/* ==============================================================================
 * TheFlux Native Runtime: Panic & Fatal Error Handling
 * Source: runtime/src/core/panic.c
 * ============================================================================== */

#include "flux/errors.h"
#include <stdio.h>
#include <stdlib.h>

void flux_panic(const char *message) {
    fprintf(stderr, "\n💥 [Flux Panic]: %s\n", message ? message : "Fatal unhandled exception");
    fflush(stderr);
    exit(1);
}

void flux_report_error(int error_code, const char *msg, const char *file, int line) {
    fprintf(stderr, "\n❌ [Flux Error %d] at %s:%d: %s\n", error_code, file ? file : "?", line, msg ? msg : "");
    fflush(stderr);
}
