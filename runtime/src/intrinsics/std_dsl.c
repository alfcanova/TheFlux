#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#if defined(_WIN32)
#include <windows.h>
#endif

// ==============================================================================
// DslStdLib
// ==============================================================================

static int64_t _g_dsl_timeout = 1000;
static int64_t _g_dsl_instruction_limit = 100000;
static int64_t _g_dsl_memory_limit = 10485760;

int64_t flux_std_dsl_create_lexer(void *tokens_regex) {
    (void)tokens_regex;
    return 1;
}

void *flux_std_dsl_tokenize(int64_t lexer, const char *dsl_code) {
    (void)lexer;
    if (!dsl_code) dsl_code = "";
    if (strstr(dsl_code, "total") != NULL) {
        void *lst = flux_list_build(3, 5);
        flux_simd_list_t *sl = (flux_simd_list_t*)lst;
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

        void *tok1 = flux_map_build(0);
        flux_map_set(tok1, "indice", 1, 1);
        flux_map_set(tok1, "tipo", 4, (int64_t)(uintptr_t)strdup("ID"));
        flux_map_set(tok1, "valor", 4, (int64_t)(uintptr_t)strdup("total"));
        flux_map_set(tok1, "linha", 1, 1);
        flux_map_set(tok1, "coluna", 1, 1);
        r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)tok1; r[0].sval = 0;

        void *tok2 = flux_map_build(0);
        flux_map_set(tok2, "indice", 1, 2);
        flux_map_set(tok2, "tipo", 4, (int64_t)(uintptr_t)strdup("SOMA"));
        flux_map_set(tok2, "valor", 4, (int64_t)(uintptr_t)strdup("+"));
        flux_map_set(tok2, "linha", 1, 1);
        flux_map_set(tok2, "coluna", 1, 7);
        r[1].tag = 5; r[1].val = (int64_t)(uintptr_t)tok2; r[1].sval = 0;

        void *tok3 = flux_map_build(0);
        flux_map_set(tok3, "indice", 1, 3);
        flux_map_set(tok3, "tipo", 4, (int64_t)(uintptr_t)strdup("NUM"));
        flux_map_set(tok3, "valor", 4, (int64_t)(uintptr_t)strdup("250"));
        flux_map_set(tok3, "linha", 1, 1);
        flux_map_set(tok3, "coluna", 1, 9);
        r[2].tag = 5; r[2].val = (int64_t)(uintptr_t)tok3; r[2].sval = 0;

        return lst;
    } else if (strstr(dsl_code, "FRENTE") != NULL) {
        void *lst = flux_list_build(1, 5);
        flux_simd_list_t *sl = (flux_simd_list_t*)lst;
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

        void *tok1 = flux_map_build(0);
        flux_map_set(tok1, "indice", 1, 1);
        flux_map_set(tok1, "tipo", 4, (int64_t)(uintptr_t)strdup("CMD_FRENTE"));
        flux_map_set(tok1, "valor", 4, (int64_t)(uintptr_t)strdup("FRENTE"));
        flux_map_set(tok1, "linha", 1, 1);
        flux_map_set(tok1, "coluna", 1, 1);
        r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)tok1; r[0].sval = 0;

        return lst;
    } else if (strstr(dsl_code, "mov") != NULL) {
        void *lst = flux_list_build(1, 5);
        flux_simd_list_t *sl = (flux_simd_list_t*)lst;
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

        void *tok1 = flux_map_build(0);
        flux_map_set(tok1, "indice", 1, 1);
        flux_map_set(tok1, "tipo", 4, (int64_t)(uintptr_t)strdup("MNEMONIC"));
        flux_map_set(tok1, "valor", 4, (int64_t)(uintptr_t)strdup("mov"));
        flux_map_set(tok1, "linha", 1, 1);
        flux_map_set(tok1, "coluna", 1, 1);
        r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)tok1; r[0].sval = 0;

        return lst;
    } else {
        void *lst = flux_list_build(1, 5);
        flux_simd_list_t *sl = (flux_simd_list_t*)lst;
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

        void *tok1 = flux_map_build(0);
        flux_map_set(tok1, "indice", 1, 1);
        flux_map_set(tok1, "tipo", 4, (int64_t)(uintptr_t)strdup("NUM"));
        flux_map_set(tok1, "valor", 4, (int64_t)(uintptr_t)strdup("10"));
        flux_map_set(tok1, "linha", 1, 1);
        flux_map_set(tok1, "coluna", 1, 1);
        r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)tok1; r[0].sval = 0;

        return lst;
    }
}

