/* ==============================================================================
 * TheFlux Native Runtime: Math, 128-bit Integer & SIMD Helpers
 * Source: runtime/src/intrinsics/std_math.c
 * ============================================================================== */

#include "flux/types.h"
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

/* 128-bit Integer Division and Modulo Runtime Support for Clang/LLVM */
typedef unsigned __int128 u128;
typedef __int128 i128;

static u128 _udivmod128(u128 n, u128 d, u128 *rem) {
    if (d == 0) {
        if (rem) *rem = 0;
        return 0;
    }
    u128 q = 0;
    u128 r = 0;
    for (int i = 127; i >= 0; i--) {
        r = (r << 1) | ((n >> i) & 1);
        if (r >= d) {
            r -= d;
            q |= ((u128)1 << i);
        }
    }
    if (rem) *rem = r;
    return q;
}

i128 __divti3(i128 a, i128 b) {
    int neg = 0;
    u128 ua = (u128)a;
    u128 ub = (u128)b;
    if (a < 0) { ua = (u128)(-a); neg = !neg; }
    if (b < 0) { ub = (u128)(-b); neg = !neg; }
    u128 uq = _udivmod128(ua, ub, NULL);
    return neg ? -(i128)uq : (i128)uq;
}

i128 __modti3(i128 a, i128 b) {
    int neg = 0;
    u128 ua = (u128)a;
    u128 ub = (u128)b;
    if (a < 0) { ua = (u128)(-a); neg = 1; }
    if (b < 0) { ub = (u128)(-b); }
    u128 ur = 0;
    _udivmod128(ua, ub, &ur);
    return neg ? -(i128)ur : (i128)ur;
}

u128 __udivti3(u128 a, u128 b) {
    return _udivmod128(a, b, NULL);
}

u128 __umodti3(u128 a, u128 b) {
    u128 rem = 0;
    _udivmod128(a, b, &rem);
    return rem;
}

u128 __udivmodti4(u128 a, u128 b, u128 *rem) {
    return _udivmod128(a, b, rem);
}

/* SimdStdLib LLVM C Runtime Helpers */
static inline double flux_simd_extract_double(flux_simd_list_t *lst, int64_t idx) {
    if (!lst || idx < 0 || idx >= lst->len) return 0.0;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)lst->data_ptr;
    if (!rows) return 0.0;
    if (rows[idx].tag == 3) {
        double d;
        memcpy(&d, &rows[idx].val, sizeof(double));
        return d;
    } else {
        return (double)rows[idx].val;
    }
}

static inline void flux_simd_insert_double(flux_simd_list_t *lst, int64_t idx, double d, int64_t is_f32) {
    if (!lst || idx < 0 || idx >= lst->len) return;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)lst->data_ptr;
    if (!rows) return;
    if (is_f32) {
        float f = (float)d;
        d = (double)f;
    }
    rows[idx].tag = 3;
    memcpy(&rows[idx].val, &d, sizeof(double));
    rows[idx].sval = 0;
}

static inline void flux_simd_insert_int(flux_simd_list_t *lst, int64_t idx, int64_t v) {
    if (!lst || idx < 0 || idx >= lst->len) return;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)lst->data_ptr;
    if (!rows) return;
    rows[idx].tag = 0;
    rows[idx].val = v;
    rows[idx].sval = 0;
}

void *flux_std_simd_vector_binop(void *a, void *b, int64_t op, int64_t is_f32) {
    flux_simd_list_t *la = (flux_simd_list_t *)a;
    flux_simd_list_t *lb = (flux_simd_list_t *)b;
    int64_t na = la ? la->len : 0;
    int64_t nb = lb ? lb->len : 0;
    int64_t n = na < nb ? na : nb;
    flux_simd_list_t *out = (flux_simd_list_t *)flux_list_build(n, 3);
    for (int64_t i = 0; i < n; i++) {
        double va = flux_simd_extract_double(la, i);
        double vb = flux_simd_extract_double(lb, i);
        double res = 0.0;
        switch (op) {
            case 0: res = va + vb; break;
            case 1: res = va - vb; break;
            case 2: res = va * vb; break;
            case 3: res = (vb != 0.0) ? (va / vb) : 0.0; break;
            default: res = va + vb; break;
        }
        flux_simd_insert_double(out, i, res, is_f32);
    }
    return out;
}

double flux_std_simd_dot_product(void *a, void *b, int64_t is_f32) {
    flux_simd_list_t *la = (flux_simd_list_t *)a;
    flux_simd_list_t *lb = (flux_simd_list_t *)b;
    int64_t na = la ? la->len : 0;
    int64_t nb = lb ? lb->len : 0;
    int64_t n = na < nb ? na : nb;
    double total = 0.0;
    for (int64_t i = 0; i < n; i++) {
        double va = flux_simd_extract_double(la, i);
        double vb = flux_simd_extract_double(lb, i);
        total += va * vb;
    }
    if (is_f32) {
        float f = (float)total;
        return (double)f;
    }
    return total;
}

