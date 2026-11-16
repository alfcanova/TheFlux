/* ==============================================================================
 * TheFlux Native Runtime: Dynamic Vector / List (Conforming to Flux SIMD)
 * Source: runtime/src/collections/list.c
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

#define FLUX_MAX_COLLECTION_CAP 1000000LL

bool flux_is_list(void *p) {
    if (!p || (uintptr_t)p < 0x10000 || !is_valid_readable_ptr(p)) return false;
    flux_simd_list_t *list = (flux_simd_list_t *)p;
    return (list->kind == 0 && list->len >= 0 && list->len <= FLUX_MAX_COLLECTION_CAP);
}

void *flux_list_build(int64_t n, int64_t tag) {
    if (n < 0 || n > FLUX_MAX_COLLECTION_CAP) return NULL;
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

void *flux_list_push(void *list, int64_t tag, int64_t ival, const char *sval) {
    if (!list) return NULL;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->len >= FLUX_MAX_COLLECTION_CAP) return list;
    list_grow(l, l->len + 1);
    if (l->cap < l->len + 1) return list;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return list;
    int64_t n = l->len;
    rows[n].tag = tag;
    rows[n].val = (tag == 4 && sval) ? (int64_t)(uintptr_t)sval : ival;
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

int64_t flux_list_get_val(void *list, int64_t index) {
    if (!list || !is_valid_readable_ptr(list)) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->kind != 0) return 0;
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
    if (index >= 1 && index <= l->len) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            rows[index - 1].tag = tag;
            rows[index - 1].val = val;
        }
        return;
    }
    if (index == 0 && l->len > 0) {
        flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
        if (rows) {
            rows[0].tag = tag;
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
            rows[index - 1].tag = tag;
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
    if (!list || !is_valid_readable_ptr(list)) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    if (l->kind != 0) return 0;
    return l->len;
}

int64_t flux_list_contains(void *list, int64_t val) {
    if (!list) return 0;
    flux_simd_list_t *l = (flux_simd_list_t *)list;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return 0;
    for (int64_t i = 0; i < l->len; i++) {
        if (rows[i].tag == 4 && is_valid_readable_ptr((const void *)(uintptr_t)rows[i].val) && is_valid_readable_ptr((const void *)(uintptr_t)val)) {
            if (strcmp((const char *)(uintptr_t)rows[i].val, (const char *)(uintptr_t)val) == 0) {
                return 1;
            }
        } else if (rows[i].val == val) {
            return 1;
        }
    }
    return 0;
}

char *flux_list_to_str(void *p);

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
    if ((uintptr_t)val < 0x10000 || !is_valid_readable_ptr((const void *)(uintptr_t)val)) {
        char *buf = (char *)malloc(32);
        if (buf) snprintf(buf, 32, "%lld", (long long)val);
        return buf;
    }
    flux_simd_list_t *list = (flux_simd_list_t *)(uintptr_t)val;
    if (list->kind == 0 && list->len >= 0 && list->len <= FLUX_MAX_COLLECTION_CAP && list->cap >= list->len && list->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)list->data_ptr)) {
        return flux_list_to_str((void*)(uintptr_t)val);
    }
    if (list->kind == 1 && list->len >= 0 && list->len <= FLUX_MAX_COLLECTION_CAP && list->cap >= list->len && list->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)list->data_ptr)) {
        return flux_set_to_str((void*)(uintptr_t)val);
    }
    if (list->kind == 2 && list->len >= 0 && list->len <= FLUX_MAX_COLLECTION_CAP && list->cap >= list->len && list->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)list->data_ptr)) {
        return flux_map_to_str((void*)(uintptr_t)val);
    }
    const char *s = (const char *)(uintptr_t)val;
    int is_str = 1;
    for (int c = 0; c < 64 && s[c] != '\0'; c++) {
        if ((unsigned char)s[c] < 32 && s[c] != '\n' && s[c] != '\t' && s[c] != '\r') {
            is_str = 0;
            break;
        }
    }
    if (is_str && s[0] != '\0') {
        size_t slen = strlen(s);
        if (slen <= FLUX_MAX_COLLECTION_CAP) {
            char *res = (char *)malloc(slen + 1);
            if (res) memcpy(res, s, slen + 1);
            return res;
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
    if ((uintptr_t)p < 0x10000 || !is_valid_readable_ptr(p)) {
        char *s = (char*)malloc(32);
        if (s) snprintf(s, 32, "%lld", (long long)(uintptr_t)p);
        return s;
    }
    flux_simd_list_t *list = (flux_simd_list_t *)p;
    if (!is_valid_readable_ptr((const void *)(uintptr_t)list->data_ptr) || list->len < 0 || list->len > FLUX_MAX_COLLECTION_CAP) {
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
        if (tag == 5 && is_valid_readable_ptr((const void *)(uintptr_t)val)) {
            flux_simd_list_t *sub = (flux_simd_list_t *)(uintptr_t)val;
            alloc_elem = flux_list_to_str(sub);
            elem_str = alloc_elem ? alloc_elem : "[]";
        } else if (tag == 6 && is_valid_readable_ptr((const void *)(uintptr_t)val)) {
            alloc_elem = flux_map_to_str((void*)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "{}";
        } else if (tag == 7 && is_valid_readable_ptr((const void *)(uintptr_t)val)) {
            alloc_elem = flux_set_to_str((void*)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "{}";
        } else if ((tag == 10 || tag == 8) && is_valid_readable_ptr((const void *)(uintptr_t)val)) {
            alloc_elem = flux_complex_to_str((void*)(uintptr_t)val);
            elem_str = alloc_elem ? alloc_elem : "0.0 + 0.0i";
        } else if (tag == 4) {
            if ((uintptr_t)val < 0x10000 || !is_valid_readable_ptr((const void *)(uintptr_t)val)) {
                snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
            } else {
                char *s = (char *)(uintptr_t)val;
                snprintf(elem_buf, sizeof(elem_buf), "%s", s ? s : "");
            }
        } else if (tag == 3) {
            double d;
            memcpy(&d, &val, sizeof(double));
            snprintf(elem_buf, sizeof(elem_buf), "%.9g", d);
            if (!strchr(elem_buf, '.') && !strchr(elem_buf, 'e') && !strchr(elem_buf, 'E')) {
                strcat(elem_buf, ".0");
            }
        } else if (tag == 1) {
            snprintf(elem_buf, sizeof(elem_buf), "%s", val ? "true" : "false");
        } else if (tag == 2) {
            snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
        } else if (is_valid_readable_ptr((const void *)(uintptr_t)val)) {
            flux_simd_list_t *sub = (flux_simd_list_t *)(uintptr_t)val;
            if (sub->kind == 0 && sub->len >= 0 && sub->len <= FLUX_MAX_COLLECTION_CAP && sub->cap >= sub->len && sub->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)sub->data_ptr)) {
                alloc_elem = flux_list_to_str(sub);
                elem_str = alloc_elem ? alloc_elem : "[]";
            } else if (sub->kind == 1 && sub->len >= 0 && sub->len <= FLUX_MAX_COLLECTION_CAP && sub->cap >= sub->len && sub->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)sub->data_ptr)) {
                alloc_elem = flux_set_to_str(sub);
                elem_str = alloc_elem ? alloc_elem : "{}";
            } else if (sub->kind == 2 && sub->len >= 0 && sub->len <= FLUX_MAX_COLLECTION_CAP && sub->cap >= sub->len && sub->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)sub->data_ptr)) {
                alloc_elem = flux_map_to_str(sub);
                elem_str = alloc_elem ? alloc_elem : "{}";
            } else {
                const char *s = (const char *)(uintptr_t)val;
                int is_str = 1;
                for (int c = 0; c < 64 && s[c] != '\0'; c++) {
                    if ((unsigned char)s[c] < 32 && s[c] != '\n' && s[c] != '\t' && s[c] != '\r') {
                        is_str = 0;
                        break;
                    }
                }
                if (is_str && s[0] != '\0') {
                    snprintf(elem_buf, sizeof(elem_buf), "%s", s);
                } else {
                    snprintf(elem_buf, sizeof(elem_buf), "%lld", (long long)val);
                }
            }
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

extern char *flux_str_slice(const char *p, int64_t s, int64_t e);

static bool is_flux_list(uintptr_t val) {
    if (!is_valid_readable_ptr((const void *)val)) return false;
    flux_simd_list_t *list = (flux_simd_list_t *)val;
    if (list->kind == 0 && list->len >= 0 && list->len <= FLUX_MAX_COLLECTION_CAP && list->cap >= list->len && list->cap > 0 && is_valid_readable_ptr((const void *)(uintptr_t)list->data_ptr)) {
        return true;
    }
    return false;
}

void *flux_slice(void *p, int64_t start, int64_t end) {
    if (!p) return flux_list_build(0, 0);
    if (is_flux_list((uintptr_t)p)) {
        return flux_list_slice(p, start, end);
    }
    if (is_valid_readable_ptr(p)) {
        return flux_str_slice((const char *)p, start, end);
    }
    return flux_list_build(0, 0);
}

void flux_set_add_tagged(void *set, int64_t tag, int64_t val) {
    if (!set) return;
    flux_simd_list_t *l = (flux_simd_list_t *)set;
    if (l->len >= FLUX_MAX_COLLECTION_CAP) return;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (rows) {
        for (int64_t i = 0; i < l->len; i++) {
            if (rows[i].tag == tag && rows[i].val == val) return;
            if (rows[i].tag == 4 && tag == 4 && is_valid_readable_ptr((const void *)(uintptr_t)rows[i].val) && is_valid_readable_ptr((const void *)(uintptr_t)val)) {
                if (strcmp((const char *)(uintptr_t)rows[i].val, (const char *)(uintptr_t)val) == 0) return;
            }
        }
    }
    flux_list_push_tagged(set, tag, val);
}

void *flux_list_to_set(void *src) {
    if (!src) return flux_list_build(0, 0);
    flux_simd_list_t *s = (flux_simd_list_t *)src;
    flux_simd_list_t *d = (flux_simd_list_t *)flux_list_build(s->len > 0 ? s->len : 4, 0);
    flux_simd_row_t *s_rows = (flux_simd_row_t *)(uintptr_t)s->data_ptr;
    if (s_rows) {
        for (int64_t i = 0; i < s->len; i++) {
            flux_set_add_tagged(d, s_rows[i].tag, s_rows[i].val);
        }
    }
    return d;
}

char *flux_float_to_str(double d) {
    char *buf = (char *)malloc(64);
    if (!buf) return strdup("0.0");
    snprintf(buf, 64, "%.17g", d);
    if (!strchr(buf, '.') && !strchr(buf, 'e') && !strchr(buf, 'E')) {
        strcat(buf, ".0");
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

