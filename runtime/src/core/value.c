/* ==============================================================================
 * TheFlux Native Runtime: Value Boxing & Coercion
 * Source: runtime/src/core/value.c
 * ============================================================================== */

#include "flux/types.h"
#include <stdlib.h>
#include <string.h>

FluxValue flux_val_int(int64_t val) {
    FluxValue v;
    v.tag = FLUX_TYPE_INT64;
    v.as.ival = val;
    return v;
}

FluxValue flux_val_float(double val) {
    FluxValue v;
    v.tag = FLUX_TYPE_FLOAT64;
    v.as.fval = val;
    return v;
}

FluxValue flux_val_bool(bool val) {
    FluxValue v;
    v.tag = FLUX_TYPE_BOOL;
    v.as.bval = val;
    return v;
}

FluxValue flux_val_string(char *val) {
    FluxValue v;
    v.tag = FLUX_TYPE_STRING;
    v.as.sval = val;
    return v;
}

FluxValue flux_val_nil(void) {
    FluxValue v;
    v.tag = FLUX_TYPE_NIL;
    v.as.pval = NULL;
    return v;
}
