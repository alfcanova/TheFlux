/* ==============================================================================
 * TheFlux Native Runtime: Fast Map (List-backed map conforming to Flux SIMD)
 * Source: runtime/src/collections/map.c
 * ============================================================================== */

#include "flux/collections.h"
#include "flux/memory.h"
#include "flux/types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int64_t key_ptr;
    int64_t tag;
    int64_t val;
} flux_map_entry_t;

#define FLUX_MAP_MAX_CAP 1000000LL
#define FLUX_MAP_MAGIC 0x464D415049445831ULL
#define FLUX_MAP_HASH_THRESHOLD 8

typedef struct {
    int64_t *slots;        /* 0 = empty, >0 = entry_index + 1 */
    uint32_t *entry_hashes;
    uint32_t bucket_cap;   /* always power of 2 */
    uint32_t entry_cap;
} FluxMapHashIndex;

typedef struct {
    flux_simd_list_t hdr;
    uint64_t magic;
    FluxMapHashIndex *hash_idx;
} FluxMapObj;

extern uint32_t flux_str_hash(const char *s);
extern int64_t flux_list_len(void *p);

static FluxMapObj *as_map_obj(flux_simd_list_t *map) {
    if (!map || map->kind != 2) return NULL;
    FluxMapObj *obj = (FluxMapObj *)map;
    if (obj->magic == FLUX_MAP_MAGIC) return obj;
    return NULL;
}

static bool map_index_rehash(FluxMapObj *obj, uint32_t new_bucket_cap) {
    if (!obj) return false;
    uint32_t new_ecap = (uint32_t)(obj->hdr.cap > 16 ? obj->hdr.cap : 16);
    FluxMapHashIndex *idx = obj->hash_idx;
    if (!idx) {
        idx = (FluxMapHashIndex *)calloc(1, sizeof(FluxMapHashIndex));
        if (!idx) return false;
        idx->entry_cap = new_ecap;
        idx->entry_hashes = (uint32_t *)malloc((size_t)new_ecap * sizeof(uint32_t));
        if (!idx->entry_hashes) { free(idx); return false; }
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)obj->hdr.data_ptr;
        for (int64_t i = 0; i < obj->hdr.len; i++) {
            const char *k = entries ? (const char *)(uintptr_t)entries[i].key_ptr : NULL;
            idx->entry_hashes[i] = flux_str_hash(k);
        }
        obj->hash_idx = idx;
    } else if (new_ecap > idx->entry_cap) {
        uint32_t *nh = (uint32_t *)realloc(idx->entry_hashes, (size_t)new_ecap * sizeof(uint32_t));
        if (!nh) return false;
        idx->entry_hashes = nh;
        idx->entry_cap = new_ecap;
    }

    int64_t *new_slots = (int64_t *)calloc((size_t)new_bucket_cap, sizeof(int64_t));
    if (!new_slots) return false;
    uint32_t mask = new_bucket_cap - 1;
    for (int64_t i = 0; i < obj->hdr.len; i++) {
        uint32_t pos = idx->entry_hashes[i] & mask;
        while (new_slots[pos] != 0) {
            pos = (pos + 1) & mask;
        }
        new_slots[pos] = i + 1;
    }
    free(idx->slots);
    idx->slots = new_slots;
    idx->bucket_cap = new_bucket_cap;
    return true;
}

void *flux_map_build(int64_t cap) {
    int64_t init_cap = cap > 0 ? cap : 8;
    FluxMapObj *obj = (FluxMapObj *)flux_tls_obj_alloc(sizeof(FluxMapObj));
    if (!obj) return NULL;
    flux_map_entry_t *d = (flux_map_entry_t *)malloc((size_t)init_cap * sizeof(flux_map_entry_t));
    if (!d) {
        return NULL;
    }
    obj->hdr.len = 0;
    obj->hdr.cap = init_cap;
    obj->hdr.tag = 7;
    obj->hdr.data_ptr = (int64_t)(uintptr_t)d;
    obj->hdr.kind = 2; /* 2 = map */
    obj->magic = FLUX_MAP_MAGIC;
    obj->hash_idx = NULL;
    return &obj->hdr;
}

