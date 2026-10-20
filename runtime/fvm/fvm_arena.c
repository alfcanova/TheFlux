/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Implementação: runtime/fvm/fvm_arena.c
 * ============================================================================== */

#include "fvm_arena.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

void fvm_arena_init(FvmArena *arena, size_t default_block_size) {
    if (default_block_size < 4096) default_block_size = 64 * 1024;
    arena->block_size = default_block_size;
    arena->current = NULL;
}

void *fvm_arena_alloc(FvmArena *arena, size_t size) {
    /* Alinha para 8 bytes */
    size = (size + 7) & ~7;
    if (!arena->current || arena->current->offset + size > arena->current->capacity) {
        size_t bsize = arena->block_size;
        if (size > bsize) bsize = size + 1024;
        FvmArenaBlock *block = (FvmArenaBlock *)malloc(sizeof(FvmArenaBlock) + bsize);
        if (!block) return NULL;
        block->capacity = bsize;
        block->offset = 0;
        block->next = arena->current;
        arena->current = block;
    }
    void *ptr = arena->current->data + arena->current->offset;
    arena->current->offset += size;
    return ptr;
}

char *fvm_arena_strdup(FvmArena *arena, const char *str) {
    if (!str) return NULL;
    size_t len = strlen(str);
    char *copy = (char *)fvm_arena_alloc(arena, len + 1);
    if (copy) {
        memcpy(copy, str, len);
        copy[len] = '\0';
    }
    return copy;
}

char *fvm_arena_strndup(FvmArena *arena, const char *str, size_t n) {
    if (!str) return NULL;
    char *copy = (char *)fvm_arena_alloc(arena, n + 1);
    if (copy) {
        memcpy(copy, str, n);
        copy[n] = '\0';
    }
    return copy;
}

void fvm_arena_free_all(FvmArena *arena) {
    FvmArenaBlock *curr = arena->current;
    while (curr) {
        FvmArenaBlock *next = curr->next;
        free(curr);
        curr = next;
    }
    arena->current = NULL;
}

/* ==============================================================================
 * Construtores de Valores
 * ============================================================================== */

FluxVal fvm_val_nil(void) {
    FluxVal v;
    memset(&v, 0, sizeof(FluxVal));
    v.type = VAL_NIL;
    return v;
}

FluxVal fvm_val_bool(bool b) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_BOOL;
    v.as.i64 = b ? 1 : 0;
    return v;
}

FluxVal fvm_val_int(int64_t i) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_INT;
    v.as.i64 = i;
    return v;
}

FluxVal fvm_val_float(double f) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_FLOAT;
    v.as.f64 = f;
    return v;
}

FluxVal fvm_val_char(uint32_t c) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_CHAR;
    v.as.u32[0] = c;
    return v;
}

FluxVal fvm_val_datetime(int64_t nanos) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_DATETIME;
    v.as.i64 = nanos;
    return v;
}

FluxVal fvm_val_complex(FvmArena *arena, double r, double i) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_COMPLEX;
    FvmComplex *c = (FvmComplex *)fvm_arena_alloc(arena, sizeof(FvmComplex));
    c->real = r;
    c->imag = i;
    v.as.ptr = c;
    return v;
}

FluxVal fvm_val_str(FvmArena *arena, const char *s) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_STRING;
    if (!s) s = "";
    size_t len = strlen(s);
    FvmString *str = (FvmString *)fvm_arena_alloc(arena, sizeof(FvmString) + len + 1);
    str->len = (uint32_t)len;
    str->hash = 0;
    memcpy(str->chars, s, len + 1);
    v.as.ptr = str;
    v.len = (int32_t)len;
    return v;
}

FluxVal fvm_val_list(FvmArena *arena, uint32_t initial_cap) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_LIST;
    if (initial_cap < 8) initial_cap = 8;
    FvmList *lst = (FvmList *)fvm_arena_alloc(arena, sizeof(FvmList));
    lst->count = 0;
    lst->capacity = initial_cap;
    lst->items = (FluxVal *)fvm_arena_alloc(arena, sizeof(FluxVal) * initial_cap);
    v.as.ptr = lst;
    return v;
}

FluxVal fvm_val_map(FvmArena *arena) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_MAP;
    FvmMap *m = (FvmMap *)fvm_arena_alloc(arena, sizeof(FvmMap));
    m->count = 0;
    m->bucket_count = 16;
    m->buckets = (FvmMapEntry **)fvm_arena_alloc(arena, sizeof(FvmMapEntry *) * m->bucket_count);
    memset(m->buckets, 0, sizeof(FvmMapEntry *) * m->bucket_count);
    v.as.ptr = m;
    return v;
}