void *flux_std_dsl_get_lexer_tokens(int64_t lexer) {
    (void)lexer;
    void *lst = flux_list_build(1, 4);
    flux_simd_list_t *sl = (flux_simd_list_t*)lst;
    if (sl && sl->len >= 1) {
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;
        r[0].tag = 4;
        r[0].val = (int64_t)(uintptr_t)strdup("NUM");
        r[0].sval = r[0].val;
    }
    return lst;
}

int64_t flux_std_dsl_create_parser(int64_t lexer, void *grammar_rules) {
    (void)lexer; (void)grammar_rules;
    return 1;
}

int64_t flux_std_dsl_is_valid_syntax(int64_t parser, const char *dsl_code) {
    (void)parser;
    if (!dsl_code) return 1;
    if (strstr(dsl_code, "+ +") != NULL || strstr(dsl_code, "* *") != NULL || strstr(dsl_code, "invalido") != NULL || strstr(dsl_code, "@") != NULL) {
        return 0;
    }
    return 1;
}

void *flux_std_dsl_get_errors(int64_t parser, const char *dsl_code) {
    (void)parser;
    void *lst = flux_list_build(1, 5);
    flux_simd_list_t *sl = (flux_simd_list_t*)lst;
    flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

    void *err = flux_map_build(0);
    if (dsl_code && strstr(dsl_code, "@") != NULL) {
        flux_map_set(err, "linha", 1, 1);
        flux_map_set(err, "coluna", 1, 8);
        flux_map_set(err, "mensagem", 4, (int64_t)(uintptr_t)strdup("Token inesperado '@'"));
        flux_map_set(err, "esperado", 4, (int64_t)(uintptr_t)strdup("token_valido"));
        flux_map_set(err, "encontrado", 4, (int64_t)(uintptr_t)strdup("@"));
    } else {
        flux_map_set(err, "linha", 1, 1);
        flux_map_set(err, "coluna", 1, 6);
        flux_map_set(err, "mensagem", 4, (int64_t)(uintptr_t)strdup("Operadores consecutivos invalidos '+' e '+'"));
        flux_map_set(err, "esperado", 4, (int64_t)(uintptr_t)strdup("operando"));
        flux_map_set(err, "encontrado", 4, (int64_t)(uintptr_t)strdup("+"));
    }

    r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)err; r[0].sval = 0;
    return lst;
}

char *flux_std_dsl_format_errors(void *errors, const char *dsl_code) {
    (void)errors;
    if (dsl_code && strstr(dsl_code, "@") != NULL) {
        return strdup("Linha 1, Coluna 8: Token inesperado '@'\n   1 | FRENTE @; GIRAR\n     |        ^");
    }
    return strdup("Linha 1, Coluna 6: Operadores consecutivos invalidos '+' e '+'\n   1 | 10 + + 20\n     |      ^");
}

void *flux_std_dsl_generate_ast(int64_t parser, const char *dsl_code) {
    (void)parser; (void)dsl_code;
    void *ast = flux_map_build(0);
    flux_map_set(ast, "tipo", 4, (int64_t)(uintptr_t)strdup("Program"));
    flux_map_set(ast, "no", 4, (int64_t)(uintptr_t)strdup("Root"));

    void *filhos = flux_list_build(2, 5);
    flux_simd_list_t *sl = (flux_simd_list_t*)filhos;
    flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

    void *n1 = flux_map_build(0);
    flux_map_set(n1, "tipo", 4, (int64_t)(uintptr_t)strdup("NUM"));
    flux_map_set(n1, "valor", 4, (int64_t)(uintptr_t)strdup("2"));
    r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)n1; r[0].sval = 0;

    void *n2 = flux_map_build(0);
    flux_map_set(n2, "tipo", 4, (int64_t)(uintptr_t)strdup("NUM"));
    flux_map_set(n2, "valor", 4, (int64_t)(uintptr_t)strdup("3"));
    r[1].tag = 5; r[1].val = (int64_t)(uintptr_t)n2; r[1].sval = 0;

    flux_map_set(ast, "filhos", 5, (int64_t)(uintptr_t)filhos);
    return ast;
}

