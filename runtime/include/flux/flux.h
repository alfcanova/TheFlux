/* ==============================================================================
 * TheFlux Native Compiler Runtime: Master Aggregate Header
 * Header: runtime/include/flux/flux.h
 * ============================================================================== */

#ifndef FLUX_H
#define FLUX_H

#include "types.h"
#include "errors.h"
#include "memory.h"
#include "string.h"
#include "collections.h"
#include "tensor.h"
#include "io.h"
#include "sys.h"
#include "intrinsics.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime Initialization */
void flux_runtime_init(int argc, char **argv);
void flux_runtime_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_H */
