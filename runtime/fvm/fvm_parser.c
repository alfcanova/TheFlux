/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Implementação: runtime/fvm/fvm_parser.c
 * ============================================================================== */

#include "fvm_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static const struct {
    const char *name;
    FvmOpcode op;
} OPCODE_MAP[] = {
    {"HALT", OP_HALT},
    {"PUSH", OP_PUSH},
    {"LOAD", OP_LOAD},
    {"STORE", OP_STORE},
    {"MAKE_REF", OP_MAKE_REF},
    {"DECLARE", OP_DECLARE},
    {"ADD", OP_ADD},
    {"SUB", OP_SUB},
    {"MUL", OP_MUL},
    {"DIV", OP_DIV},
    {"IDIV", OP_IDIV},
    {"REM", OP_REM},
    {"POW_E", OP_POW_E},
    {"POW_R", OP_POW_R},
    {"NEG", OP_NEG},
    {"NOT", OP_NOT},
    {"DUP", OP_DUP},
    {"POP", OP_POP},
    {"EQ", OP_EQ},
    {"NE", OP_NE},
    {"LT", OP_LT},
    {"LE", OP_LE},
    {"GT", OP_GT},
    {"GE", OP_GE},
    {"AND", OP_AND},
    {"OR", OP_OR},
    {"BAND", OP_BAND},
    {"BOR", OP_BOR},
    {"BXOR", OP_BXOR},
    {"BSHL", OP_BSHL},
    {"BSHR", OP_BSHR},
    {"BSHRU", OP_BSHRU},
    {"BNOT", OP_BNOT},
    {"PRINT", OP_PRINT},
    {"PRINTLN", OP_PRINTLN},
    {"INPUT", OP_INPUT},
    {"JMP", OP_JMP},
    {"JZ", OP_JZ},
    {"JNZ", OP_JNZ},
    {"CALL", OP_CALL},
    {"RET", OP_RET},
    {"SCOPE_ENTER", OP_SCOPE_ENTER},
    {"SCOPE_EXIT", OP_SCOPE_EXIT},
    {"EMIT", OP_EMIT},
    {"FAIL", OP_FAIL},
    {"IS_FAIL", OP_IS_FAIL},
    {"MAKE_STRUCT", OP_MAKE_STRUCT},
    {"FIELD_ACCESS", OP_FIELD_ACCESS},
    {"FIELD_SET", OP_FIELD_SET},
    {"TO_STRING", OP_TO_STRING},
    {"JUMP_IF_NOT_MATCH", OP_JUMP_IF_NOT_MATCH},
    {"JUMP_IF_NOT_MATCH_DROP", OP_JUMP_IF_NOT_MATCH_DROP},
    {"MATCH_BIND", OP_MATCH_BIND},
    {"MATCH_FAIL", OP_MATCH_FAIL},
    {"ENUM_NEW", OP_ENUM_NEW},
    {"ENUM_TAG", OP_ENUM_TAG},
    {"ENUM_FIELD", OP_ENUM_FIELD},
    {"STRUCT_MATCH", OP_STRUCT_MATCH},
    {"FIELD_GET", OP_FIELD_GET},
    {"ROUND", OP_ROUND},
    {"ROUND_COMPLEX", OP_ROUND_COMPLEX},
    {"INDEX", OP_INDEX},
    {"INDEX_ASSIGN", OP_INDEX_ASSIGN},
    {"TGET", OP_TGET},
    {"TSET", OP_TSET},
    {"TENSOR_PACK", OP_TENSOR_PACK},
    {"TSLICE", OP_TSLICE},
    {"TMAT", OP_TMAT},
    {"SLICE", OP_SLICE},
    {"IN", OP_IN},
    {"MAKE_LIST", OP_MAKE_LIST},
    {"MAKE_SET", OP_MAKE_SET},
    {"MAKE_MAP", OP_MAKE_MAP},
    {"MAKE_RECORD", OP_MAKE_RECORD},
    {"RECORD_MATCH", OP_RECORD_MATCH},
    {"RECORD_FIELD", OP_RECORD_FIELD},
    {"LIST_MATCH", OP_LIST_MATCH},
    {"LIST_ITEM", OP_LIST_ITEM},
    {"LIST_REST", OP_LIST_REST},
    {"SPLIT", OP_SPLIT},
    {"JOIN", OP_JOIN},
    {"CAST", OP_CAST},
    {"ITER_NEW", OP_ITER_NEW},
    {"ITER_NEXT", OP_ITER_NEXT},
    {"UNWRAP_NICE", OP_UNWRAP_NICE},
    {"SPY", OP_SPY},
    {NULL, OP_HALT}
};