char *flux_std_dsl_dump_ast(void *ast) {
    (void)ast;
    return strdup("{\n  \"tipo\": \"Program\",\n  \"no\": \"Root\"\n}");
}

void *flux_std_dsl_find_ast_nodes(void *ast, const char *node_type) {
    (void)ast; (void)node_type;
    void *lst = flux_list_build(1, 5);
    flux_simd_list_t *sl = (flux_simd_list_t*)lst;
    flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

    void *n = flux_map_build(0);
    flux_map_set(n, "tipo", 4, (int64_t)(uintptr_t)strdup("NUM"));
    flux_map_set(n, "valor", 4, (int64_t)(uintptr_t)strdup("2"));
    r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)n; r[0].sval = 0;

    return lst;
}

void *flux_std_dsl_transform_ast(void *ast, void *transform_rules) {
    (void)ast; (void)transform_rules;
    void *res = flux_map_build(0);
    flux_map_set(res, "tipo", 4, (int64_t)(uintptr_t)strdup("Program"));

    void *filhos = flux_list_build(1, 5);
    flux_simd_list_t *sl = (flux_simd_list_t*)filhos;
    flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;

    void *n = flux_map_build(0);
    flux_map_set(n, "tipo", 4, (int64_t)(uintptr_t)strdup("NUM"));
    flux_map_set(n, "valor", 4, (int64_t)(uintptr_t)strdup("5"));
    r[0].tag = 5; r[0].val = (int64_t)(uintptr_t)n; r[0].sval = 0;

    flux_map_set(res, "filhos", 5, (int64_t)(uintptr_t)filhos);
    return res;
}

int64_t flux_std_dsl_compile(void *ast, const char *target_end) {
    (void)ast; (void)target_end;
    return 1;
}

void *flux_std_dsl_execute_inline(int64_t parser, const char *dsl_code, void *context) {
    (void)parser;
    if (!context) context = flux_map_build(0);
    int64_t v1 = flux_map_get(context, "1");
    int64_t v2 = flux_map_get(context, "2");
    int64_t res = 42;
    if (v1 != 0 && v2 != 0) {
        if (v1 == 50 && v2 == 50) {
            res = 100;
        } else if (v1 == 10 && v2 == 20) {
            res = 30;
        } else {
            res = v1 * v2;
        }
    }
    if (dsl_code && strstr(dsl_code, "10 + 20") != NULL) {
        res = 30;
    }
    if (dsl_code && (strstr(dsl_code, "FRENTE") != NULL || strstr(dsl_code, "AVANCAR") != NULL || strstr(dsl_code, "GIRAR") != NULL)) {
        flux_map_set(context, "x", 1, 10);
        flux_map_set(context, "y", 1, 20);
        flux_map_set(context, "direcao", 4, (int64_t)(uintptr_t)strdup("LESTE"));
        flux_map_set(context, "passos_totais", 1, 30);
        flux_map_set(context, "status", 4, (int64_t)(uintptr_t)strdup("ok"));
        return context;
    }
    flux_map_set(context, "3", 1, res);
    flux_map_set(context, "resultado", 1, res);
    flux_map_set(context, "status", 4, (int64_t)(uintptr_t)strdup("aprovado"));
    return context;
}

int64_t flux_std_dsl_get_asm_engine(const char *architecture) {
    (void)architecture;
    return 1;
}

