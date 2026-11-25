/* ==============================================================================
 * TheFlux Native Runtime: Dynamic Vector / List (Conforming to Flux SIMD)
 * Source: runtime/src/collections/list.c
 * ============================================================================== */

#include "flux/collections.h"
#include "flux/memory.h"
#include "flux/string.h"
#include "flux/types.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FLUX_LIST_OBJ_MAGIC 0x464C535449445831ULL
#define FLUX_MAP_OBJ_MAGIC  0x464D415049445831ULL

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

typedef struct {
    uintptr_t base;
    uintptr_t end;
} FluxReadableRegion;

/* Only stores regions GUARANTEED immortal for the process lifetime:
 *   1. MEM_IMAGE segments (.rdata / .data of the executable/DLLs)
 *   2. Flux immortal TLS arena chunks (registered via flux_register_immortal_region)
 * Arbitrary MEM_PRIVATE heap regions are NEVER cached here, so free()/realloc()
 * can never leave stale entries or cause access violations. */
#define FLUX_IMMORTAL_CACHE_SIZE 512
static _Thread_local FluxReadableRegion g_immortal_cache[FLUX_IMMORTAL_CACHE_SIZE];
static _Thread_local unsigned int g_immortal_cache_count = 0;

void flux_register_immortal_region(const void *base, size_t size) {
    if (!base || size == 0) return;
    uintptr_t b = (uintptr_t)base;
    uintptr_t e = b + size;
    if (e <= b) return;
    unsigned int n = g_immortal_cache_count;
    for (unsigned int i = 0; i < n; i++) {
        if (b >= g_immortal_cache[i].base && e <= g_immortal_cache[i].end) {
            return;
        }
    }
    if (n < FLUX_IMMORTAL_CACHE_SIZE) {
        g_immortal_cache[n].base = b;
        g_immortal_cache[n].end = e;
        g_immortal_cache_count = n + 1;
    }
}