static void map_grow(flux_simd_list_t *map, int64_t min_cap) {
    if (!map) return;
    if (min_cap <= 0 || min_cap > FLUX_MAP_MAX_CAP) return;
    if (map->cap >= min_cap) return;
    int64_t new_cap = map->cap * 2;
    if (new_cap < min_cap) new_cap = min_cap;
    if (new_cap > FLUX_MAP_MAX_CAP) new_cap = FLUX_MAP_MAX_CAP;
    if (new_cap < min_cap) return;
    flux_map_entry_t *new_entries = (flux_map_entry_t *)realloc(
        (void *)(uintptr_t)map->data_ptr,
        (size_t)new_cap * sizeof(flux_map_entry_t)
    );
    if (new_entries) {
        map->data_ptr = (int64_t)(uintptr_t)new_entries;
        map->cap = new_cap;
    }
}

static int64_t map_find_entry_hash(flux_simd_list_t *map, const char *key, uint32_t *out_hash) {
    if (!map || !key || map->len <= 0 || !map->data_ptr) {
        if (out_hash && key && flux_is_readable_ptr(key, 1)) *out_hash = flux_str_hash(key);
        else if (out_hash) *out_hash = 0;
        return -1;
    }
    char key_buf[32];
    if (!flux_is_readable_ptr(key, 1)) {
        snprintf(key_buf, sizeof(key_buf), "%lld", (long long)(intptr_t)key);
        key = key_buf;
    }
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    FluxMapObj *obj = as_map_obj(map);
    if (obj && obj->hash_idx && obj->hash_idx->slots && obj->hash_idx->bucket_cap > 0) {
        uint32_t h = flux_str_hash(key);
        if (out_hash) *out_hash = h;
        FluxMapHashIndex *idx = obj->hash_idx;
        uint32_t mask = idx->bucket_cap - 1;
        uint32_t pos = h & mask;
        for (;;) {
            int64_t sv = idx->slots[pos];
            if (sv == 0) return -1;
            int64_t eidx = sv - 1;
            if (idx->entry_hashes[eidx] == h) {
                const char *k = (const char *)(uintptr_t)entries[eidx].key_ptr;
                if (k && flux_is_readable_ptr(k, 1) && strcmp(k, key) == 0) return eidx;
            }
            pos = (pos + 1) & mask;
        }
    }
    for (int64_t i = 0; i < map->len; i++) {
        const char *k = (const char *)(uintptr_t)entries[i].key_ptr;
        if (k && flux_is_readable_ptr(k, 1) && strcmp(k, key) == 0) {
            return i;
        }
    }
    return -1;
}

static int64_t map_find_entry(flux_simd_list_t *map, const char *key) {
    return map_find_entry_hash(map, key, NULL);
}

extern char *flux_float_to_str(double d);
extern char *flux_set_to_str(void *p);
extern char *flux_val_to_str(int64_t val);
extern double flux_val_to_float(int64_t val);
extern bool flux_is_cstr_ptr(const void *p);
extern void flux_set_last_tag(int64_t tag, int64_t val);
extern int64_t flux_infer_tag(int64_t tag, int64_t val);