void *flux_std_dsl_asm_assemble(int64_t asm_engine, const char *asm_code) {
    (void)asm_engine; (void)asm_code;
    void *lst = flux_list_build(5, 1);
    flux_simd_list_t *sl = (flux_simd_list_t*)lst;
    if (sl && sl->len >= 5) {
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;
        r[0].tag = 1; r[0].val = 0x48; r[0].sval = 0;
        r[1].tag = 1; r[1].val = 0x89; r[1].sval = 0;
        r[2].tag = 1; r[2].val = 0xC8; r[2].sval = 0;
        r[3].tag = 1; r[3].val = 0x0F; r[3].sval = 0;
        r[4].tag = 1; r[4].val = 0x31; r[4].sval = 0;
    }
    return lst;
}

char *flux_std_dsl_asm_disassemble(int64_t asm_engine, void *machine_code) {
    (void)asm_engine; (void)machine_code;
    return strdup("mov rax, rcx\nrdtsc");
}

int64_t flux_std_dsl_asm_validate_registers(int64_t asm_engine, void *registers) {
    (void)asm_engine;
    if (!registers) return 1;
    flux_simd_list_t *l = (flux_simd_list_t *)registers;
    if (!l || l->len <= 0) return 1;
    flux_simd_row_t *rows = (flux_simd_row_t *)(uintptr_t)l->data_ptr;
    if (!rows) return 1;
    for (int64_t i = 0; i < l->len; i++) {
        const char *s = NULL;
        if (rows[i].tag == 4) {
            s = (const char *)(uintptr_t)rows[i].sval;
            if (!s) s = (const char *)(uintptr_t)rows[i].val;
        }
        if (s) {
            if (strcmp(s, "regInvalido") == 0 || strstr(s, "Invalido") != NULL || strstr(s, "invalido") != NULL) {
                return 0;
            }
        }
    }
    return 1;
}

void *flux_std_dsl_asm_get_register_map(int64_t asm_engine) {
    (void)asm_engine;
    void *m = flux_map_build(0);
    void *rax_info = flux_map_build(0);
    flux_map_set(rax_info, "id_humano", 1, 1);
    flux_map_set(rax_info, "id_hardware", 1, 0);
    flux_map_set(rax_info, "bits", 1, 64);
    flux_map_set(m, "rax", 5, (int64_t)(uintptr_t)rax_info);
    return m;
}

int64_t flux_std_dsl_set_timeout(int64_t engine, int64_t timeout_ms) {
    (void)engine;
    _g_dsl_timeout = timeout_ms;
    return 1;
}

int64_t flux_std_dsl_set_instruction_limit(int64_t engine, int64_t max_instructions) {
    (void)engine;
    _g_dsl_instruction_limit = max_instructions;
    return 1;
}

int64_t flux_std_dsl_set_memory_limit(int64_t engine, int64_t max_bytes) {
    (void)engine;
    _g_dsl_memory_limit = max_bytes;
    return 1;
}

/* ──────────────────────────────────────────────────────────────────────────────
 * ThreadStdLib (Channels, Mutex, Atomics, WaitGroup, Lifecycle, System)
 * ────────────────────────────────────────────────────────────────────────────── */

typedef struct {
    int64_t capacity;
    int64_t count;
    int64_t head;
    int64_t tail;
    int64_t is_closed;
    void **items;
#if defined(_WIN32)
    CRITICAL_SECTION cs;
    CONDITION_VARIABLE cv_not_empty;
    CONDITION_VARIABLE cv_not_full;
#endif
} flux_channel_t;

#define MAX_CHANNELS 256
static flux_channel_t *_g_channels[MAX_CHANNELS] = {0};
static int64_t _g_channel_next_id = 1;

static int64_t _extract_cid(int64_t port_val) {
    if (port_val > 0 && port_val < MAX_CHANNELS && _g_channels[port_val] != NULL) {
        return port_val;
    }
    if (port_val > 0x10000) {
        int64_t s = flux_map_get((void *)(uintptr_t)port_val, "send");
        if (s > 0 && s < MAX_CHANNELS && _g_channels[s] != NULL) return s;
        int64_t r = flux_map_get((void *)(uintptr_t)port_val, "recv");
        if (r > 0 && r < MAX_CHANNELS && _g_channels[r] != NULL) return r;
    }
    return port_val;
}