bool flux_is_readable_ptr(const void *p, size_t size) {
    if (!p || size == 0) return false;
    uintptr_t u = (uintptr_t)p;
    if (u < 0x10000 || u > 0x00007fffffffffffULL) return false;
    if (u + size < u || u + size - 1 > 0x00007fffffffffffULL) return false;
    uintptr_t end = u + size;

    /* Fast path: check TLS cache of immortal regions (MRU swap-to-front). */
    unsigned int in = g_immortal_cache_count;
    for (unsigned int i = 0; i < in; i++) {
        if (u >= g_immortal_cache[i].base && end <= g_immortal_cache[i].end) {
            if (i > 0) {
                FluxReadableRegion tmp = g_immortal_cache[i];
                g_immortal_cache[i] = g_immortal_cache[0];
                g_immortal_cache[0] = tmp;
            }
            return true;
        }
    }

    uintptr_t cur = u;
    while (cur < end) {
        MEMORY_BASIC_INFORMATION mbi;
        if (VirtualQuery((const void *)cur, &mbi, sizeof(mbi)) == 0) return false;
        if (mbi.State != MEM_COMMIT) return false;
        if (mbi.Protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
        DWORD prot = mbi.Protect & 0xFF;
        if (prot != PAGE_READONLY && prot != PAGE_READWRITE && prot != PAGE_WRITECOPY &&
            prot != PAGE_EXECUTE_READ && prot != PAGE_EXECUTE_READWRITE && prot != PAGE_EXECUTE_WRITECOPY) {
            return false;
        }
        uintptr_t region_base = (uintptr_t)mbi.BaseAddress;
        uintptr_t region_end = region_base + mbi.RegionSize;
        if (region_end <= cur) return false;
        if (mbi.Type == MEM_IMAGE && mbi.RegionSize >= 4096) {
            flux_register_immortal_region((const void *)region_base, mbi.RegionSize);
        }
        cur = region_end;
    }
    return true;
}
#else
void flux_register_immortal_region(const void *base, size_t size) {
    (void)base;
    (void)size;
}
bool flux_is_readable_ptr(const void *p, size_t size) {
    if (!p || size == 0) return false;
    uintptr_t u = (uintptr_t)p;
    if (u < 0x10000 || u > 0x00007fffffffffffULL) return false;
    if (u + size < u || u + size - 1 > 0x00007fffffffffffULL) return false;
    return true;
}
#endif

#define FLUX_MAX_COLLECTION_CAP 1000000LL

bool flux_is_collection_ptr(const void *p, int64_t expected_kind) {
    if (((uintptr_t)p & 7) != 0) return false;
    if (!flux_is_readable_ptr(p, sizeof(flux_simd_list_t))) return false;
    const flux_simd_list_t *list = (const flux_simd_list_t *)p;
    if (expected_kind >= 0) {
        if (list->kind != expected_kind) return false;
    } else if (list->kind < 0 || list->kind > 2) {
        return false;
    }
    if (list->len < 0 || list->len > FLUX_MAX_COLLECTION_CAP) return false;
    if (list->cap <= 0 || list->cap < list->len || list->cap > FLUX_MAX_COLLECTION_CAP) return false;
    if (list->data_ptr != 0 && flux_is_readable_ptr(p, sizeof(flux_simd_list_t) + sizeof(uint64_t))) {
        uint64_t magic;
        memcpy(&magic, (const char *)p + sizeof(flux_simd_list_t), sizeof(uint64_t));
        if ((list->kind != 2 && magic == FLUX_LIST_OBJ_MAGIC) ||
            (list->kind == 2 && magic == FLUX_MAP_OBJ_MAGIC)) {
            return true;
        }
    }
    return flux_is_readable_ptr((const void *)(uintptr_t)list->data_ptr, 1);
}

static bool is_printable_cstr(const void *p) {
    if (!flux_is_readable_ptr(p, 1)) return false;
    const char *s = (const char *)p;
    for (int c = 0; c < 64; c++) {
        if (c > 0 && ((((uintptr_t)(s + c)) & 0xFFF) == 0)) {
            if (!flux_is_readable_ptr(s + c, 1)) return false;
        }
        unsigned char ch = (unsigned char)s[c];
        if (ch == '\0') return true;
        if (ch < 32 && ch != '\n' && ch != '\t' && ch != '\r') return false;
    }
    return true;
}

bool flux_is_cstr_ptr(const void *p) {
    return is_printable_cstr(p);
}

static _Thread_local int64_t g_flux_last_tag = -1;
static _Thread_local int64_t g_flux_last_val = 0;

#define FLUX_FLOAT_RING_SIZE 16
static _Thread_local int64_t g_flux_float_ring[FLUX_FLOAT_RING_SIZE];
static _Thread_local unsigned int g_flux_float_head = 0;
static _Thread_local unsigned int g_flux_float_count = 0;

void flux_set_last_tag(int64_t tag, int64_t val) {
    g_flux_last_tag = tag;
    g_flux_last_val = val;
    if (tag == 3) {
        uint32_t exp = (uint32_t)(((uint64_t)val >> 52) & 0x7FF);
        if (exp >= 0x001 && exp <= 0x7FE) {
            g_flux_float_ring[g_flux_float_head] = val;
            g_flux_float_head = (g_flux_float_head + 1) & (FLUX_FLOAT_RING_SIZE - 1);
            if (g_flux_float_count < FLUX_FLOAT_RING_SIZE) {
                g_flux_float_count++;
            }
        }
    }
}

int64_t flux_get_last_tag(int64_t val) {
    if (g_flux_last_tag >= 0 && g_flux_last_val == val) {
        return g_flux_last_tag;
    }
    uint32_t exp = (uint32_t)(((uint64_t)val >> 52) & 0x7FF);
    if (exp >= 0x001 && exp <= 0x7FE) {
        unsigned int n = g_flux_float_count;
        unsigned int idx = g_flux_float_head;
        for (unsigned int i = 0; i < n; i++) {
            idx = (idx - 1) & (FLUX_FLOAT_RING_SIZE - 1);
            if (g_flux_float_ring[idx] == val) {
                return 3;
            }
        }
    }
    return -1;
}

int64_t flux_infer_tag(int64_t tag, int64_t val) {
    if (tag != 0) return tag;
    const void *vp = (const void *)(uintptr_t)val;
    if (flux_is_readable_ptr(vp, 1)) {
        if (flux_is_collection_ptr(vp, -1)) {
            const flux_simd_list_t *c = (const flux_simd_list_t *)vp;
            if (c->kind == 0) return 5;
            if (c->kind == 1) return 7;
            if (c->kind == 2) return 6;
        }
        if (is_printable_cstr(vp)) return 4;
    }
    int64_t last_t = flux_get_last_tag(val);
    if (last_t > 0) return last_t;
    uint64_t u = (uint64_t)val;
    uint32_t exp = (uint32_t)((u >> 52) & 0x7FF);
    if (exp >= 0x380 && exp <= 0x47F) return 3;
    return 2;
}

#define FLUX_SET_HASH_THRESHOLD 8

typedef struct {
    int64_t *slots;        /* 0 = empty, >0 = row_idx + 1 */
    uint64_t *elem_hashes;
    uint32_t bucket_cap;   /* power of 2 */
    uint32_t elem_cap;
} FluxSetRowIndex;

typedef struct {
    flux_simd_list_t hdr;
    uint64_t magic;
    FluxSetRowIndex *set_idx;
} FluxListObj;

extern uint32_t flux_str_hash(const char *s);

bool flux_is_list(void *p) {
    return flux_is_collection_ptr(p, 0);
}

void *flux_list_build(int64_t n, int64_t tag) {
    if (n < 0 || n > FLUX_MAX_COLLECTION_CAP) return NULL;
    FluxListObj *obj = (FluxListObj *)flux_tls_obj_alloc(sizeof(FluxListObj));
    if (!obj) return NULL;
    int64_t cap = (n + 1 > 1) ? (n + 1) : 1;
    flux_simd_row_t *d = (flux_simd_row_t *)malloc((size_t)cap * sizeof(flux_simd_row_t));
    if (!d) {
        return NULL;
    }
    obj->hdr.len = n;
    obj->hdr.cap = cap;
    obj->hdr.tag = tag;
    obj->hdr.data_ptr = (int64_t)(uintptr_t)d;
    obj->hdr.kind = 0; /* 0 = list */
    obj->magic = FLUX_LIST_OBJ_MAGIC;
    obj->set_idx = NULL;
    return &obj->hdr;
}

static void list_grow(flux_simd_list_t *lst, int64_t min_cap) {
    if (!lst) return;
    if (min_cap <= 0 || min_cap > FLUX_MAX_COLLECTION_CAP) return;
    if (lst->cap >= min_cap) return;
    int64_t new_cap = lst->cap * 2;
    if (new_cap < min_cap) new_cap = min_cap;
    if (new_cap > FLUX_MAX_COLLECTION_CAP) new_cap = FLUX_MAX_COLLECTION_CAP;
    if (new_cap < min_cap) return;
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

void *flux_set_new(int64_t initial_cap) {
    flux_simd_list_t *s = (flux_simd_list_t *)flux_list_create(initial_cap > 4 ? (size_t)initial_cap : 4);
    if (s) s->kind = 1;
    return s;
}

void *flux_list_push(void *list, int64_t tag, int64_t ival, const char *sval) {
    if (!list) return NULL;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->len >= FLUX_MAX_COLLECTION_CAP) return list;
    list_grow(l, l->len + 1);
    if (l->cap < l->len + 1) return list;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return list;
    int64_t n = l->len;
    int64_t actual_val = (tag == 4 && sval) ? (int64_t)(uintptr_t)sval : ival;
    rows[n].tag = flux_infer_tag(tag, actual_val);
    rows[n].val = actual_val;
    rows[n].sval = (int64_t)(uintptr_t)sval;
    l->len = n + 1;
    return list;
}

void flux_list_push_val(void *list, int64_t val) {
    flux_list_push(list, 2, val, NULL);
}

void flux_list_push_tagged(void *list, int64_t tag, int64_t val) {
    flux_list_push(list, tag, val, NULL);
}

void *flux_list_push_back_copy(void *src, int64_t tag, int64_t val) {
    int64_t n = 0;
    flux_simd_row_t *src_rows = NULL;
    int64_t src_tag = 0;
    if (src && flux_is_collection_ptr(src, -1)) {
        flux_simd_list_t *l = (flux_simd_list_t *)src;
        n = l->len;
        src_tag = l->tag;
        src_rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    }
    if (n >= FLUX_MAX_COLLECTION_CAP) n = FLUX_MAX_COLLECTION_CAP - 1;
    flux_simd_list_t *res = (flux_simd_list_t *)flux_list_build(n + 1, src_tag);
    if (!res) return NULL;
    flux_simd_row_t *dst_rows = (flux_simd_row_t *)(uintptr_t)res->data_ptr;
    if (dst_rows) {
        if (n > 0 && src_rows) {
            memcpy(dst_rows, src_rows, (size_t)n * sizeof(flux_simd_row_t));
        }
        int64_t actual_tag = flux_infer_tag(tag, val);
        dst_rows[n].tag = actual_tag;
        dst_rows[n].val = val;
        dst_rows[n].sval = (actual_tag == 4) ? val : 0;
    }
    return res;
}

int64_t flux_list_get_val(void *list, int64_t index) {
    if (!list || !flux_is_readable_ptr(list, sizeof(flux_simd_list_t))) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->kind != 0 && l->kind != 1) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    if (l->len <= 0 || l->len > FLUX_MAX_COLLECTION_CAP) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    bool trusted_list = false;
    if (flux_is_readable_ptr(list, sizeof(flux_simd_list_t) + sizeof(uint64_t))) {
        uint64_t magic;
        memcpy(&magic, (const char *)list + sizeof(flux_simd_list_t), sizeof(uint64_t));
        trusted_list = (magic == FLUX_LIST_OBJ_MAGIC);
    }
    /* TheFlux uses 1-based indexing for collections */
    if (index >= 1 && index <= l->len) {
        if (!trusted_list && !flux_is_readable_ptr((const void *)(uintptr_t)l->data_ptr, (size_t)index * sizeof(flux_simd_row_t))) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (!rows) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_set_last_tag(rows[index - 1].tag, rows[index - 1].val);
        return rows[index - 1].val;
    }
    /* 0-based fallback if index == 0 */
    if (index == 0 && l->len > 0) {
        if (!trusted_list && !flux_is_readable_ptr((const void *)(uintptr_t)l->data_ptr, sizeof(flux_simd_row_t))) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (!rows) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_set_last_tag(rows[0].tag, rows[0].val);
        return rows[0].val;
    }
    flux_set_last_tag(0, 0);
    return 0;
}