void *flux_map_set(void *p, const char *key, int64_t vtag, int64_t vval) {
    if (!p || !key) return p;
    char key_buf[32];
    if (!flux_is_readable_ptr(key, 1)) {
        snprintf(key_buf, sizeof(key_buf), "%lld", (long long)(intptr_t)key);
        key = key_buf;
    }
    vtag = flux_infer_tag(vtag, vval);
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    uint32_t khash = 0;
    bool has_hash = false;
    FluxMapObj *obj = as_map_obj(map);
    if (obj && obj->hash_idx && obj->hash_idx->slots) {
        has_hash = true;
    }
    int64_t idx = map_find_entry_hash(map, key, has_hash ? &khash : NULL);
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    if (idx >= 0) {
        if (entries) {
            entries[idx].tag = vtag;
            entries[idx].val = vval;
        }
        return p;
    }
    if (map->len >= FLUX_MAP_MAX_CAP) return p;
    map_grow(map, map->len + 1);
    if (map->cap < map->len + 1) return p;
    entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    if (!entries) return p;
    int64_t n = map->len;
    entries[n].key_ptr = (int64_t)(uintptr_t)flux_tls_str_dup(key);
    entries[n].tag = vtag;
    entries[n].val = vval;
    map->len = n + 1;

    if (obj) {
        if (!obj->hash_idx) {
            if (map->len > FLUX_MAP_HASH_THRESHOLD) {
                uint32_t bcap = 32;
                while ((int64_t)bcap * 7 < map->len * 10) bcap *= 2;
                map_index_rehash(obj, bcap);
            }
        } else {
            FluxMapHashIndex *hidx = obj->hash_idx;
            if (!has_hash) khash = flux_str_hash(key);
            if ((uint32_t)n >= hidx->entry_cap) {
                uint32_t ne = (uint32_t)(map->cap > 16 ? map->cap : 16);
                uint32_t *nh = (uint32_t *)realloc(hidx->entry_hashes, (size_t)ne * sizeof(uint32_t));
                if (!nh) return p;
                hidx->entry_hashes = nh;
                hidx->entry_cap = ne;
            }
            hidx->entry_hashes[n] = khash;
            if (map->len * 10 >= (int64_t)hidx->bucket_cap * 7) {
                map_index_rehash(obj, hidx->bucket_cap * 2);
            } else {
                uint32_t mask = hidx->bucket_cap - 1;
                uint32_t pos = khash & mask;
                while (hidx->slots[pos] != 0) pos = (pos + 1) & mask;
                hidx->slots[pos] = n + 1;
            }
        }
    }
    return p;
}

int64_t flux_map_get(void *p, const char *key) {
    if (!p || !key || !flux_is_collection_ptr(p, 2)) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        flux_set_last_tag(entries[idx].tag, entries[idx].val);
        return entries[idx].val;
    }
    flux_set_last_tag(0, 0);
    return 0;
}

double flux_map_get_float(void *p, const char *key) {
    if (!p || !key || !flux_is_collection_ptr(p, 2)) return 0.0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        int64_t tag = entries[idx].tag;
        int64_t val = entries[idx].val;
        flux_set_last_tag(tag, val);
        if (tag == 3) {
            double d = 0.0;
            memcpy(&d, &val, sizeof(double));
            return d;
        }
        if (tag == 2 || tag == 1) {
            return (double)val;
        }
        return flux_val_to_float(val);
    }
    return 0.0;
}

void *flux_list_to_map(void *list) {
    void *m = flux_map_build(8);
    if (!list || !m) return m;
    if (flux_is_collection_ptr(list, 2)) {
        flux_simd_list_t *src = (flux_simd_list_t *)list;
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)src->data_ptr;
        for (int64_t i = 0; i < src->len; i++) {
            const char *k = (const char *)(uintptr_t)entries[i].key_ptr;
            if (k) flux_map_set(m, k, entries[i].tag, entries[i].val);
        }
        return m;
    }
    if (flux_is_collection_ptr(list, 0) || flux_is_collection_ptr(list, 1)) {
        flux_simd_list_t *lst = (flux_simd_list_t *)list;
        flux_simd_row_t *rows = lst->data_ptr ? (flux_simd_row_t *)(uintptr_t)lst->data_ptr : NULL;
        if (!rows) return m;
        for (int64_t i = 0; i < lst->len; i++) {
            int64_t ev = rows[i].val;
            int64_t et = rows[i].tag;
            const void *ep = (const void *)(uintptr_t)ev;
            if (flux_is_collection_ptr(ep, 0)) {
                flux_simd_list_t *pl = (flux_simd_list_t *)ep;
                flux_simd_row_t *pr = pl->data_ptr ? (flux_simd_row_t *)(uintptr_t)pl->data_ptr : NULL;
                if (pr && pl->len >= 2) {
                    int64_t kv = pr[0].val;
                    int64_t kt = pr[0].tag;
                    int64_t vv = pr[1].val;
                    int64_t vt = pr[1].tag;
                    char *kstr = (kt == 4 && kv != 0) ? strdup((const char *)(uintptr_t)kv) : flux_val_to_str(kv);
                    if (kstr) {
                        flux_map_set(m, kstr, vt, vv);
                        free(kstr);
                    }
                    continue;
                }
            }
            char kbuf[32];
            snprintf(kbuf, sizeof(kbuf), "%lld", (long long)(i + 1));
            flux_map_set(m, kbuf, et, ev);
        }
    }
    return m;
}