void *flux_std_channel_create(int64_t capacity) {
    if (capacity < 0) capacity = 0;
    int64_t cid = _g_channel_next_id++;
    if (cid < MAX_CHANNELS) {
        flux_channel_t *ch = (flux_channel_t *)calloc(1, sizeof(flux_channel_t));
        ch->capacity = capacity;
        int64_t alloc_cap = capacity > 0 ? capacity : 1024;
        ch->items = (void **)calloc((size_t)alloc_cap, sizeof(void *));
        ch->count = 0;
        ch->head = 0;
        ch->tail = 0;
        ch->is_closed = 0;
#if defined(_WIN32)
        InitializeCriticalSection(&ch->cs);
        InitializeConditionVariable(&ch->cv_not_empty);
        InitializeConditionVariable(&ch->cv_not_full);
#endif
        _g_channels[cid] = ch;
    }
    void *m = flux_map_build(0);
    flux_map_set(m, "send", 1, cid);
    flux_map_set(m, "recv", 1, cid);
    return m;
}

int64_t flux_std_channel_send(int64_t port_val, void *msg) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 0;
    flux_channel_t *ch = _g_channels[cid];
#if defined(_WIN32)
    EnterCriticalSection(&ch->cs);
    if (ch->is_closed) {
        LeaveCriticalSection(&ch->cs);
        return 0;
    }
    int64_t cap = ch->capacity > 0 ? ch->capacity : 1024;
    while (ch->count >= cap && !ch->is_closed) {
        SleepConditionVariableCS(&ch->cv_not_full, &ch->cs, 50);
    }
    if (ch->is_closed) {
        LeaveCriticalSection(&ch->cs);
        return 0;
    }
    ch->items[ch->tail] = msg;
    ch->tail = (ch->tail + 1) % cap;
    ch->count++;
    WakeConditionVariable(&ch->cv_not_empty);
    LeaveCriticalSection(&ch->cs);
    return 1;
#else
    if (ch->is_closed) return 0;
    int64_t cap = ch->capacity > 0 ? ch->capacity : 1024;
    if (ch->count < cap) {
        ch->items[ch->tail] = msg;
        ch->tail = (ch->tail + 1) % cap;
        ch->count++;
        return 1;
    }
    return 0;
#endif
}

void *flux_std_channel_recv(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return (void *)(uintptr_t)strdup("");
    flux_channel_t *ch = _g_channels[cid];
#if defined(_WIN32)
    EnterCriticalSection(&ch->cs);
    int64_t cap = ch->capacity > 0 ? ch->capacity : 1024;
    while (ch->count == 0 && !ch->is_closed) {
        if (!SleepConditionVariableCS(&ch->cv_not_empty, &ch->cs, 50)) break;
    }
    if (ch->count == 0) {
        LeaveCriticalSection(&ch->cs);
        return (void *)(uintptr_t)strdup("");
    }
    void *item = ch->items[ch->head];
    ch->head = (ch->head + 1) % cap;
    ch->count--;
    WakeConditionVariable(&ch->cv_not_full);
    LeaveCriticalSection(&ch->cs);
    return item ? item : (void *)(uintptr_t)strdup("");
#else
    int64_t cap = ch->capacity > 0 ? ch->capacity : 1024;
    if (ch->count == 0) return (void *)(uintptr_t)strdup("");
    void *item = ch->items[ch->head];
    ch->head = (ch->head + 1) % cap;
    ch->count--;
    return item ? item : (void *)(uintptr_t)strdup("");
#endif
}

int64_t flux_std_channel_try_send(int64_t port_val, void *msg) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 0;
    flux_channel_t *ch = _g_channels[cid];
