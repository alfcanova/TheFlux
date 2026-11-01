/* ==============================================================================
 * TheFlux Native Runtime: Dynamic Vector / List
 * Source: runtime/src/collections/list.c
 * ============================================================================== */

#include "flux/collections.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INITIAL_LIST_CAP 8

FluxList *flux_list_create(size_t initial_cap) {
    if (initial_cap == 0) initial_cap = INITIAL_LIST_CAP;
    FluxList *list = (FluxList *)malloc(sizeof(FluxList));
    if (!list) return NULL;
    list->items = (FluxValue *)malloc(sizeof(FluxValue) * initial_cap);
    list->length = 0;
    list->capacity = initial_cap;
    return list;
}

void flux_list_append(FluxList *list, FluxValue val) {
    if (!list) return;
    if (list->length >= list->capacity) {
        size_t new_cap = list->capacity * 2;
        FluxValue *new_items = (FluxValue *)realloc(list->items, sizeof(FluxValue) * new_cap);
        if (!new_items) return;
        list->items = new_items;
        list->capacity = new_cap;
    }
    list->items[list->length++] = val;
}

FluxValue flux_list_get(FluxList *list, size_t index) {
    if (!list || index >= list->length) {
        FluxValue nil_val;
        nil_val.tag = FLUX_TYPE_NIL;
        nil_val.as.pval = NULL;
        return nil_val;
    }
    return list->items[index];
}

void flux_list_set(FluxList *list, size_t index, FluxValue val) {
    if (!list || index >= list->length) return;
    list->items[index] = val;
}

size_t flux_list_count(FluxList *list) {
    return list ? list->length : 0;
}

void flux_list_free(FluxList *list) {
    if (!list) return;
    if (list->items) free(list->items);
    free(list);
}

void *flux_list_build(int64_t cap, int64_t elem_tag) {
    (void)elem_tag;
    return flux_list_create((size_t)(cap > 0 ? cap : 16));
}

void flux_list_push_val(void *list, int64_t val) {
    if (!list) return;
    FluxList *l = (FluxList *)list;
    FluxValue v;
    v.tag = FLUX_TYPE_INT64;
    v.as.ival = val;
    flux_list_append(l, v);
}

int64_t flux_list_get_val(void *list, int64_t index) {
    if (!list) return 0;
    FluxList *l = (FluxList *)list;
    if (index >= 1 && (size_t)index <= l->length) {
        return l->items[index - 1].as.ival;
    }
    if (index >= 0 && (size_t)index < l->length) {
        return l->items[index].as.ival;
    }
    return 0;
}

int64_t flux_list_len(void *list) {
    if (!list) return 0;
    FluxList *l = (FluxList *)list;
    return (int64_t)l->length;
}

void flux_list_print(void *p) {
    if (!p) {
        printf("[]\n");
        return;
    }
    FluxList *list = (FluxList *)p;
    printf("[");
    for (size_t i = 0; i < list->length; i++) {
        if (i > 0) printf(", ");
        FluxValue v = list->items[i];
        if (v.tag == FLUX_TYPE_STRING) {
            printf("\"%s\"", v.as.sval ? v.as.sval : "");
        } else if (v.tag == FLUX_TYPE_FLOAT64) {
            printf("%.17g", v.as.fval);
        } else if (v.tag == FLUX_TYPE_BOOL) {
            printf("%s", v.as.bval ? "true" : "false");
        } else {
            printf("%lld", (long long)v.as.ival);
        }
    }
    printf("]\n");
}