FluxVal fvm_val_struct(FvmArena *arena, const char *type_name, uint32_t nfields) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_STRUCT;
    FvmStruct *s = (FvmStruct *)fvm_arena_alloc(arena, sizeof(FvmStruct));
    s->type_name = fvm_arena_strdup(arena, type_name);
    s->field_count = nfields;
    s->fields = nfields ? (FvmField *)fvm_arena_alloc(arena, sizeof(FvmField) * nfields) : NULL;
    v.as.ptr = s;
    return v;
}

FluxVal fvm_val_enum(FvmArena *arena, const char *type_name, const char *variant, int32_t tag, uint32_t nfields) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_ENUM;
    FvmEnum *e = (FvmEnum *)fvm_arena_alloc(arena, sizeof(FvmEnum));
    e->type_name = fvm_arena_strdup(arena, type_name);
    e->variant = fvm_arena_strdup(arena, variant);
    e->tag = tag;
    e->field_count = nfields;
    e->fields = nfields ? (FvmField *)fvm_arena_alloc(arena, sizeof(FvmField) * nfields) : NULL;
    v.as.ptr = e;
    return v;
}

FluxVal fvm_val_status(FvmArena *arena, const char *status, FluxVal val, const char *msg) {
    FluxVal v = fvm_val_nil();
    v.type = VAL_STATUS;
    FvmStatus *st = (FvmStatus *)fvm_arena_alloc(arena, sizeof(FvmStatus));
    st->status = fvm_arena_strdup(arena, status);
    st->val = val;
    st->msg = fvm_arena_strdup(arena, msg ? msg : "");
    v.as.ptr = st;
    return v;
}

FluxVal fvm_unwrap(FluxVal v) {
    while (v.type == VAL_STATUS && v.as.ptr) {
        FvmStatus *st = (FvmStatus *)v.as.ptr;
        v = st->val;
    }
    return v;
}

bool fvm_val_is_truthy(FluxVal v) {
    v = fvm_unwrap(v);
    switch (v.type) {
        case VAL_NIL: return false;
        case VAL_BOOL: return v.as.i64 != 0;
        case VAL_INT: return v.as.i64 != 0;
        case VAL_FLOAT: return v.as.f64 != 0.0;
        case VAL_STRING: {
            FvmString *s = (FvmString *)v.as.ptr;
            return s && s->len > 0;
        }
        case VAL_LIST: {
            FvmList *l = (FvmList *)v.as.ptr;
            return l && l->count > 0;
        }
        default: return true;
    }
}

/* ==============================================================================
 * Formatação e Impressão Canônica
 * ============================================================================== */

static void append_str(char **acc, size_t *acc_len, size_t *acc_cap, const char *str) {
    if (!acc || !str) return;
    size_t slen = strlen(str);
    if (*acc_len + slen + 1 > *acc_cap) {
        size_t ncap = (*acc_cap == 0) ? 1024 : (*acc_cap * 2);
        while (ncap < *acc_len + slen + 1) ncap *= 2;
        *acc = (char *)realloc(*acc, ncap);
        *acc_cap = ncap;
    }
    memcpy(*acc + *acc_len, str, slen);
    *acc_len += slen;
    (*acc)[*acc_len] = '\0';
}