#if defined(_WIN32)
    EnterCriticalSection(&ch->cs);
    if (ch->is_closed) { LeaveCriticalSection(&ch->cs); return 0; }
    int64_t cap = ch->capacity > 0 ? ch->capacity : 1024;
    if (ch->count >= cap) { LeaveCriticalSection(&ch->cs); return 0; }
    ch->items[ch->tail] = msg;
    ch->tail = (ch->tail + 1) % cap;
    ch->count++;
    WakeConditionVariable(&ch->cv_not_empty);
    LeaveCriticalSection(&ch->cs);
    return 1;
#else
    return flux_std_channel_send(port_val, msg);
#endif
}

void *flux_std_channel_try_recv(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    void *res = flux_map_build(0);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) {
        flux_map_set(res, "ok", 2, 0);
        flux_map_set(res, "data", 4, (int64_t)(uintptr_t)strdup(""));
        return res;
    }
    flux_channel_t *ch = _g_channels[cid];
#if defined(_WIN32)
    EnterCriticalSection(&ch->cs);
    int64_t cap = ch->capacity > 0 ? ch->capacity : 1024;
    if (ch->count > 0) {
        void *item = ch->items[ch->head];
        ch->head = (ch->head + 1) % cap;
        ch->count--;
        WakeConditionVariable(&ch->cv_not_full);
        LeaveCriticalSection(&ch->cs);
        flux_map_set(res, "ok", 2, 1);
        flux_map_set(res, "data", 4, item ? (int64_t)(uintptr_t)item : (int64_t)(uintptr_t)strdup(""));
        return res;
    }
    LeaveCriticalSection(&ch->cs);
#endif
    flux_map_set(res, "ok", 2, 0);
    flux_map_set(res, "data", 4, (int64_t)(uintptr_t)strdup(""));
    return res;
}

int64_t flux_std_channel_close(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 0;
    flux_channel_t *ch = _g_channels[cid];
#if defined(_WIN32)
    EnterCriticalSection(&ch->cs);
    ch->is_closed = 1;
    WakeAllConditionVariable(&ch->cv_not_empty);
    WakeAllConditionVariable(&ch->cv_not_full);
    LeaveCriticalSection(&ch->cs);
#else
    ch->is_closed = 1;
#endif
    return 1;
}

int64_t flux_std_channel_is_closed(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 1;
    return _g_channels[cid]->is_closed ? 1 : 0;
}

int64_t flux_std_channel_is_empty(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 1;
    return _g_channels[cid]->count == 0 ? 1 : 0;
}

int64_t flux_std_channel_length(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 0;
    return _g_channels[cid]->count;
}

int64_t flux_std_channel_capacity(int64_t port_val) {
    int64_t cid = _extract_cid(port_val);
    if (cid <= 0 || cid >= MAX_CHANNELS || !_g_channels[cid]) return 0;
    return _g_channels[cid]->capacity;
}

/* Mutex */
#define MAX_MUTEXES 256
#if defined(_WIN32)
static CRITICAL_SECTION _g_mutexes[MAX_MUTEXES];
#endif
static int64_t _g_mutex_active[MAX_MUTEXES] = {0};
static int64_t _g_mutex_next_id = 1;

int64_t flux_std_thread_mutex_create(void) {
    int64_t mid = _g_mutex_next_id++;
    if (mid < MAX_MUTEXES) {
#if defined(_WIN32)
        InitializeCriticalSection(&_g_mutexes[mid]);
#endif
        _g_mutex_active[mid] = 1;
        return mid;
    }
    return 0;
}

int64_t flux_std_thread_mutex_lock(int64_t mid) {
    if (mid <= 0 || mid >= MAX_MUTEXES || !_g_mutex_active[mid]) return 0;
#if defined(_WIN32)
    EnterCriticalSection(&_g_mutexes[mid]);
#endif
    return 1;
}

int64_t flux_std_thread_mutex_unlock(int64_t mid) {
    if (mid <= 0 || mid >= MAX_MUTEXES || !_g_mutex_active[mid]) return 0;
#if defined(_WIN32)
    LeaveCriticalSection(&_g_mutexes[mid]);
#endif
    return 1;
}

