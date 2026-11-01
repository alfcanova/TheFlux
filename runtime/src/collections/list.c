/* ==============================================================================
 * TheFlux Native Runtime: Dynamic Vector / List (Conforming to Flux SIMD)
 * Source: runtime/src/collections/list.c
 * ============================================================================== */

#include "flux/collections.h"
#include "flux/types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void *flux_list_build(int64_t n, int64_t tag) {
    flux_simd_list_t *h = (flux_simd_list_t *)malloc(sizeof(flux_simd_list_t));
    if (!h) return NULL;
    int64_t cap = (n + 1 > 1) ? (n + 1) : 1;
    flux_simd_row_t *d = (flux_simd_row_t *)malloc((size_t)cap * sizeof(flux_simd_row_t));
    h->len = n;
    h->cap = cap;
    h->tag = tag;
    h->data_ptr = (int64_t)(uintptr_t)d;
    h->kind = 0; /* 0 = list */
    return h;
}

static void list_grow(flux_simd_list_t *lst, int64_t min_cap) {
    if (lst->cap >= min_cap) return;
    int64_t new_cap = lst->cap * 2;
    if (new_cap < min_cap) new_cap = min_cap;
    flux_simd_row_t *new_rows = (flux_simd_row_t *)realloc(
        (void *)(uintptr_t)lst->data_ptr,
        (size_t)new_cap * sizeof(flux_simd_row_t)
    );
    if (new_rows) {
        lst->data_ptr = (int64_t)(uintptr_t)new_rows;
        lst->cap = new_cap;
    }
}

void *flux_list_create(size_t initial_cap) {
    flux_simd_list_t *lst = (flux_simd_list_t *)flux_list_build(0, 0);
    if (lst && initial_cap > 1) {
        list_grow(lst, (int64_t)initial_cap);
    }
    return lst;
}

void *flux_list_push(void *list, int64_t tag, int64_t ival, const char *sval) {
    if (!list) return NULL;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    list_grow(l, l->len + 1);
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    int64_t n = l->len;
    rows[n].tag = tag;
    rows[n].val = (tag == 4 && sval) ? (int64_t)(uintptr_t)sval : ival;
    rows[n].sval = (int64_t)(uintptr_t)sval;
    l->len = n + 1;
    return list;
}

void flux_list_push_val(void *list, int64_t val) {
    flux_list_push(list, 1, val, NULL);
}

int64_t flux_list_get_val(void *list, int64_t index) {
    if (!list) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    /* TheFlux uses 1-based indexing for collections */
    if (index >= 1 && index <= l->len) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (!rows) return 0;
        return rows[index - 1].val;
    }
    /* 0-based fallback if index == 0 */
    if (index == 0 && l->len > 0) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (!rows) return 0;
        return rows[0].val;
    }
    return 0;
}

int64_t flux_list_len(void *list) {
    if (!list) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    return l->len;
}

void flux_list_print(void *p) {
    if (!p) {
        printf("[]\n");
        return;
    }
    flux_simd_list_t *list = (flux_simd_list_t *)p;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)list->data_ptr;
    printf("[");
    for (int64_t i = 0; i < list->len; i++) {
        if (i > 0) printf(", ");
        int64_t tag = rows[i].tag;
        int64_t val = rows[i].val;
        if (tag == 4) {
            char *s = (char *)(uintptr_t)val;
            printf("\"%s\"", s ? s : "");
        } else if (tag == 3) {
            double d;
            memcpy(&d, &val, sizeof(double));
            printf("%.17g", d);
        } else if (tag == 2) {
            printf("%s", val ? "true" : "false");
        } else {
            printf("%lld", (long long)val);
        }
    }
    printf("]\n");
}