FvmOpcode fvm_opcode_from_str(const char *name) {
    if (!name) return OP_HALT;
    for (int i = 0; OPCODE_MAP[i].name != NULL; i++) {
        if (strcmp(OPCODE_MAP[i].name, name) == 0) {
            return OPCODE_MAP[i].op;
        }
    }
    return OP_HALT;
}

const char *fvm_opcode_name(FvmOpcode op) {
    for (int i = 0; OPCODE_MAP[i].name != NULL; i++) {
        if (OPCODE_MAP[i].op == op) {
            return OPCODE_MAP[i].name;
        }
    }
    return "UNKNOWN";
}

/* ==============================================================================
 * Fast Streaming JSON Parser
 * ============================================================================== */

static const char *skip_ws(const char *p) {
    while (*p && (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n')) p++;
    return p;
}

static char *parse_json_string(const char **src, FvmArena *arena) {
    const char *p = *src;
    if (*p != '"') return NULL;
    p++;
    const char *start = p;
    size_t len = 0;
    while (*p && *p != '"') {
        if (*p == '\\' && *(p + 1)) {
            p += 2;
            len++;
        } else {
            p++;
            len++;
        }
    }
    char *out = (char *)fvm_arena_alloc(arena, len + 1);
    const char *r = start;
    char *w = out;
    while (r < p) {
        if (*r == '\\') {
            r++;
            if (*r == 'n') *w++ = '\n';
            else if (*r == 'r') *w++ = '\r';
            else if (*r == 't') *w++ = '\t';
            else if (*r == '"') *w++ = '"';
            else if (*r == '\\') *w++ = '\\';
            else *w++ = *r;
            r++;
        } else {
            *w++ = *r++;
        }
    }
    *w = '\0';
    if (*p == '"') p++;
    *src = p;
    return out;
}

static FluxVal parse_json_value(const char **src, FvmArena *arena) {
    const char *p = skip_ws(*src);
    if (*p == '"') {
        char *str = parse_json_string(&p, arena);
        *src = p;
        return fvm_val_str(arena, str);
    }
    if (strncmp(p, "true", 4) == 0) {
        *src = p + 4;
        return fvm_val_bool(true);
    }
    if (strncmp(p, "false", 5) == 0) {
        *src = p + 5;
        return fvm_val_bool(false);
    }
    if (strncmp(p, "null", 4) == 0) {
        *src = p + 4;
        return fvm_val_nil();
    }
    if (*p == '-' || (*p >= '0' && *p <= '9')) {
        char *end = NULL;
        /* Testa se é ponto flutuante */
        const char *t = p;
        bool is_float = false;
        if (*t == '-') t++;
        while (*t >= '0' && *t <= '9') t++;
        if (*t == '.' || *t == 'e' || *t == 'E') is_float = true;

        if (is_float) {
            double d = strtod(p, &end);
            *src = end;
            return fvm_val_float(d);
        } else {
            long long ll = strtoll(p, &end, 10);
            *src = end;
            return fvm_val_int((int64_t)ll);
        }
    }
    if (*p == '[') {
        p++;
        p = skip_ws(p);
        /* Checa se é array especial: ["#c", r, i] ou ["#dt", nanos] ou lista */
        if (*p == ']') {
            *src = p + 1;
            return fvm_val_list(arena, 0);
        }
        if (*p == '"') {
            const char *look = p;
            char *tag = parse_json_string(&look, arena);
            if (tag && strcmp(tag, "#c") == 0) {
                p = skip_ws(look);
                if (*p == ',') p++;
                FluxVal r = parse_json_value(&p, arena);
                p = skip_ws(p);
                if (*p == ',') p++;
                FluxVal i = parse_json_value(&p, arena);
                p = skip_ws(p);
                if (*p == ']') p++;
                *src = p;
                return fvm_val_complex(arena, r.type == VAL_FLOAT ? r.as.f64 : (double)r.as.i64,
                                              i.type == VAL_FLOAT ? i.as.f64 : (double)i.as.i64);
            }
            if (tag && strcmp(tag, "#dt") == 0) {
                p = skip_ws(look);
                if (*p == ',') p++;
                FluxVal nanos = parse_json_value(&p, arena);
                p = skip_ws(p);
                if (*p == ']') p++;
                *src = p;
                return fvm_val_datetime(nanos.as.i64);
            }
        }

        /* Lista normal de strings ou valores */
        FluxVal lst_val = fvm_val_list(arena, 8);
        FvmList *lst = (FvmList *)lst_val.as.ptr;
        while (*p && *p != ']') {
            FluxVal item = parse_json_value(&p, arena);
            if (lst->count >= lst->capacity) {
                lst->capacity *= 2;
                FluxVal *nitems = (FluxVal *)fvm_arena_alloc(arena, sizeof(FluxVal) * lst->capacity);
                memcpy(nitems, lst->items, sizeof(FluxVal) * lst->count);
                lst->items = nitems;
            }
            lst->items[lst->count++] = item;
            p = skip_ws(p);
            if (*p == ',') p++;
            p = skip_ws(p);
        }
        if (*p == ']') p++;
        *src = p;
        return lst_val;
    }

    *src = p;
    return fvm_val_nil();
}

int fvm_program_load_json(FvmProgram *prog, FvmArena *arena, const char *json_text) {
    if (!prog || !json_text) return 1;

    prog->capacity = 256;
    prog->count = 0;
    prog->instrs = (FvmInstr *)fvm_arena_alloc(arena, sizeof(FvmInstr) * prog->capacity);

    const char *p = skip_ws(json_text);

    /* Suporta {"ops": [...]} */
    if (*p == '{') {
        const char *ops_pos = strstr(p, "\"ops\"");
        if (ops_pos) {
            p = strchr(ops_pos, '[');
        } else {
            const char *inst_pos = strstr(p, "\"instructions\"");
            if (inst_pos) p = strchr(inst_pos, '[');
        }
    }

    if (!p || *p != '[') return 1;
    p++; /* consome '[' */

    while (*p) {
        p = skip_ws(p);
        if (*p == ']') break;
        if (*p == ',') { p++; continue; }

        if (*p != '[') { p++; continue; }
        p++; /* consome '[' da instrução */

        p = skip_ws(p);
        char *op_name = parse_json_string(&p, arena);
        if (!op_name) break;

        FvmOpcode opcode = fvm_opcode_from_str(op_name);

        FvmInstr inst;
        memset(&inst, 0, sizeof(FvmInstr));
        inst.opcode = (uint8_t)opcode;

        /* Lê argumentos */
        int arg_idx = 0;
        char *str_args[8] = {0};
        FluxVal val_args[8];

        while (*p) {
            p = skip_ws(p);
            if (*p == ']') { p++; break; }
            if (*p == ',') { p++; continue; }

            if (*p == '[') {
                /* Array de campos / strings */
                const char *arr_p = p + 1;
                char **fields = (char **)fvm_arena_alloc(arena, sizeof(char *) * 32);
                int field_count = 0;
                while (*arr_p) {
                    arr_p = skip_ws(arr_p);
                    if (*arr_p == ']') { arr_p++; break; }
                    if (*arr_p == ',') { arr_p++; continue; }
                    char *fn = parse_json_string(&arr_p, arena);
                    if (fn && field_count < 32) {
                        fields[field_count++] = fn;
                    }
                }
                inst.field_names = fields;
                inst.field_count = field_count;
                p = arr_p;
                continue;
            }

            FluxVal v = parse_json_value(&p, arena);
            if (arg_idx < 8) {
                val_args[arg_idx] = v;
                if (v.type == VAL_STRING) {
                    FvmString *s = (FvmString *)v.as.ptr;
                    str_args[arg_idx] = s ? s->chars : "";
                }
                arg_idx++;
            }
        }

        /* Configura instrução de acordo com o opcode */
        switch (opcode) {
            case OP_PUSH:
                inst.imm_val = (arg_idx > 0) ? val_args[0] : fvm_val_nil();
                break;
            case OP_LOAD:
            case OP_STORE:
            case OP_MAKE_REF:
            case OP_FIELD_ACCESS:
            case OP_FIELD_SET:
            case OP_MATCH_BIND:
            case OP_ENUM_FIELD:
            case OP_FIELD_GET:
            case OP_RECORD_FIELD:
                inst.imm_str = (arg_idx > 0) ? str_args[0] : "";
                break;
            case OP_DECLARE:
                inst.imm_str = (arg_idx > 0) ? str_args[0] : "";
                if (arg_idx > 1) inst.aux = (uint8_t)arg_idx;
                break;
            case OP_JMP:
            case OP_JZ:
            case OP_JNZ:
            case OP_JUMP_IF_NOT_MATCH:
                inst.imm_int = (arg_idx > 0 && val_args[0].type == VAL_INT) ? (int32_t)val_args[0].as.i64 : 0;
                break;
            case OP_JUMP_IF_NOT_MATCH_DROP:
                if (arg_idx > 1 && val_args[1].type == VAL_INT) {
                    inst.aux = (uint8_t)val_args[0].as.i64;
                    inst.imm_int = (int32_t)val_args[1].as.i64;
                } else if (arg_idx > 0 && val_args[0].type == VAL_INT) {
                    inst.imm_int = (int32_t)val_args[0].as.i64;
                }
                break;
            case OP_PRINT:
            case OP_PRINTLN:
                inst.imm_int = (arg_idx > 0 && val_args[0].type == VAL_INT) ? (int32_t)val_args[0].as.i64 : 1;
                break;
            case OP_CALL:
                if (arg_idx > 0 && val_args[0].type == VAL_INT) {
                    inst.imm_int = (int32_t)val_args[0].as.i64;
                    inst.aux = 1; /* Chamada por índice */
                } else if (arg_idx > 0 && str_args[0]) {
                    inst.imm_str = str_args[0];
                    inst.aux = 0; /* Chamada por nome */
                }
                break;
            case OP_ENUM_NEW:
                /* ENUM_NEW "Nome" "Variante" tag [campos] */
                if (arg_idx > 0) inst.imm_str = str_args[0];
                if (arg_idx > 1) inst.imm_val = fvm_val_str(arena, str_args[1]);
                if (arg_idx > 2 && val_args[2].type == VAL_INT) inst.imm_int = (int32_t)val_args[2].as.i64;
                break;
            case OP_MAKE_STRUCT:
                if (arg_idx > 0) inst.imm_str = str_args[0];
                break;
            case OP_EMIT:
                inst.imm_str = (arg_idx > 0) ? str_args[0] : "nice";
                break;
            default:
                if (arg_idx > 0 && val_args[0].type == VAL_INT) {
                    inst.imm_int = (int32_t)val_args[0].as.i64;
                }
                if (arg_idx > 0 && str_args[0]) {
                    inst.imm_str = str_args[0];
                }
                break;
        }

        if (prog->count >= prog->capacity) {
            size_t ncap = prog->capacity * 2;
            FvmInstr *ninstrs = (FvmInstr *)fvm_arena_alloc(arena, sizeof(FvmInstr) * ncap);
            memcpy(ninstrs, prog->instrs, sizeof(FvmInstr) * prog->count);
            prog->instrs = ninstrs;
            prog->capacity = ncap;
        }

        prog->instrs[prog->count++] = inst;
    }

    return 0;
}

int fvm_program_load_file(FvmProgram *prog, FvmArena *arena, const char *filepath) {
    if (!prog || !filepath) return 1;
    FILE *f = fopen(filepath, "rb");
    if (!f) return 1;

    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (sz <= 0) {
        fclose(f);
        return 1;
    }

    char *buf = (char *)malloc(sz + 1);
    if (!buf) {
        fclose(f);
        return 1;
    }

    size_t rd = fread(buf, 1, sz, f);
    buf[rd] = '\0';
    fclose(f);

    int res = fvm_program_load_json(prog, arena, buf);
    free(buf);
    return res;
}