void flux_list_set(void *list, int64_t index, int64_t val) {
    if (!list) return;
    if (index < 0 || index > FLUX_MAX_COLLECTION_CAP) return;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (index >= 1 && index <= l->len) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            rows[index - 1].val = val;
        }
        return;
    }
    if (index == 0 && l->len > 0) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            rows[0].val = val;
        }
        return;
    }
    if (index > l->len) {
        list_grow(l, index);
        if (l->cap < index) return;
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            for (int64_t i = l->len; i < index; i++) {
                rows[i].tag = 2;
                rows[i].val = 0;
                rows[i].sval = 0;
            }
            rows[index - 1].val = val;
            l->len = index;
        }
    }
}

void flux_list_set_tagged(void *list, int64_t index, int64_t tag, int64_t val) {
    if (!list) return;
    if (index < 0 || index > FLUX_MAX_COLLECTION_CAP) return;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    int64_t actual_tag = flux_infer_tag(tag, val);
    if (index >= 1 && index <= l->len) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            rows[index - 1].tag = actual_tag;
            rows[index - 1].val = val;
        }
        return;
    }
    if (index == 0 && l->len > 0) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            rows[0].tag = actual_tag;
            rows[0].val = val;
        }
        return;
    }
    if (index > l->len) {
        list_grow(l, index);
        if (l->cap < index) return;
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            for (int64_t i = l->len; i < index; i++) {
                rows[i].tag = 2;
                rows[i].val = 0;
                rows[i].sval = 0;
            }
            rows[index - 1].tag = actual_tag;
            rows[index - 1].val = val;
            l->len = index;
        }
    }
}

void *flux_list_slice(void *list, int64_t start, int64_t end) {
    if (!list) return flux_list_build(0, 0);
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (start < 1) start = 1;
    if (end <= 0 || end > l->len) end = l->len;
    if (start > end || start > l->len) {
        return flux_list_build(0, l->tag);
    }
    int64_t count = end - start + 1;
    if (count > FLUX_MAX_COLLECTION_CAP) count = FLUX_MAX_COLLECTION_CAP;
    flux_simd_list_t *sub = (flux_simd_list_t *)flux_list_build(count, l->tag);
    if (!sub) return flux_list_build(0, l->tag);
    flux_simd_row_t *src_rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    flux_simd_row_t *dst_rows = (flux_simd_row_t *)(uintptr_t)sub->data_ptr;
    if (src_rows && dst_rows) {
        for (int64_t i = 0; i < count; i++) {
            dst_rows[i] = src_rows[start - 1 + i];
        }
    }
    return sub;
}

int64_t flux_list_len(void *list) {
    if (!list || !flux_is_readable_ptr(list, sizeof(flux_simd_list_t))) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->kind < 0 || l->kind > 2) return 0;
    return l->len;
}

char *flux_float_to_str(double d);
char *flux_list_to_str(void *p);
bool flux_val_equals(int64_t a, int64_t b);

int64_t flux_list_contains(void *list, int64_t val) {
    if (!list || !flux_is_readable_ptr(list, sizeof(flux_simd_list_t))) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return 0;
    for (int64_t i = 0; i < l->len; i++) {
        if (flux_val_equals(rows[i].val, val)) {
            return 1;
        }
    }
    return 0;
}

void flux_list_print(void *p) {
    char *s = flux_list_to_str(p);
    if (s) {
        printf("%s\n", s);
        free(s);
    } else {
        printf("[]\n");
    }
}

char *flux_val_to_str(int64_t val) {
    int64_t last_t = flux_get_last_tag(val);
    if (val == 0 && last_t == 0) {
        return strdup("None");
    }
    if (last_t == 1 && (val == 0 || val == 1)) {
        return strdup(val ? "true" : "false");
    }
    if (last_t == 3) {
        double d;
        memcpy(&d, &val, sizeof(double));
        return flux_float_to_str(d);
    }
    const void *vp = (const void *)(uintptr_t)val;
    if (flux_is_collection_ptr(vp, -1)) {
        const flux_simd_list_t *list = (const flux_simd_list_t *)vp;
        if (list->kind == 0) return flux_list_to_str((void *)(uintptr_t)val);
        if (list->kind == 1) return flux_set_to_str((void *)(uintptr_t)val);
        if (list->kind == 2) return flux_map_to_str((void *)(uintptr_t)val);
    }
    if (is_printable_cstr(vp)) {
        const char *s = (const char *)vp;
        size_t slen = strlen(s);
        if (slen <= 500000000LL) {
            char *res = (char *)malloc(slen + 1);
            if (res) memcpy(res, s, slen + 1);
            return res;
        }
    }
    if (last_t != 2) {
        uint64_t u = (uint64_t)val;
        uint32_t exp = (uint32_t)((u >> 52) & 0x7FF);
        if (exp >= 0x380 && exp <= 0x47F) {
            double d;
            memcpy(&d, &val, sizeof(double));
            return flux_float_to_str(d);
        }
    }
    char *buf = (char *)malloc(32);
    if (buf) snprintf(buf, 32, "%lld", (long long)val);
    return buf;
}