char *fvm_val_to_str(FvmArena *arena, FluxVal v) {
    v = fvm_unwrap(v);
    char buf[128];
    switch (v.type) {
        case VAL_NIL:
            return fvm_arena_strdup(arena, "nil");
        case VAL_BOOL:
            return fvm_arena_strdup(arena, v.as.i64 ? "true" : "false");
        case VAL_INT:
            snprintf(buf, sizeof(buf), "%lld", (long long)v.as.i64);
            return fvm_arena_strdup(arena, buf);
        case VAL_FLOAT: {
            snprintf(buf, sizeof(buf), "%.6g", v.as.f64);
            return fvm_arena_strdup(arena, buf);
        }
        case VAL_CHAR: {
            char cbuf[5] = {0};
            cbuf[0] = (char)(v.as.u32[0] & 0x7F);
            return fvm_arena_strdup(arena, cbuf);
        }
        case VAL_STRING: {
            FvmString *s = (FvmString *)v.as.ptr;
            return s ? fvm_arena_strdup(arena, s->chars) : fvm_arena_strdup(arena, "");
        }
        case VAL_ENUM: {
            FvmEnum *e = (FvmEnum *)v.as.ptr;
            if (!e) return fvm_arena_strdup(arena, "");
            if (e->field_count == 0) {
                snprintf(buf, sizeof(buf), "%s::%s", e->type_name, e->variant);
                return fvm_arena_strdup(arena, buf);
            }
            char *dyn = NULL; size_t dlen = 0, dcap = 0;
            snprintf(buf, sizeof(buf), "%s::%s(", e->type_name, e->variant);
            append_str(&dyn, &dlen, &dcap, buf);
            for (uint32_t i = 0; i < e->field_count; i++) {
                if (i > 0) append_str(&dyn, &dlen, &dcap, ", ");
                append_str(&dyn, &dlen, &dcap, ".");
                append_str(&dyn, &dlen, &dcap, e->fields[i].name ? e->fields[i].name : "");
                append_str(&dyn, &dlen, &dcap, ": ");
                char *fstr = fvm_val_to_str(arena, e->fields[i].val);
                append_str(&dyn, &dlen, &dcap, fstr);
            }
            append_str(&dyn, &dlen, &dcap, ")");
            char *res = fvm_arena_strdup(arena, dyn);
            free(dyn);
            return res;
        }
        case VAL_STRUCT: {
            FvmStruct *s = (FvmStruct *)v.as.ptr;
            if (!s) return fvm_arena_strdup(arena, "struct{}");
            char *dyn = NULL; size_t dlen = 0, dcap = 0;
            snprintf(buf, sizeof(buf), "%s(", s->type_name);
            append_str(&dyn, &dlen, &dcap, buf);
            for (uint32_t i = 0; i < s->field_count; i++) {
                if (i > 0) append_str(&dyn, &dlen, &dcap, ", ");
                append_str(&dyn, &dlen, &dcap, ".");
                append_str(&dyn, &dlen, &dcap, s->fields[i].name ? s->fields[i].name : "");
                append_str(&dyn, &dlen, &dcap, ": ");
                char *fstr = fvm_val_to_str(arena, s->fields[i].val);
                append_str(&dyn, &dlen, &dcap, fstr);
            }
            append_str(&dyn, &dlen, &dcap, ")");
            char *res = fvm_arena_strdup(arena, dyn);
            free(dyn);
            return res;
        }
        case VAL_LIST: {
            FvmList *lst = (FvmList *)v.as.ptr;
            if (!lst || lst->count == 0) return fvm_arena_strdup(arena, "[]");
            char *dyn = NULL; size_t dlen = 0, dcap = 0;
            append_str(&dyn, &dlen, &dcap, "[");
            for (uint32_t i = 0; i < lst->count; i++) {
                if (i > 0) append_str(&dyn, &dlen, &dcap, ", ");
                char *item = fvm_val_to_str(arena, lst->items[i]);
                append_str(&dyn, &dlen, &dcap, item);
            }
            append_str(&dyn, &dlen, &dcap, "]");
            char *res = fvm_arena_strdup(arena, dyn);
            free(dyn);
            return res;
        }
        default:
            return fvm_arena_strdup(arena, "<value>");
    }
}

void fvm_val_print(FluxVal v, bool newline, FILE *stream, char **str_acc, size_t *acc_len, size_t *acc_cap) {
    FvmArena tmp_arena;
    fvm_arena_init(&tmp_arena, 4096);
    char *s = fvm_val_to_str(&tmp_arena, v);

    if (stream) {
        if (newline) {
            fprintf(stream, "%s\n", s);
        } else {
            fprintf(stream, "%s", s);
        }
        fflush(stream);
    }

    if (str_acc) {
        append_str(str_acc, acc_len, acc_cap, s);
        if (newline) append_str(str_acc, acc_len, acc_cap, "\n");
    }

    fvm_arena_free_all(&tmp_arena);
}

bool fvm_val_equal(FluxVal a, FluxVal b) {
    a = fvm_unwrap(a);
    b = fvm_unwrap(b);
    if (a.type != b.type) {
        /* Coerção numérica int/float */
        if (a.type == VAL_INT && b.type == VAL_FLOAT) {
            return (double)a.as.i64 == b.as.f64;
        }
        if (a.type == VAL_FLOAT && b.type == VAL_INT) {
            return a.as.f64 == (double)b.as.i64;
        }
        return false;
    }
    switch (a.type) {
        case VAL_NIL: return true;
        case VAL_BOOL: return (a.as.i64 != 0) == (b.as.i64 != 0);
        case VAL_INT: return a.as.i64 == b.as.i64;
        case VAL_FLOAT: return a.as.f64 == b.as.f64;
        case VAL_CHAR: return a.as.u32[0] == b.as.u32[0];
        case VAL_DATETIME: return a.as.i64 == b.as.i64;
        case VAL_STRING: {
            FvmString *sa = (FvmString *)a.as.ptr;
            FvmString *sb = (FvmString *)b.as.ptr;
            if (!sa || !sb) return sa == sb;
            if (sa->len != sb->len) return false;
            return memcmp(sa->chars, sb->chars, sa->len) == 0;
        }
        case VAL_ENUM: {
            FvmEnum *ea = (FvmEnum *)a.as.ptr;
            FvmEnum *eb = (FvmEnum *)b.as.ptr;
            if (!ea || !eb) return ea == eb;
            return ea->tag == eb->tag && strcmp(ea->variant, eb->variant) == 0;
        }
        default:
            return a.as.ptr == b.as.ptr;
    }
}