double flux_std_simd_vector_sum(void *a, int64_t is_f32) {
    flux_simd_list_t *la = (flux_simd_list_t *)a;
    int64_t n = la ? la->len : 0;
    double total = 0.0;
    for (int64_t i = 0; i < n; i++) {
        total += flux_simd_extract_double(la, i);
    }
    if (is_f32) {
        float f = (float)total;
        return (double)f;
    }
    return total;
}

void *flux_std_simd_vector_clamp(void *a, double min_v, double max_v, int64_t is_f32) {
    flux_simd_list_t *la = (flux_simd_list_t *)a;
    int64_t n = la ? la->len : 0;
    flux_simd_list_t *out = (flux_simd_list_t *)flux_list_build(n, 3);
    for (int64_t i = 0; i < n; i++) {
        double val = flux_simd_extract_double(la, i);
        if (val < min_v) val = min_v;
        if (val > max_v) val = max_v;
        flux_simd_insert_double(out, i, val, is_f32);
    }
    return out;
}

void *flux_std_simd_select(void *mask, void *a, void *b, int64_t is_f32) {
    flux_simd_list_t *lm = (flux_simd_list_t *)mask;
    flux_simd_list_t *la = (flux_simd_list_t *)a;
    flux_simd_list_t *lb = (flux_simd_list_t *)b;
    int64_t nm = lm ? lm->len : 0;
    int64_t na = la ? la->len : 0;
    int64_t nb = lb ? lb->len : 0;
    int64_t n = nm < na ? nm : na;
    if (nb < n) n = nb;
    flux_simd_list_t *out = (flux_simd_list_t *)flux_list_build(n, 3);
    for (int64_t i = 0; i < n; i++) {
        flux_simd_row_t *mrows = (flux_simd_row_t *)(uintptr_t)lm->data_ptr;
        int cond = (mrows && mrows[i].val != 0);
        double val = cond ? flux_simd_extract_double(la, i) : flux_simd_extract_double(lb, i);
        flux_simd_insert_double(out, i, val, is_f32);
    }
    return out;
}

void *flux_std_simd_matrix_mul_2d(void *lhs, void *rhs, int64_t is_f32) {
    flux_simd_list_t *ml = (flux_simd_list_t *)lhs;
    flux_simd_list_t *mr = (flux_simd_list_t *)rhs;
    if (!ml || !mr) return flux_map_build(0);

    flux_simd_list_t *shape_l = (flux_simd_list_t *)(uintptr_t)flux_map_get(lhs, "shape");
    flux_simd_list_t *shape_r = (flux_simd_list_t *)(uintptr_t)flux_map_get(rhs, "shape");
    flux_simd_list_t *data_l = (flux_simd_list_t *)(uintptr_t)flux_map_get(lhs, "data");
    flux_simd_list_t *data_r = (flux_simd_list_t *)(uintptr_t)flux_map_get(rhs, "data");

    flux_simd_row_t *sl_rows = shape_l ? (flux_simd_row_t *)(uintptr_t)shape_l->data_ptr : NULL;
    flux_simd_row_t *sr_rows = shape_r ? (flux_simd_row_t *)(uintptr_t)shape_r->data_ptr : NULL;
    int64_t rows_l = (sl_rows && shape_l->len > 0) ? sl_rows[0].val : 1;
    int64_t cols_l = (sl_rows && shape_l->len > 1) ? sl_rows[1].val : 1;
    int64_t rows_r = (sr_rows && shape_r->len > 0) ? sr_rows[0].val : 1;
    int64_t cols_r = (sr_rows && shape_r->len > 1) ? sr_rows[1].val : 1;

    int64_t total_out = rows_l * cols_r;
    flux_simd_list_t *out_data = (flux_simd_list_t *)flux_list_build(total_out, 3);
    for (int64_t i = 0; i < rows_l; i++) {
        for (int64_t j = 0; j < cols_r; j++) {
            double sum = 0.0;
            for (int64_t k = 0; k < cols_l; k++) {
                int64_t idx_l = i * cols_l + k;
                int64_t idx_r = k * cols_r + j;
                double vl = flux_simd_extract_double(data_l, idx_l);
                double vr = flux_simd_extract_double(data_r, idx_r);
                sum += vl * vr;
            }
            flux_simd_insert_double(out_data, i * cols_r + j, sum, is_f32);
        }
    }

    flux_simd_list_t *out_shape = (flux_simd_list_t *)flux_list_build(2, 0);
    flux_simd_insert_int(out_shape, 0, rows_l);
    flux_simd_insert_int(out_shape, 1, cols_r);

    flux_simd_list_t *out_strides = (flux_simd_list_t *)flux_list_build(2, 0);
    flux_simd_insert_int(out_strides, 0, cols_r);
    flux_simd_insert_int(out_strides, 1, 1);

    void *out_map = flux_map_build(0);
    flux_map_set(out_map, "ndim", 0, 2);
    flux_map_set(out_map, "shape", 5, (int64_t)(uintptr_t)out_shape);
    flux_map_set(out_map, "strides", 5, (int64_t)(uintptr_t)out_strides);
    flux_map_set(out_map, "offset", 0, 1);
    flux_map_set(out_map, "data", 5, (int64_t)(uintptr_t)out_data);

    return out_map;
}
