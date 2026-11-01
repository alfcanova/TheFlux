/* ==============================================================================
 * TheFlux Native Runtime: Types & Definitions
 * Header: runtime/include/flux/types.h
 * ============================================================================== */

#ifndef FLUX_TYPES_H
#define FLUX_TYPES_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Type tags for dynamic/generic Flux values */
typedef enum {
    FLUX_TYPE_NIL = 0,
    FLUX_TYPE_BOOL,
    FLUX_TYPE_INT64,
    FLUX_TYPE_FLOAT64,
    FLUX_TYPE_STRING,
    FLUX_TYPE_LIST,
    FLUX_TYPE_MAP,
    FLUX_TYPE_SET,
    FLUX_TYPE_TENSOR,
    FLUX_TYPE_STRUCT,
    FLUX_TYPE_COMPLEX
} FluxTypeTag;

/* Tagged value representation */
typedef struct {
    FluxTypeTag tag;
    union {
        bool bval;
        int64_t ival;
        double fval;
        char *sval;
        void *pval;
        struct {
            double re;
            double im;
        } cval;
    } as;
} FluxValue;

/* Low-level runtime list / row representation */
typedef struct {
    int64_t tag;
    int64_t val;
    int64_t sval;
} flux_simd_row_t;

typedef struct {
    int64_t len;
    int64_t cap;
    int64_t tag;
    int64_t data_ptr;
    int64_t kind;
} flux_simd_list_t;

extern void *flux_list_build(int64_t n, int64_t tag);
extern void *flux_map_build(int64_t n);
extern void *flux_map_set(void *p, const char *key, int64_t vtag, int64_t vval);
extern int64_t flux_map_get(void *p, const char *key);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_TYPES_H */