int64_t flux_map_get_tag(void *p, const char *key) {
    if (!p || !key || !flux_is_collection_ptr(p, 2)) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        return entries[idx].tag;
    }
    return 0;
}

bool flux_map_contains_key(void *p, const char *key) {
    if (!p || !key || !flux_is_collection_ptr(p, 2)) return false;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    return map_find_entry(map, key) >= 0;
}

size_t flux_map_len(void *p) {
    if (!flux_is_collection_ptr(p, 2)) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    return (size_t)map->len;
}

void flux_hashmap_set_val(void *map, const char *key, int64_t val) {
    flux_map_set(map, key, 2, val);
}

int64_t flux_hashmap_get_val(void *map, const char *key) {
    return flux_map_get(map, key);
}

extern char *flux_list_to_str(void *p);

char *flux_map_to_str(void *p) {
    if (!p) return strdup("None");
    if (!flux_is_collection_ptr(p, 2)) {
        if (flux_is_collection_ptr(p, 0)) {
            return flux_list_to_str(p);
        }
        if (flux_is_collection_ptr(p, 1)) {
            return flux_set_to_str(p);
        }
        if (flux_is_readable_ptr(p, 1)) {
            return strdup((const char *)p);
        }
        char *s = (char *)malloc(32);
        if (s) snprintf(s, 32, "%lld", (long long)(uintptr_t)p);
        return s;
    }
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    if (map->len == 0) {
        return strdup("{}");
    }
    int64_t sname_idx = map_find_entry(map, "_struct_name");
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    size_t cap = 256;
    char *res = (char *)malloc(cap);
    if (!res) return NULL;
    size_t cur_len = 0;

    if (sname_idx >= 0) {
        const char *sname = (const char *)(uintptr_t)entries[sname_idx].val;
        cur_len = snprintf(res, cap, "%s(", sname ? sname : "");
        int first = 1;
        for (int64_t i = 0; i < map->len; i++) {
            const char *k = (const char *)(uintptr_t)entries[i].key_ptr;
            if (!k || strcmp(k, "_struct_name") == 0 || strcmp(k, "_field_order") == 0) continue;
            char elem_buf[128];
            char *alloc_val = NULL;
            const char *val_str = elem_buf;
            int64_t tag = entries[i].tag;
            int64_t val = entries[i].val;
            if (tag == 4) {
                if ((uintptr_t)val < 0x10000) {
                    snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
                } else {
                    val_str = (const char *)(uintptr_t)val;
                    if (!val_str) val_str = "";
                }
            } else if (tag == 3) {
                double d;
                memcpy(&d, &val, sizeof(double));
                alloc_val = flux_float_to_str(d);
                val_str = alloc_val ? alloc_val : "0.0";
            } else if (tag == 1) {
                val_str = val ? "true" : "false";
            } else if (flux_is_collection_ptr((const void *)(uintptr_t)val, 2)) {
                alloc_val = flux_map_to_str((void *)(uintptr_t)val);
                val_str = alloc_val ? alloc_val : "{}";
            } else if (flux_is_collection_ptr((const void *)(uintptr_t)val, 0)) {
                alloc_val = flux_list_to_str((void *)(uintptr_t)val);
                val_str = alloc_val ? alloc_val : "[]";
            } else if (flux_is_collection_ptr((const void *)(uintptr_t)val, 1)) {
                alloc_val = flux_set_to_str((void *)(uintptr_t)val);
                val_str = alloc_val ? alloc_val : "[]";
            } else if (flux_is_cstr_ptr((const void *)(uintptr_t)val)) {
                val_str = (const char *)(uintptr_t)val;
            } else if (tag == 2) {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
            } else {
                uint64_t u = (uint64_t)val;
                uint64_t exp = (u >> 52) & 0x7FFULL;
                if (exp >= 0x380ULL && exp <= 0x47FULL) {
                    double d;
                    memcpy(&d, &val, sizeof(double));
                    alloc_val = flux_float_to_str(d);
                    val_str = alloc_val ? alloc_val : "0.0";
                } else {
                    snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
                }
            }

            size_t needed = cur_len + strlen(k) + strlen(val_str) + 16;
            if (needed >= cap) {
                cap = (needed * 2 > cap * 2) ? needed * 2 : cap * 2;
                res = (char *)realloc(res, cap);
                if (!res) { if (alloc_val) free(alloc_val); return NULL; }
            }
            if (!first) {
                memcpy(res + cur_len, ", ", 2);
                cur_len += 2;
            }
            first = 0;
            cur_len += sprintf(res + cur_len, ".%s: %s", k, val_str);
            if (alloc_val) free(alloc_val);
        }
        res[cur_len++] = ')';
        res[cur_len] = '\0';
        return res;
    }

    res[cur_len++] = '{';
    res[cur_len] = '\0';
    for (int64_t i = 0; i < map->len; i++) {
        const char *k = (const char *)(uintptr_t)entries[i].key_ptr;
        char elem_buf[128];
        char *alloc_val = NULL;
        const char *val_str = elem_buf;
        int64_t tag = entries[i].tag;
        int64_t val = entries[i].val;
        if (tag == 4) {
            if ((uintptr_t)val < 0x10000) {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
            } else {
                val_str = (const char *)(uintptr_t)val;
                if (!val_str) val_str = "";
            }
        } else if (tag == 3) {
            double d;
            memcpy(&d, &val, sizeof(double));
            alloc_val = flux_float_to_str(d);
            val_str = alloc_val ? alloc_val : "0.0";
        } else if (tag == 1) {
            val_str = val ? "true" : "false";
        } else if (flux_is_collection_ptr((const void *)(uintptr_t)val, 2)) {
            alloc_val = flux_map_to_str((void *)(uintptr_t)val);
            val_str = alloc_val ? alloc_val : "{}";
        } else if (flux_is_collection_ptr((const void *)(uintptr_t)val, 0)) {
            alloc_val = flux_list_to_str((void *)(uintptr_t)val);
            val_str = alloc_val ? alloc_val : "[]";
        } else if (flux_is_collection_ptr((const void *)(uintptr_t)val, 1)) {
            alloc_val = flux_set_to_str((void *)(uintptr_t)val);
            val_str = alloc_val ? alloc_val : "[]";
        } else if (flux_is_cstr_ptr((const void *)(uintptr_t)val)) {
            val_str = (const char *)(uintptr_t)val;
        } else if (tag == 2) {
            snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
        } else {
            uint64_t u = (uint64_t)val;
            uint64_t exp = (u >> 52) & 0x7FFULL;
            if (exp >= 0x380ULL && exp <= 0x47FULL) {
                double d;
                memcpy(&d, &val, sizeof(double));
                alloc_val = flux_float_to_str(d);
                val_str = alloc_val ? alloc_val : "0.0";
            } else {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
            }
        }

        size_t needed = cur_len + (k ? strlen(k) : 0) + strlen(val_str) + 16;
        if (needed >= cap) {
            cap = (needed * 2 > cap * 2) ? needed * 2 : cap * 2;
            res = (char *)realloc(res, cap);
            if (!res) { if (alloc_val) free(alloc_val); return NULL; }
        }
        if (i > 0) {
            memcpy(res + cur_len, ", ", 2);
            cur_len += 2;
        }
        cur_len += sprintf(res + cur_len, "%s: %s", k ? k : "", val_str);
        if (alloc_val) free(alloc_val);
    }
    res[cur_len++] = '}';
    res[cur_len] = '\0';
    return res;
}

void flux_map_print(void *p) {
    char *s = flux_map_to_str(p);
    if (s) {
        printf("%s\n", s);
        free(s);
    } else {
        printf("None\n");
    }
}

const char *flux_map_key_at(void *p, int64_t idx) {
    if (!p) return "";
    flux_simd_list_t *h = (flux_simd_list_t *)p;
    if (idx < 1 || idx > h->len || !h->data_ptr) return "";
    flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)h->data_ptr;
    const char *k = (const char *)(uintptr_t)entries[idx - 1].key_ptr;
    return k ? k : "";
}
