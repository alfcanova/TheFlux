/* ==============================================================================
 * TheFlux Native Runtime: Fast Map (List-backed map conforming to Flux SIMD)
 * Source: runtime/src/collections/map.c
 * ============================================================================== */

#include "flux/collections.h"
#include "flux/types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
static bool is_valid_readable_ptr(const void *p) {
    if (!p) return false;
    uintptr_t u = (uintptr_t)p;
    if (u < 0x10000 || u > 0x00007fffffffffffULL) return false;
    MEMORY_BASIC_INFORMATION mbi;
    if (VirtualQuery(p, &mbi, sizeof(mbi)) == 0) return false;
    if (mbi.State != MEM_COMMIT) return false;
    DWORD prot = mbi.Protect & 0xFF;
    if (prot != PAGE_READONLY && prot != PAGE_READWRITE && prot != PAGE_EXECUTE_READ && prot != PAGE_EXECUTE_READWRITE) return false;
    return true;
}
#else
static bool is_valid_readable_ptr(const void *p) {
    if (!p) return false;
    uintptr_t u = (uintptr_t)p;
    if (u < 0x10000 || u > 0x00007fffffffffffULL) return false;
    return true;
}
#endif

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

#define FLUX_MAX_MAP_CAP 1000000LL

static void map_grow(flux_simd_list_t *map, int64_t min_cap) {
    if (!map) return;
    if (min_cap <= 0 || min_cap > FLUX_MAX_MAP_CAP) return;
    if (map->cap >= min_cap) return;
    int64_t new_cap = map->cap * 2;
    if (new_cap < min_cap) new_cap = min_cap;
    if (new_cap > FLUX_MAX_MAP_CAP) new_cap = FLUX_MAX_MAP_CAP;
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
        if (entries) {
            entries[idx].tag = vtag;
            entries[idx].val = vval;
        }
        return p;
    }
    if (map->len >= FLUX_MAX_MAP_CAP) return p;
    map_grow(map, map->len + 1);
    if (map->cap < map->len + 1) return p;
    entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
    if (!entries) return p;
    int64_t n = map->len;
    entries[n].key_ptr = (int64_t)(uintptr_t)strdup(key);
    entries[n].tag = vtag;
    entries[n].val = vval;
    map->len = n + 1;
    return p;
}

int64_t flux_map_get(void *p, const char *key) {
    if (!p || !key || !is_valid_readable_ptr(p)) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    if (map->kind != 2) return 0;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        return entries[idx].val;
    }
    return 0;
}

int64_t flux_map_get_tag(void *p, const char *key) {
    if (!p || !key || !is_valid_readable_ptr(p)) return 0;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    if (map->kind != 2) return 0;
    int64_t idx = map_find_entry(map, key);
    if (idx >= 0) {
        flux_map_entry_t *entries = (flux_map_entry_t *)(uintptr_t)map->data_ptr;
        return entries[idx].tag;
    }
    return 0;
}

bool flux_map_contains_key(void *p, const char *key) {
    if (!p || !key || !is_valid_readable_ptr(p)) return false;
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    if (map->kind != 2) return false;
    return map_find_entry(map, key) >= 0;
}

size_t flux_map_len(void *p) {
    if (!p) return 0;
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
    if ((uintptr_t)p < 0x10000) {
        char *s = (char *)malloc(32);
        if (s) snprintf(s, 32, "%lld", (long long)(uintptr_t)p);
        return s;
    }
    flux_simd_list_t *map = (flux_simd_list_t *)p;
    if (map->kind != 2) {
        return strdup((char *)p);
    }
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
                snprintf(elem_buf, sizeof(elem_buf), "%.17g", d);
            } else if (tag == 1) {
                val_str = val ? "true" : "false";
            } else if (tag == 2) {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
            } else if ((uintptr_t)val >= 0x10000 && ((flux_simd_list_t *)val)->kind == 2) {
                alloc_val = flux_map_to_str((void *)val);
                val_str = alloc_val ? alloc_val : "{}";
            } else if ((uintptr_t)val >= 0x10000 && ((flux_simd_list_t *)val)->kind == 0) {
                alloc_val = flux_list_to_str((void *)val);
                val_str = alloc_val ? alloc_val : "[]";
            } else {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
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
            snprintf(elem_buf, sizeof(elem_buf), "%.17g", d);
        } else if (tag == 1) {
            val_str = val ? "true" : "false";
        } else if (tag == 2) {
            snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
        } else if ((uintptr_t)val >= 0x10000 && ((flux_simd_list_t *)val)->kind == 2) {
            alloc_val = flux_map_to_str((void *)val);
            val_str = alloc_val ? alloc_val : "{}";
        } else if ((uintptr_t)val >= 0x10000 && ((flux_simd_list_t *)val)->kind == 0) {
            alloc_val = flux_list_to_str((void *)val);
            val_str = alloc_val ? alloc_val : "[]";
        } else {
            snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
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