void flux_val_print(int64_t val) {
    char *s = flux_val_to_str(val);
    if (s) {
        printf("%s\n", s);
        free(s);
    } else {
        printf("\n");
    }
}

char *flux_list_to_str_bracket(void *p, char open_ch, char close_ch) {
    if (!p) {
        char *s = (char*)malloc(3);
        if (s) { s[0] = open_ch; s[1] = close_ch; s[2] = '\0'; }
        return s;
    }
    if (!flux_is_readable_ptr(p, sizeof(flux_simd_list_t))) {
        char *s = (char*)malloc(32);
        if (s) snprintf(s, 32, "%lld", (long long)(uintptr_t)p);
        return s;
    }
    flux_simd_list_t *list = (flux_simd_list_t *)p;
    if (!flux_is_readable_ptr((const void *)(uintptr_t)list->data_ptr, 1) || list->len < 0 || list->len > FLUX_MAX_COLLECTION_CAP) {
        char *s = (char*)malloc(32);
        if (s) snprintf(s, 32, "%lld", (long long)(uintptr_t)p);
        return s;
    }
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)list->data_ptr;
    size_t cap = 256;
    char *res = (char*)malloc(cap);
    if (!res) return NULL;
    res[0] = open_ch;
    res[1] = '\0';
    size_t cur_len = 1;
    for (int64_t i = 0; i < list->len; i++) {
        char *alloc_elem = NULL;
        char elem_buf[128];
        const char *elem_str = elem_buf;
        int64_t tag = rows[i].tag;
        int64_t val = rows[i].val;
        const void *vp = (const void *)(uintptr_t)val;
        if (tag == 5 && flux_is_collection_ptr(vp, 0)) {
            alloc_elem = flux_list_to_str((void *)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "[]";
        } else if (tag == 6 && flux_is_collection_ptr(vp, 2)) {
            alloc_elem = flux_map_to_str((void *)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "{}";
        } else if (tag == 7 && (flux_is_collection_ptr(vp, 1) || flux_is_collection_ptr(vp, 0))) {
            alloc_elem = flux_set_to_str((void *)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "{}";
        } else if ((tag == 10 || tag == 8) && flux_is_readable_ptr(vp, 16)) {
            alloc_elem = flux_complex_to_str((void *)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "0.0 + 0.0i";
        } else if (tag == 4) {
            if (!flux_is_readable_ptr(vp, 1)) {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
            } else {
                const char *s = (const char *)vp;
                elem_str = s ? s : "";
            }
        } else if (tag == 3) {
            double d;
            memcpy(&d, &val, sizeof(double));
            alloc_elem = flux_float_to_str(d);
            elem_str = alloc_elem ? alloc_elem : "0.0";
        } else if (tag == 1) {
            snprintf(elem_buf, sizeof(elem_buf), "%s", val ? "true" : "false");
        } else if (flux_is_collection_ptr(vp, -1)) {
            const flux_simd_list_t *sub = (const flux_simd_list_t *)vp;
            if (sub->kind == 0) {
                alloc_elem = flux_list_to_str((void *)(uintptr_t)val);
                elem_str = alloc_elem ? alloc_elem : "[]";
            } else if (sub->kind == 1) {
                alloc_elem = flux_set_to_str((void *)(uintptr_t)val);
                elem_str = alloc_elem ? alloc_elem : "{}";
            } else {
                alloc_elem = flux_map_to_str((void *)(uintptr_t)val);
                elem_str = alloc_elem ? alloc_elem : "{}";
            }
        } else if (is_printable_cstr(vp)) {
            snprintf(elem_buf, sizeof(elem_buf), "%s", (const char *)vp);
        } else if (tag == 2) {
            snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
        } else {
            snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
        }
        size_t elen = strlen(elem_str);
        size_t need = cur_len + elen + 4;
        if (need >= cap) {
            cap = (need * 2 > cap * 2) ? need * 2 : cap * 2;
            res = (char*)realloc(res, cap);
            if (!res) { if (alloc_elem) free(alloc_elem); return NULL; }
        }
        if (i > 0) {
            res[cur_len++] = ',';
            res[cur_len++] = ' ';
        }
        memcpy(res + cur_len, elem_str, elen);
        cur_len += elen;
        res[cur_len] = '\0';
        if (alloc_elem) free(alloc_elem);
    }
    res[cur_len++] = close_ch;
    res[cur_len] = '\0';
    return res;
}

char *flux_list_to_str(void *p) {
    return flux_list_to_str_bracket(p, '[', ']');
}

char *flux_set_to_str(void *p) {
    return flux_list_to_str_bracket(p, '{', '}');
}

void flux_set_print(void *p) {
    char *s = flux_set_to_str(p);
    if (s) {
        printf("%s\n", s);
        free(s);
    }
}

void *flux_list_extend(void *dst, void *src) {
    if (!dst && !src) return flux_list_build(0, 0);
    if (!dst) return src;
    if (!src) return dst;
    flux_simd_list_t *d = (flux_simd_list_t *)dst;
    flux_simd_list_t *s = (flux_simd_list_t *)src;
    if (s->len == 0) return dst;
    if (d->len + s->len > FLUX_MAX_COLLECTION_CAP) return dst;
    list_grow(d, d->len + s->len);
    if (d->cap < d->len + s->len) return dst;
    flux_simd_row_t *d_rows = (flux_simd_row_t *)(uintptr_t)d->data_ptr;
    flux_simd_row_t *s_rows = (flux_simd_row_t *)(uintptr_t)s->data_ptr;
    if (d_rows && s_rows) {
        for (int64_t i = 0; i < s->len; i++) {
            d_rows[d->len + i] = s_rows[i];
        }
        d->len += s->len;
    }
    return dst;
}

void *flux_list_concat(void *a, void *b) {
    int64_t na = (a && flux_is_collection_ptr(a, -1)) ? ((flux_simd_list_t *)a)->len : 0;
    int64_t nb = (b && flux_is_collection_ptr(b, -1)) ? ((flux_simd_list_t *)b)->len : 0;
    void *res = flux_list_create((size_t)(na + nb > 4 ? na + nb : 4));
    if (!res) return NULL;
    if (a && flux_is_collection_ptr(a, -1)) flux_list_extend(res, a);
    if (b && flux_is_collection_ptr(b, -1)) flux_list_extend(res, b);
    return res;
}

extern char *flux_str_slice(const char *p, int64_t s, int64_t e);

static bool is_flux_list(uintptr_t val) {
    return flux_is_collection_ptr((const void *)val, 0);
}

void *flux_slice(void *p, int64_t start, int64_t end) {
    if (!p) return flux_list_build(0, 0);
    if (is_flux_list((uintptr_t)p)) {
        return flux_list_slice(p, start, end);
    }
    if (flux_is_readable_ptr(p, 1)) {
        return flux_str_slice((const char *)p, start, end);
    }
    return flux_list_build(0, 0);
}

static uint64_t flux_mix64(uint64_t x) {
    x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9ULL;
    x = (x ^ (x >> 27)) * 0x94d049bb133111ebULL;
    return x ^ (x >> 31);
}

static uint64_t flux_set_hash_elem(int64_t tag, int64_t val, int *is_cstr) {
    if (tag == 4 && flux_is_readable_ptr((const void *)(uintptr_t)val, 1)) {
        if (is_cstr) *is_cstr = 1;
        return 0xA5A5000000000000ULL | (uint64_t)flux_str_hash((const char *)(uintptr_t)val);
    }
    if (is_cstr) *is_cstr = 0;
    return flux_mix64(((uint64_t)tag * 0x9e3779b97f4a7c15ULL) ^ (uint64_t)val);
}

static FluxListObj *as_list_obj(flux_simd_list_t *l) {
    if (!l || (l->kind != 0 && l->kind != 1)) return NULL;
    FluxListObj *obj = (FluxListObj *)l;
    return (obj->magic == FLUX_LIST_OBJ_MAGIC) ? obj : NULL;
}

static bool flux_set_index_rehash(FluxListObj *obj, uint32_t new_bcap) {
    if (!obj) return false;
    flux_simd_list_t *l = &obj->hdr;
    uint32_t need_ecap = (uint32_t)(l->cap > 16 ? l->cap : 16);
    FluxSetRowIndex *idx = obj->set_idx;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!idx) {
        idx = (FluxSetRowIndex *)calloc(1, sizeof(FluxSetRowIndex));
        if (!idx) return false;
        idx->elem_cap = need_ecap;
        idx->elem_hashes = (uint64_t *)malloc((size_t)need_ecap * sizeof(uint64_t));
        if (!idx->elem_hashes) { free(idx); return false; }
        for (int64_t i = 0; i < l->len; i++) {
            idx->elem_hashes[i] = rows ? flux_set_hash_elem(rows[i].tag, rows[i].val, NULL) : 0;
        }
        obj->set_idx = idx;
    } else if (need_ecap > idx->elem_cap) {
        uint64_t *nh = (uint64_t *)realloc(idx->elem_hashes, (size_t)need_ecap * sizeof(uint64_t));
        if (!nh) return false;
        idx->elem_hashes = nh;
        idx->elem_cap = need_ecap;
    }

    int64_t *new_slots = (int64_t *)calloc((size_t)new_bcap, sizeof(int64_t));
    if (!new_slots) return false;
    uint32_t mask = new_bcap - 1;
    for (int64_t i = 0; i < l->len; i++) {
        uint32_t pos = (uint32_t)(idx->elem_hashes[i] & mask);
        while (new_slots[pos] != 0) pos = (pos + 1) & mask;
        new_slots[pos] = i + 1;
    }
    free(idx->slots);
    idx->slots = new_slots;
    idx->bucket_cap = new_bcap;
    return true;
}

int64_t flux_list_get_val_fast(void *list, int64_t index) {
    if (!list || (uintptr_t)list < 0x10000 || !flux_is_readable_ptr(list, sizeof(flux_simd_list_t))) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->kind != 0 && l->kind != 1) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    if (l->len <= 0 || l->len > FLUX_MAX_COLLECTION_CAP) {
        flux_set_last_tag(0, 0);
        return 0;
    }
    bool trusted_list = false;
    if (flux_is_readable_ptr(list, sizeof(flux_simd_list_t) + sizeof(uint64_t))) {
        uint64_t magic;
        memcpy(&magic, (const char *)list + sizeof(flux_simd_list_t), sizeof(uint64_t));
        trusted_list = (magic == FLUX_LIST_OBJ_MAGIC);
    }
    if (index >= 1 && index <= l->len) {
        if (!trusted_list && !flux_is_readable_ptr((const void *)(uintptr_t)l->data_ptr, (size_t)index * sizeof(flux_simd_row_t))) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (!rows) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_set_last_tag(rows[index - 1].tag, rows[index - 1].val);
        return rows[index - 1].val;
    }
    if (index == 0 && l->len > 0) {
        if (!trusted_list && !flux_is_readable_ptr((const void *)(uintptr_t)l->data_ptr, sizeof(flux_simd_row_t))) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (!rows) {
            flux_set_last_tag(0, 0);
            return 0;
        }
        flux_set_last_tag(rows[0].tag, rows[0].val);
        return rows[0].val;
    }
    flux_set_last_tag(0, 0);
    return 0;
}

int64_t flux_list_len_fast(void *list) {
    if (!list || (uintptr_t)list < 0x10000 || !flux_is_readable_ptr(list, sizeof(flux_simd_list_t))) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->kind != 0 && l->kind != 1) return 0;
    if (l->len < 0 || l->len > FLUX_MAX_COLLECTION_CAP) return 0;
    return l->len;
}

