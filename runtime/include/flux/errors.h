/* ==============================================================================
 * TheFlux Native Runtime: Error Codes & Diagnostic Definitions
 * Header: runtime/include/flux/errors.h
 * ============================================================================== */

#ifndef FLUX_RT_ERRORS_H
#define FLUX_RT_ERRORS_H

#include "types.h"
#include "../../flux_errors.h"

#ifdef __cplusplus
extern "C" {
#endif

void flux_panic(const char *message);
void flux_report_error(int error_code, const char *msg, const char *file, int line);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_RT_ERRORS_H */