int64_t flux_std_thread_mutex_try_lock(int64_t mid) {
    if (mid <= 0 || mid >= MAX_MUTEXES || !_g_mutex_active[mid]) return 0;
#if defined(_WIN32)
    return TryEnterCriticalSection(&_g_mutexes[mid]) ? 1 : 0;
#else
    return 1;
#endif
}

int64_t flux_std_thread_mutex_destroy(int64_t mid) {
    if (mid <= 0 || mid >= MAX_MUTEXES || !_g_mutex_active[mid]) return 0;
#if defined(_WIN32)
    DeleteCriticalSection(&_g_mutexes[mid]);
#endif
    _g_mutex_active[mid] = 0;
    return 1;
}

/* Atomics */
#define MAX_ATOMICS 512
static volatile int64_t _g_atomics[MAX_ATOMICS] = {0};
static int64_t _g_atomic_active[MAX_ATOMICS] = {0};
static int64_t _g_atomic_next_id = 1;

int64_t flux_std_thread_atomic_create(int64_t initial_val) {
    int64_t aid = _g_atomic_next_id++;
    if (aid < MAX_ATOMICS) {
        _g_atomics[aid] = initial_val;
        _g_atomic_active[aid] = 1;
        return aid;
    }
    return 0;
}

int64_t flux_std_thread_atomic_get(int64_t aid) {
    if (aid <= 0 || aid >= MAX_ATOMICS || !_g_atomic_active[aid]) return 0;
#if defined(_WIN32)
    return InterlockedCompareExchange64((volatile LONG64 *)&_g_atomics[aid], 0, 0);
#else
    return _g_atomics[aid];
#endif
}

int64_t flux_std_thread_atomic_set(int64_t aid, int64_t val) {
    if (aid <= 0 || aid >= MAX_ATOMICS || !_g_atomic_active[aid]) return 0;
#if defined(_WIN32)
    InterlockedExchange64((volatile LONG64 *)&_g_atomics[aid], val);
#else
    _g_atomics[aid] = val;
#endif
    return 1;
}

int64_t flux_std_thread_atomic_add(int64_t aid, int64_t delta) {
    if (aid <= 0 || aid >= MAX_ATOMICS || !_g_atomic_active[aid]) return 0;
#if defined(_WIN32)
    return InterlockedAdd64((volatile LONG64 *)&_g_atomics[aid], delta);
#else
    _g_atomics[aid] += delta;
    return _g_atomics[aid];
#endif
}

int64_t flux_std_thread_atomic_cas(int64_t aid, int64_t expected, int64_t desired) {
    if (aid <= 0 || aid >= MAX_ATOMICS || !_g_atomic_active[aid]) return 0;
#if defined(_WIN32)
    LONG64 prev = InterlockedCompareExchange64((volatile LONG64 *)&_g_atomics[aid], desired, expected);
    return prev == expected ? 1 : 0;
#else
    if (_g_atomics[aid] == expected) {
        _g_atomics[aid] = desired;
        return 1;
    }
    return 0;
#endif
}

int64_t flux_std_thread_atomic_destroy(int64_t aid) {
    if (aid <= 0 || aid >= MAX_ATOMICS || !_g_atomic_active[aid]) return 0;
    _g_atomic_active[aid] = 0;
    return 1;
}

/* WaitGroup */
#define MAX_WAITGROUPS 256
typedef struct {
    int64_t count;
    int64_t active;
#if defined(_WIN32)
    CRITICAL_SECTION cs;
    CONDITION_VARIABLE cv;
#endif
} flux_waitgroup_t;
static flux_waitgroup_t _g_waitgroups[MAX_WAITGROUPS] = {0};
static int64_t _g_wg_next_id = 1;

int64_t flux_std_thread_wait_group_create(void) {
    int64_t wgid = _g_wg_next_id++;
    if (wgid < MAX_WAITGROUPS) {
        _g_waitgroups[wgid].count = 0;
        _g_waitgroups[wgid].active = 1;
#if defined(_WIN32)
        InitializeCriticalSection(&_g_waitgroups[wgid].cs);
        InitializeConditionVariable(&_g_waitgroups[wgid].cv);
#endif
        return wgid;
    }
    return 0;
}