int64_t flux_collection_len(const void *p) {
    if (!p) return 0;
    if (flux_is_collection_ptr(p, 0) || flux_is_collection_ptr(p, 1)) {
        return flux_list_len_fast((void *)p);
    }
    if (flux_is_collection_ptr(p, 2)) {
        return (int64_t)flux_map_len((void *)p);
    }
    return flux_str_len((const char *)p);
}

void flux_set_add_tagged(void *set, int64_t tag, int64_t val) {
    if (!set) return;
    tag = flux_infer_tag(tag, val);
    flux_simd_list_t *l = (flux_simd_list_t *)set;
    if (l->len >= FLUX_MAX_COLLECTION_CAP) return;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    FluxListObj *obj = as_list_obj(l);

    if (obj && obj->set_idx && obj->set_idx->slots && obj->set_idx->bucket_cap > 0 && rows) {
        int is_cstr = 0;
        uint64_t h = flux_set_hash_elem(tag, val, &is_cstr);
        FluxSetRowIndex *idx = obj->set_idx;
        uint32_t mask = idx->bucket_cap - 1;
        uint32_t pos = (uint32_t)(h & mask);
        for (;;) {
            int64_t sv = idx->slots[pos];
            if (sv == 0) break;
            int64_t eidx = sv - 1;
            if (idx->elem_hashes[eidx] == h) {
                if (rows[eidx].tag == tag && rows[eidx].val == val) return;
                if (is_cstr && rows[eidx].tag == 4 &&
                    flux_is_readable_ptr((const void *)(uintptr_t)rows[eidx].val, 1) &&
                    strcmp((const char *)(uintptr_t)rows[eidx].val, (const char *)(uintptr_t)val) == 0) {
                    return;
                }
            }
            pos = (pos + 1) & mask;
        }
        int64_t n = l->len;
        flux_list_push_tagged(set, tag, val);
        if (l->len == n + 1) {
            if ((uint32_t)n >= idx->elem_cap) {
                uint32_t nc = (uint32_t)(l->cap > 16 ? l->cap : 16);
                uint64_t *nh = (uint64_t *)realloc(idx->elem_hashes, (size_t)nc * sizeof(uint64_t));
                if (!nh) return;
                idx->elem_hashes = nh;
                idx->elem_cap = nc;
            }
            idx->elem_hashes[n] = h;
            if (l->len * 10 >= (int64_t)idx->bucket_cap * 7) {
                flux_set_index_rehash(obj, idx->bucket_cap * 2);
            } else {
                pos = (uint32_t)(h & mask);
                while (idx->slots[pos] != 0) pos = (pos + 1) & mask;
                idx->slots[pos] = n + 1;
            }
        }
        return;
    }

    if (rows) {
        int is_cstr = (tag == 4 && flux_is_readable_ptr((const void *)(uintptr_t)val, 1));
        for (int64_t i = 0; i < l->len; i++) {
            if (rows[i].tag == tag && rows[i].val == val) return;
            if (is_cstr && rows[i].tag == 4 && flux_is_readable_ptr((const void *)(uintptr_t)rows[i].val, 1)) {
                if (strcmp((const char *)(uintptr_t)rows[i].val, (const char *)(uintptr_t)val) == 0) return;
            }
            if (flux_val_equals(rows[i].val, val)) return;
        }
    }
    flux_list_push_tagged(set, tag, val);
    if (obj && !obj->set_idx && l->len > FLUX_SET_HASH_THRESHOLD) {
        uint32_t bcap = 32;
        while ((int64_t)bcap * 7 < l->len * 10) bcap *= 2;
        flux_set_index_rehash(obj, bcap);
    }
}

