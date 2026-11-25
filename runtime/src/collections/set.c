/* ==============================================================================
 * TheFlux Native Runtime: String Set
 * Source: runtime/src/collections/set.c
 * ============================================================================== */

#include "flux/collections.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INITIAL_SET_CAP 16
#define FLUX_SET_MAGIC 0x4653455449445831ULL
#define FLUX_SET_HASH_THRESHOLD 8

typedef struct {
    size_t *slots;        /* 0 = empty, >0 = item_idx + 1 */
    uint32_t *item_hashes;
    size_t bucket_cap;
    size_t hash_cap;
} FluxSetHashIndex;

typedef struct {
    FluxSet base;
    uint64_t magic;
    FluxSetHashIndex *hash_idx;
} FluxSetObj;

extern uint32_t flux_str_hash(const char *s);

static FluxSetObj *as_set_obj(FluxSet *set) {
    if (!set) return NULL;
    FluxSetObj *obj = (FluxSetObj *)set;
    return (obj->magic == FLUX_SET_MAGIC) ? obj : NULL;
}

static bool set_index_rehash(FluxSetObj *obj, size_t new_bucket_cap) {
    if (!obj) return false;
    size_t need_ecap = obj->base.capacity > 16 ? obj->base.capacity : 16;
    FluxSetHashIndex *idx = obj->hash_idx;
    if (!idx) {
        idx = (FluxSetHashIndex *)calloc(1, sizeof(FluxSetHashIndex));
        if (!idx) return false;
        idx->hash_cap = need_ecap;
        idx->item_hashes = (uint32_t *)malloc(sizeof(uint32_t) * need_ecap);
        if (!idx->item_hashes) { free(idx); return false; }
        for (size_t i = 0; i < obj->base.count; i++) {
            idx->item_hashes[i] = flux_str_hash(obj->base.items[i]);
        }
        obj->hash_idx = idx;
    } else if (need_ecap > idx->hash_cap) {
        uint32_t *nh = (uint32_t *)realloc(idx->item_hashes, sizeof(uint32_t) * need_ecap);
        if (!nh) return false;
        idx->item_hashes = nh;
        idx->hash_cap = need_ecap;
    }

    size_t *new_slots = (size_t *)calloc(new_bucket_cap, sizeof(size_t));
    if (!new_slots) return false;
    size_t mask = new_bucket_cap - 1;
    for (size_t i = 0; i < obj->base.count; i++) {
        size_t pos = (size_t)idx->item_hashes[i] & mask;
        while (new_slots[pos] != 0) pos = (pos + 1) & mask;
        new_slots[pos] = i + 1;
    }
    free(idx->slots);
    idx->slots = new_slots;
    idx->bucket_cap = new_bucket_cap;
    return true;
}

FluxSet *flux_set_create(size_t initial_cap) {
    if (initial_cap == 0) initial_cap = INITIAL_SET_CAP;
    FluxSetObj *obj = (FluxSetObj *)malloc(sizeof(FluxSetObj));
    if (!obj) return NULL;
    obj->base.items = (char **)malloc(sizeof(char *) * initial_cap);
    if (!obj->base.items) { free(obj); return NULL; }
    obj->base.count = 0;
    obj->base.capacity = initial_cap;
    obj->magic = FLUX_SET_MAGIC;
    obj->hash_idx = NULL;
    return &obj->base;
}

static bool set_has_with_hash(FluxSet *set, const char *item, uint32_t *out_hash) {
    if (!set || !item) return false;
    char item_buf[32];
    if (!flux_is_readable_ptr(item, 1)) {
        snprintf(item_buf, sizeof(item_buf), "%lld", (long long)(intptr_t)item);
        item = item_buf;
    }
    FluxSetObj *obj = as_set_obj(set);
    if (obj && obj->hash_idx && obj->hash_idx->slots && obj->hash_idx->bucket_cap > 0) {
        uint32_t h = flux_str_hash(item);
        if (out_hash) *out_hash = h;
        FluxSetHashIndex *idx = obj->hash_idx;
        size_t mask = idx->bucket_cap - 1;
        size_t pos = (size_t)h & mask;
        for (;;) {
            size_t sv = idx->slots[pos];
            if (sv == 0) return false;
            size_t iidx = sv - 1;
            if (idx->item_hashes[iidx] == h && set->items[iidx] && flux_is_readable_ptr(set->items[iidx], 1) && strcmp(set->items[iidx], item) == 0) {
                return true;
            }
            pos = (pos + 1) & mask;
        }
    }
    for (size_t i = 0; i < set->count; i++) {
        if (set->items[i] && flux_is_readable_ptr(set->items[i], 1) && strcmp(set->items[i], item) == 0) return true;
    }
    return false;
}

void flux_set_add(FluxSet *set, const char *item) {
    if (!set || !item) return;
    char item_buf[32];
    if (!flux_is_readable_ptr(item, 1)) {
        snprintf(item_buf, sizeof(item_buf), "%lld", (long long)(intptr_t)item);
        item = item_buf;
    }
    uint32_t khash = 0;
    FluxSetObj *obj = as_set_obj(set);
    bool has_idx = (obj && obj->hash_idx && obj->hash_idx->slots != NULL);
    if (set_has_with_hash(set, item, has_idx ? &khash : NULL)) return;

    if (set->count >= set->capacity) {
        size_t new_cap = set->capacity * 2;
        char **new_items = (char **)realloc(set->items, sizeof(char *) * new_cap);
        if (!new_items) return;
        set->items = new_items;
        set->capacity = new_cap;
    }
    size_t idx_new = set->count;
    set->items[set->count++] = strdup(item);

    if (obj) {
        if (!obj->hash_idx) {
            if (set->count > FLUX_SET_HASH_THRESHOLD) {
                size_t bcap = 32;
                while (bcap * 7 < set->count * 10) bcap *= 2;
                set_index_rehash(obj, bcap);
            }
        } else {
            FluxSetHashIndex *hidx = obj->hash_idx;
            if (!has_idx) khash = flux_str_hash(item);
            if (idx_new >= hidx->hash_cap) {
                size_t nc = set->capacity > 16 ? set->capacity : 16;
                uint32_t *nh = (uint32_t *)realloc(hidx->item_hashes, sizeof(uint32_t) * nc);
                if (!nh) return;
                hidx->item_hashes = nh;
                hidx->hash_cap = nc;
            }
            hidx->item_hashes[idx_new] = khash;
            if (set->count * 10 >= hidx->bucket_cap * 7) {
                set_index_rehash(obj, hidx->bucket_cap * 2);
            } else {
                size_t mask = hidx->bucket_cap - 1;
                size_t pos = (size_t)khash & mask;
                while (hidx->slots[pos] != 0) pos = (pos + 1) & mask;
                hidx->slots[pos] = idx_new + 1;
            }
        }
    }
}

bool flux_set_has(FluxSet *set, const char *item) {
    return set_has_with_hash(set, item, NULL);
}

size_t flux_set_len(FluxSet *set) {
    return set ? set->count : 0;
}

void flux_set_free(FluxSet *set) {
    if (!set) return;
    FluxSetObj *obj = as_set_obj(set);
    if (obj && obj->hash_idx) {
        free(obj->hash_idx->slots);
        free(obj->hash_idx->item_hashes);
        free(obj->hash_idx);
        obj->hash_idx = NULL;
    }
    for (size_t i = 0; i < set->count; i++) {
        free(set->items[i]);
    }
    free(set->items);
    free(set);
}