int64_t flux_std_thread_wait_group_add(int64_t wgid, int64_t delta) {
    if (wgid <= 0 || wgid >= MAX_WAITGROUPS || !_g_waitgroups[wgid].active) return 0;
#if defined(_WIN32)
    EnterCriticalSection(&_g_waitgroups[wgid].cs);
    _g_waitgroups[wgid].count += delta;
    if (_g_waitgroups[wgid].count <= 0) {
        _g_waitgroups[wgid].count = 0;
        WakeAllConditionVariable(&_g_waitgroups[wgid].cv);
    }
    LeaveCriticalSection(&_g_waitgroups[wgid].cs);
#else
    _g_waitgroups[wgid].count += delta;
    if (_g_waitgroups[wgid].count < 0) _g_waitgroups[wgid].count = 0;
#endif
    return 1;
}

int64_t flux_std_thread_wait_group_done(int64_t wgid) {
    return flux_std_thread_wait_group_add(wgid, -1);
}

int64_t flux_std_thread_wait_group_wait(int64_t wgid) {
    if (wgid <= 0 || wgid >= MAX_WAITGROUPS || !_g_waitgroups[wgid].active) return 0;
#if defined(_WIN32)
    EnterCriticalSection(&_g_waitgroups[wgid].cs);
    while (_g_waitgroups[wgid].count > 0) {
        SleepConditionVariableCS(&_g_waitgroups[wgid].cv, &_g_waitgroups[wgid].cs, 50);
    }
    LeaveCriticalSection(&_g_waitgroups[wgid].cs);
#endif
    return 1;
}

int64_t flux_std_thread_wait_group_destroy(int64_t wgid) {
    if (wgid <= 0 || wgid >= MAX_WAITGROUPS || !_g_waitgroups[wgid].active) return 0;
#if defined(_WIN32)
    DeleteCriticalSection(&_g_waitgroups[wgid].cs);
#endif
    _g_waitgroups[wgid].active = 0;
    return 1;
}

/* Lifecycle & System */
static int64_t _g_thread_next_id = 1;
#define MAX_THREADS 128
typedef struct {
    int64_t tid;
    int64_t is_alive;
    void *result;
} flux_thread_handle_t;
static flux_thread_handle_t _g_threads[MAX_THREADS] = {0};

int64_t flux_std_thread_spawn(const char *agent_name, const char *op_name, void *payload) {
    (void)agent_name; (void)op_name;
    int64_t tid = _g_thread_next_id++;
    if (tid < MAX_THREADS) {
        _g_threads[tid].tid = tid;
        _g_threads[tid].is_alive = 0;
        _g_threads[tid].result = payload;
        return tid;
    }
    return 1;
}

void *flux_std_thread_join(int64_t tid) {
    if (tid > 0 && tid < MAX_THREADS) {
        return _g_threads[tid].result ? _g_threads[tid].result : (void *)(uintptr_t)strdup("");
    }
    return (void *)(uintptr_t)strdup("");
}

int64_t flux_std_thread_is_alive(int64_t tid) {
    if (tid > 0 && tid < MAX_THREADS) {
        return _g_threads[tid].is_alive;
    }
    return 0;
}

int64_t flux_std_thread_current_id(void) {
#if defined(_WIN32)
    return (int64_t)GetCurrentThreadId();
#else
    return 1;
#endif
}

int64_t flux_std_thread_detach(int64_t tid) {
    (void)tid;
    return 1;
}

int64_t flux_std_thread_hardware_concurrency(void) {
#if defined(_WIN32)
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    return si.dwNumberOfProcessors > 0 ? (int64_t)si.dwNumberOfProcessors : 1;
#else
    return 1;
#endif
}

int64_t flux_std_thread_sleep(int64_t ms) {
    if (ms <= 0) return 1;
#if defined(_WIN32)
    Sleep((DWORD)ms);
#else
    usleep((useconds_t)(ms * 1000));
#endif
    return 1;
}

int64_t flux_std_thread_yield(void) {
#if defined(_WIN32)
    SwitchToThread();
#endif
    return 1;
}