void *flux_list_to_set(void *src) {
    if (!src) return flux_set_new(4);
    if (!flux_is_collection_ptr(src, -1)) {
        flux_simd_list_t *d = (flux_simd_list_t *)flux_set_new(4);
        int64_t v = (int64_t)(uintptr_t)src;
        flux_set_add_tagged(d, flux_infer_tag(0, v), v);
        return d;
    }
    flux_simd_list_t *s = (flux_simd_list_t *)src;
    flux_simd_list_t *d = (flux_simd_list_t *)flux_set_new(s->len > 4 ? s->len : 4);
    flux_simd_row_t *s_rows = (flux_simd_row_t *)(uintptr_t)s->data_ptr;
    if (s_rows && d) {
        for (int64_t i = 0; i < s->len; i++) {
            flux_set_add_tagged(d, s_rows[i].tag, s_rows[i].val);
        }
    }
    return d;
}

double flux_val_to_float(int64_t val) {
    if (val == 0) return 0.0;
    int64_t last_t = flux_get_last_tag(val);
    if (last_t == 3) {
        double d;
        memcpy(&d, &val, sizeof(double));
        return d;
    }
    if (last_t == 2 || last_t == 1) {
        return (double)val;
    }
    const void *vp = (const void *)(uintptr_t)val;
    if (!flux_is_collection_ptr(vp, -1) && is_printable_cstr(vp)) {
        return strtod((const char *)vp, NULL);
    }
    uint64_t u = (uint64_t)val;
    uint32_t exp = (uint32_t)((u >> 52) & 0x7FF);
    if (exp >= 0x380 && exp <= 0x47F) {
        double d;
        memcpy(&d, &val, sizeof(double));
        return d;
    }
    return (double)val;
}

int64_t flux_val_to_int(int64_t val) {
    if (val == 0) return 0;
    int64_t last_t = flux_get_last_tag(val);
    if (last_t == 2 || last_t == 1) {
        return val;
    }
    if (last_t == 3) {
        double d;
        memcpy(&d, &val, sizeof(double));
        return (int64_t)d;
    }
    const void *vp = (const void *)(uintptr_t)val;
    if (!flux_is_collection_ptr(vp, -1) && is_printable_cstr(vp)) {
        return (int64_t)atoll((const char *)vp);
    }
    uint64_t u = (uint64_t)val;
    uint32_t exp = (uint32_t)((u >> 52) & 0x7FF);
    if (exp >= 0x380 && exp <= 0x47F) {
        double d;
        memcpy(&d, &val, sizeof(double));
        return (int64_t)d;
    }
    return val;
}

void *flux_val_to_list(int64_t val) {
    const void *vp = (const void *)(uintptr_t)val;
    if (flux_is_collection_ptr(vp, 0) || flux_is_collection_ptr(vp, 1)) {
        return (void *)(uintptr_t)val;
    }
    void *lst = flux_list_create(4);
    flux_list_push_tagged(lst, flux_infer_tag(0, val), val);
    return lst;
}

