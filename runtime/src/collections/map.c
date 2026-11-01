/* ==============================================================================
 * TheFlux Native Runtime: Fast Map (List-backed map conforming to Flux SIMD)
 * Source: runtime/src/collections/map.c
 * ============================================================================== */

#include "flux/collections.h"
#include "flux/types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int64_t key_ptr;
    int64_t tag;
    int64_t val;
} flux_map_entry_t;

extern void *flux_list_build(int64_t n, int64_t tag);
extern int64_t flux_list_len(void *p);

void *flux_map_build(int64_t cap) {
    flux_simd_list_t *h = (flux_simd_list_t *)flux_list_build(cap > 0 ? cap : 8, 7);
    if (!h) return NULL;
    h->len = 0;
    h->kind = 2; /* 2 = map */
    return h;
}

static void map_grow(flux_simd_list_t *map, int64_t min_cap) {
    if (map->cap >= min_cap) return;
    int64_t new_cap = map->cap * 2;
    if (new_cap < min_cap) new_cap = min_cap;
    flux_map_entry_t *new_entries = (flux_map_entry_t *)realloc(
        (void *)(uintptr_t)map->data_ptr,
        (size_t)new_cap * sizeof(flux_map_entry_t)
    );
    if (new_entries) {
        map->data_ptr = (int64_t)(uintptr_t)new_entries;
        map->cap = new_cap;
    }
}

static int64_t map_find_entry(flux_simd_list_t *map, const char *key) {
    if (!map || !key || map->len <= 0 || !map->data_ptr) return -1;
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    for (int64_t i = 0; i < map->len; i++) {
        const char *k = (const char *)(uintptr_t)entries[i].key_ptr;
        if (k && strcmp(k, key) == 0) {
            return i;
        }
    }
    return -1;
}

void *flux_map_set(void *p, const char *key, int64_t vtag, int64_t vval) {
    if (!p || !key) return p;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    int64_t idx = map_find_entry(map, key);
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    if (idx >= 0) {
        entries[idx].tag = vtag;
        entries[idx].val = vval;
        return p;
    }
    map_grow(map, map->len + 1);
    entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    int64_t n = map->len;
    entries[n].key_ptr = (int64_t)(uintptr_t)strdup(key);
    entries[n].tag = vtag;
    entries[n].val = vval;
    map->len = n + 1;
    return p;
}

int64_t flux_map_get(void *p, const char *key) {
    if (!p || !key) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        return entries[idx].val;
    }
    return 0;
}

int64_t flux_map_get_tag(void *p, const char *key) {
    if (!p || !key) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        return entries[idx].tag;
    }
    return 0;
}

bool flux_map_contains_key(void *p, const char *key) {
    if (!p || !key) return false;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    return map_find_entry(map, key) >= 0;
}

size_t flux_map_len(void *p) {
    if (!p) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    return (size_t)map->len;
}

void flux_hashmap_set_val(void *map, const char *key, int64_t val) {
    flux_map_set(map, key, 1, val);
}

int64_t flux_hashmap_get_val(void *map, const char *key) {
    return flux_map_get(map, key);
}

void flux_map_print(void *p) {
    if (!p) {
        printf("{}\n");
        return;
    }
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    printf("{");
    for (int64_t i = 0; i < map->len; i++) {
        if (i > 0) printf(", ");
        const char *k = (const char *)(uintptr_t)entries[i].key_ptr;
        printf("\"%s\": ", k ? k : "");
        int64_t tag = entries[i].tag;
        int64_t val = entries[i].val;
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
    printf("}\n");
}