bool flux_val_equals(int64_t a, int64_t b) {
    if (a == b) return true;
    const void *pa = (const void *)(uintptr_t)a;
    const void *pb = (const void *)(uintptr_t)b;
    bool ca_list = flux_is_collection_ptr(pa, 0) || flux_is_collection_ptr(pa, 1);
    bool cb_list = flux_is_collection_ptr(pb, 0) || flux_is_collection_ptr(pb, 1);
    if (ca_list && cb_list) {
        const flux_simd_list_t *la = (const flux_simd_list_t *)pa;
        const flux_simd_list_t *lb = (const flux_simd_list_t *)pb;
        if (la->len != lb->len) return false;
        const flux_simd_row_t *ra = (const flux_simd_row_t *)(uintptr_t)la->data_ptr;
        const flux_simd_row_t *rb = (const flux_simd_row_t *)(uintptr_t)lb->data_ptr;
        if (!ra || !rb) return la->len == 0;
        for (int64_t i = 0; i < la->len; i++) {
            if (!flux_val_equals(ra[i].val, rb[i].val)) return false;
        }
        return true;
    }
    bool ca_map = flux_is_collection_ptr(pa, 2);
    bool cb_map = flux_is_collection_ptr(pb, 2);
    if (ca_map && cb_map) {
        char *sa = flux_map_to_str((void *)(uintptr_t)a);
        char *sb = flux_map_to_str((void *)(uintptr_t)b);
        bool eq = (sa && sb && strcmp(sa, sb) == 0);
        free(sa);
        free(sb);
        return eq;
    }
    if (!ca_list && !ca_map && !cb_list && !cb_map && is_printable_cstr(pa) && is_printable_cstr(pb)) {
        return strcmp((const char *)pa, (const char *)pb) == 0;
    }
    return false;
}

int64_t flux_val_compare(int64_t a, int64_t b) {
    if (a == b) return 0;
    const void *pa = (const void *)(uintptr_t)a;
    const void *pb = (const void *)(uintptr_t)b;
    bool ca_col = flux_is_collection_ptr(pa, -1);
    bool cb_col = flux_is_collection_ptr(pb, -1);
    if (!ca_col && !cb_col && is_printable_cstr(pa) && is_printable_cstr(pb)) {
        int cmp = strcmp((const char *)pa, (const char *)pb);
        return cmp < 0 ? -1 : (cmp > 0 ? 1 : 0);
    }
    uint32_t ea = (uint32_t)(((uint64_t)a >> 52) & 0x7FF);
    uint32_t eb = (uint32_t)(((uint64_t)b >> 52) & 0x7FF);
    if (flux_get_last_tag(a) == 3 || flux_get_last_tag(b) == 3 ||
        (ea >= 0x380 && ea <= 0x47F) || (eb >= 0x380 && eb <= 0x47F)) {
        double da = flux_val_to_float(a);
        double db = flux_val_to_float(b);
        return da < db ? -1 : (da > db ? 1 : 0);
    }
    int64_t ia = flux_val_to_int(a);
    int64_t ib = flux_val_to_int(b);
    return ia < ib ? -1 : (ia > ib ? 1 : 0);
}

int64_t flux_collection_is_empty(void *col) {
    if (!col || !flux_is_collection_ptr(col, -1)) return 1;
    return ((flux_simd_list_t *)col)->len == 0 ? 1 : 0;
}

int64_t flux_collection_contains(void *col, int64_t val) {
    return flux_list_contains(col, val);
}

void *flux_collection_clear_all(void *col) {
    (void)col;
    return flux_list_create(4);
}

void *flux_set_union(void *lhs, void *rhs) {
    void *d = flux_list_to_set(lhs);
    if (rhs && flux_is_collection_ptr(rhs, -1)) {
        flux_simd_list_t *r = (flux_simd_list_t *)rhs;
        flux_simd_row_t *r_rows = (flux_simd_row_t *)(uintptr_t)r->data_ptr;
        if (r_rows) {
            for (int64_t i = 0; i < r->len; i++) {
                flux_set_add_tagged(d, r_rows[i].tag, r_rows[i].val);
            }
        }
    }
    return d;
}

void *flux_set_intersect(void *lhs, void *rhs) {
    void *d = flux_set_new(4);
    if (lhs && flux_is_collection_ptr(lhs, -1) && rhs && flux_is_collection_ptr(rhs, -1)) {
        flux_simd_list_t *l = (flux_simd_list_t *)lhs;
        flux_simd_row_t *l_rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (l_rows) {
            for (int64_t i = 0; i < l->len; i++) {
                if (flux_list_contains(rhs, l_rows[i].val)) {
                    flux_set_add_tagged(d, l_rows[i].tag, l_rows[i].val);
                }
            }
        }
    }
    return d;
}

void *flux_set_difference(void *lhs, void *rhs) {
    void *d = flux_set_new(4);
    if (lhs && flux_is_collection_ptr(lhs, -1)) {
        flux_simd_list_t *l = (flux_simd_list_t *)lhs;
        flux_simd_row_t *l_rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (l_rows) {
            for (int64_t i = 0; i < l->len; i++) {
                if (!rhs || !flux_list_contains(rhs, l_rows[i].val)) {
                    flux_set_add_tagged(d, l_rows[i].tag, l_rows[i].val);
                }
            }
        }
    }
    return d;
}

void *flux_set_symmetric_difference(void *lhs, void *rhs) {
    void *d = flux_set_difference(lhs, rhs);
    if (rhs && flux_is_collection_ptr(rhs, -1)) {
        flux_simd_list_t *r = (flux_simd_list_t *)rhs;
        flux_simd_row_t *r_rows = (flux_simd_row_t *)(uintptr_t)r->data_ptr;
        if (r_rows) {
            for (int64_t i = 0; i < r->len; i++) {
                if (!lhs || !flux_list_contains(lhs, r_rows[i].val)) {
                    flux_set_add_tagged(d, r_rows[i].tag, r_rows[i].val);
                }
            }
        }
    }
    return d;
}

void *flux_set_include(void *items, int64_t val) {
    void *d = flux_list_to_set(items);
    flux_set_add_tagged(d, flux_infer_tag(0, val), val);
    return d;
}

void *flux_set_exclude(void *items, int64_t val) {
    void *d = flux_set_new(4);
    if (items && flux_is_collection_ptr(items, -1)) {
        flux_simd_list_t *l = (flux_simd_list_t *)items;
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            for (int64_t i = 0; i < l->len; i++) {
                if (!flux_val_equals(rows[i].val, val)) {
                    flux_set_add_tagged(d, rows[i].tag, rows[i].val);
                }
            }
        }
    }
    return d;
}

int64_t flux_set_is_subset(void *lhs, void *rhs) {
    if (!lhs || !flux_is_collection_ptr(lhs, -1)) return 1;
    flux_simd_list_t *l = (flux_simd_list_t *)lhs;
    if (l->len == 0) return 1;
    if (!rhs || !flux_is_collection_ptr(rhs, -1)) return 0;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return 1;
    for (int64_t i = 0; i < l->len; i++) {
        if (!flux_list_contains(rhs, rows[i].val)) return 0;
    }
    return 1;
}

int64_t flux_set_is_superset(void *lhs, void *rhs) {
    return flux_set_is_subset(rhs, lhs);
}

int64_t flux_set_is_disjoint(void *lhs, void *rhs) {
    if (!lhs || !rhs || !flux_is_collection_ptr(lhs, -1) || !flux_is_collection_ptr(rhs, -1)) return 1;
    flux_simd_list_t *l = (flux_simd_list_t *)lhs;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return 1;
    for (int64_t i = 0; i < l->len; i++) {
        if (flux_list_contains(rhs, rows[i].val)) return 0;
    }
    return 1;
}

char *flux_float_to_str(double d) {
    char *buf = (char *)malloc(64);
    if (!buf) return strdup("0.0");
    if (d == 0.0) {
        if (signbit(d)) strcpy(buf, "-0.0");
        else strcpy(buf, "0.0");
        return buf;
    }
    if (isfinite(d)) {
        int64_t iv = (int64_t)d;
        if ((double)iv == d && d > -1e16 && d < 1e16) {
            snprintf(buf, 64, "%lld.0", (long long)iv);
            return buf;
        }
        uint64_t dbits;
        memcpy(&dbits, &d, sizeof(double));
        for (int prec = 15; prec <= 17; prec++) {
            snprintf(buf, 64, "%.*g", prec, d);
            if (prec < 17) {
                double parsed = strtod(buf, NULL);
                uint64_t pbits;
                memcpy(&pbits, &parsed, sizeof(double));
                if (pbits == dbits) break;
            }
        }
        if (!strchr(buf, '.') && !strchr(buf, 'e') && !strchr(buf, 'E')) {
            strcat(buf, ".0");
        }
    } else {
        snprintf(buf, 64, "%.17g", d);
    }
    return buf;
}

void flux_float_print(double d) {
    char *s = flux_float_to_str(d);
    printf("%s\n", s);
    free(s);
}

void *flux_dataflow_join(int64_t a1_tag, int64_t a1_val, int64_t a2_tag, int64_t a2_val) {
    flux_simd_list_t *res = (flux_simd_list_t *)flux_list_create(8);
    if (a1_tag == 5 || is_flux_list((uintptr_t)a1_val)) {
        flux_simd_list_t *l1 = (flux_simd_list_t *)(uintptr_t)a1_val;
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l1->data_ptr;
        if (rows) {
            for (int64_t i = 0; i < l1->len; i++) {
                flux_list_push_tagged(res, rows[i].tag, rows[i].val);
            }
        }
    } else if (a1_tag != 0 || a1_val != 0) {
        flux_list_push_tagged(res, a1_tag, a1_val);
    }

    if (a2_tag == 5 || is_flux_list((uintptr_t)a2_val)) {
        flux_simd_list_t *l2 = (flux_simd_list_t *)(uintptr_t)a2_val;
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l2->data_ptr;
        if (rows) {
            for (int64_t i = 0; i < l2->len; i++) {
                flux_list_push_tagged(res, rows[i].tag, rows[i].val);
            }
        }
    } else if (a2_tag != 0 || a2_val != 0) {
        flux_list_push_tagged(res, a2_tag, a2_val);
    }
    return res;
}

extern void *flux_tls_str_alloc(size_t size);

char *flux_str_join(void *list_ptr, const char *sep) {
    if (!list_ptr || !flux_is_collection_ptr(list_ptr, 0)) return strdup("");
    flux_simd_list_t *lst = (flux_simd_list_t *)list_ptr;
    int64_t n = lst->len;
    if (n <= 0 || !lst->data_ptr) return strdup("");
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)lst->data_ptr;
    size_t sep_len = sep ? strlen(sep) : 0;

    size_t stack_lens[256];
    size_t *lens = (n <= 256) ? stack_lens : (size_t *)malloc((size_t)n * sizeof(size_t));
    if (!lens) return strdup("");
    size_t total = sep_len * (size_t)(n - 1);
    for (int64_t i = 0; i < n; i++) {
        const char *s = (const char *)(uintptr_t)rows[i].val;
        if (!s || (uintptr_t)s < 0x10000) {
            lens[i] = 0;
        } else {
            size_t sl = strlen(s);
            lens[i] = sl;
            total += sl;
        }
    }

    char *out = (char *)flux_tls_str_alloc(total + 1);
    if (!out) {
        if (lens != stack_lens) free(lens);
        return strdup("");
    }
    char *dst = out;
    for (int64_t i = 0; i < n; i++) {
        if (i > 0 && sep_len > 0) {
            memcpy(dst, sep, sep_len);
            dst += sep_len;
        }
        size_t sl = lens[i];
        if (sl > 0) {
            const char *s = (const char *)(uintptr_t)rows[i].val;
            memcpy(dst, s, sl);
            dst += sl;
        }
    }
    *dst = '\0';
    if (lens != stack_lens) free(lens);
    return out;
}

void *flux_set_to_list(void *src) {
    void *res = flux_list_create(16);
    if (!src || !res) return res;
    if (flux_is_collection_ptr(src, 0) || flux_is_collection_ptr(src, 1)) {
        flux_simd_list_t *l = (flux_simd_list_t *)src;
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            for (int64_t i = 0; i < l->len; i++) {
                flux_list_push_tagged(res, rows[i].tag, rows[i].val);
            }
        }
    }
    return res;
}

char *flux_std_runtime_get_type_name_val(int64_t val) {
    int64_t ltag = flux_get_last_tag(val);
    if (val == 0 && ltag == 1) return "bool";
    int64_t tag = flux_infer_tag(0, val);
    if (tag == 1) return "bool";
    if (tag == 3) return "float64";
    if (tag == 4) return "string";
    if (tag == 5) return "list";
    if (tag == 6) return "map";
    if (tag == 7) return "set";
    return "int64";
}



