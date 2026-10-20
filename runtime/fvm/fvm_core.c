/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Implementação: runtime/fvm/fvm_core.c
 * ============================================================================== */

#include "fvm_core.h"
#include "fvm_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void fvm_state_init(FvmState *vm, const char *stdin_text, FILE *out_stream) {
    memset(vm, 0, sizeof(FvmState));
    vm->stack_capacity = FVM_STACK_CAPACITY;
    vm->stack = (FluxVal *)malloc(sizeof(FluxVal) * vm->stack_capacity);
    vm->sp = vm->stack;

    vm->call_stack_capacity = FVM_CALL_STACK_CAPACITY;
    vm->call_stack = (FvmCallFrame *)malloc(sizeof(FvmCallFrame) * vm->call_stack_capacity);
    vm->csp = 0;

    vm->stdin_cursor = stdin_text ? stdin_text : "";
    vm->out_stream = out_stream;
    vm->max_instructions = 100000000ULL; /* 100M ops safeguard */
    fvm_arena_init(&vm->arena, 64 * 1024);

    /* Cria escopo global */
    vm->scope = (FvmScope *)fvm_arena_alloc(&vm->arena, sizeof(FvmScope));
    memset(vm->scope, 0, sizeof(FvmScope));
}

void fvm_state_cleanup(FvmState *vm) {
    fvm_arena_free_all(&vm->arena);
    if (vm->stack) { free(vm->stack); vm->stack = NULL; }
    if (vm->call_stack) { free(vm->call_stack); vm->call_stack = NULL; }
    if (vm->out_buffer) { free(vm->out_buffer); vm->out_buffer = NULL; }
    if (vm->err_buffer) { free(vm->err_buffer); vm->err_buffer = NULL; }
}

static inline void push(FvmState *vm, FluxVal val) {
    if (vm->sp < vm->stack + vm->stack_capacity) {
        *vm->sp++ = val;
    }
}

static inline FluxVal pop(FvmState *vm) {
    if (vm->sp > vm->stack) {
        return *(--vm->sp);
    }
    return fvm_val_nil();
}

static inline FluxVal peek(FvmState *vm) {
    if (vm->sp > vm->stack) {
        return *(vm->sp - 1);
    }
    return fvm_val_nil();
}

static void scope_declare(FvmState *vm, const char *name, FluxVal val) {
    if (!name || !vm->scope) return;
    for (uint32_t i = 0; i < vm->scope->var_count; i++) {
        if (strcmp(vm->scope->names[i], name) == 0) {
            vm->scope->values[i] = val;
            return;
        }
    }
    if (vm->scope->var_count < FVM_MAX_SCOPE_VARS) {
        vm->scope->names[vm->scope->var_count] = fvm_arena_strdup(&vm->arena, name);
        vm->scope->values[vm->scope->var_count] = val;
        vm->scope->var_count++;
    }
}

static void scope_store(FvmState *vm, const char *name, FluxVal val) {
    if (!name) return;
    for (FvmScope *s = vm->scope; s != NULL; s = s->parent) {
        for (uint32_t i = 0; i < s->var_count; i++) {
            if (strcmp(s->names[i], name) == 0) {
                s->values[i] = val;
                return;
            }
        }
    }
    scope_declare(vm, name, val);
}

static FluxVal scope_load(FvmState *vm, const char *name) {
    if (!name) return fvm_val_nil();
    for (FvmScope *s = vm->scope; s != NULL; s = s->parent) {
        for (uint32_t i = 0; i < s->var_count; i++) {
            if (strcmp(s->names[i], name) == 0) {
                return s->values[i];
            }
        }
    }
    return fvm_val_nil();
}

/* ==============================================================================
 * Motor Principal de Execução com Direct Threaded Code
 * ============================================================================== */

int fvm_execute_program(FvmState *vm, const FvmProgram *prog) {
    if (!vm || !prog || prog->count == 0) return 0;

    vm->ip = 0;
    size_t count = prog->count;
    const FvmInstr *instrs = prog->instrs;

    while (vm->ip < count) {
        if (++vm->instruction_count > vm->max_instructions) {
            if (vm->out_stream) fprintf(vm->out_stream, "Error: Instruction limit exceeded.\n");
            return 1;
        }

        const FvmInstr *inst = &instrs[vm->ip++];

        switch (inst->opcode) {
            case OP_HALT:
                return vm->exit_code;

            case OP_PUSH:
                push(vm, inst->imm_val);
                break;

            case OP_POP:
                pop(vm);
                break;

            case OP_DUP:
                push(vm, peek(vm));
                break;

            case OP_DECLARE: {
                FluxVal val = pop(vm);
                scope_declare(vm, inst->imm_str, val);
                break;
            }

            case OP_STORE: {
                FluxVal val = pop(vm);
                scope_store(vm, inst->imm_str, val);
                break;
            }

            case OP_LOAD: {
                FluxVal val = scope_load(vm, inst->imm_str);
                push(vm, val);
                break;
            }

            case OP_MAKE_REF: {
                FluxVal v = fvm_val_nil();
                v.type = VAL_REF;
                v.as.ptr = (void *)inst->imm_str;
                push(vm, v);
                break;
            }

            case OP_SCOPE_ENTER: {
                FvmScope *ns = (FvmScope *)fvm_arena_alloc(&vm->arena, sizeof(FvmScope));
                memset(ns, 0, sizeof(FvmScope));
                ns->parent = vm->scope;
                vm->scope = ns;
                break;
            }

            case OP_SCOPE_EXIT: {
                if (vm->scope && vm->scope->parent) {
                    vm->scope = vm->scope->parent;
                }
                break;
            }

            case OP_ADD: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_STRING || b.type == VAL_STRING || a.type == VAL_ENUM || b.type == VAL_ENUM || a.type == VAL_STRUCT || b.type == VAL_STRUCT || a.type == VAL_LIST || b.type == VAL_LIST) {
                    char *sa = fvm_val_to_str(&vm->arena, a);
                    char *sb = fvm_val_to_str(&vm->arena, b);
                    size_t la = strlen(sa);
                    size_t lb = strlen(sb);
                    char *cat = (char *)fvm_arena_alloc(&vm->arena, la + lb + 1);
                    memcpy(cat, sa, la);
                    memcpy(cat + la, sb, lb);
                    cat[la + lb] = '\0';
                    push(vm, fvm_val_str(&vm->arena, cat));
                } else if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_float(da + db));
                } else {
                    push(vm, fvm_val_int(a.as.i64 + b.as.i64));
                }
                break;
            }

            case OP_SUB: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_float(da - db));
                } else {
                    push(vm, fvm_val_int(a.as.i64 - b.as.i64));
                }
                break;
            }

            case OP_MUL: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_float(da * db));
                } else {
                    push(vm, fvm_val_int(a.as.i64 * b.as.i64));
                }
                break;
            }

            case OP_DIV: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                if (db == 0.0) {
                    push(vm, fvm_val_status(&vm->arena, "fail", fvm_val_float(0.0), "divisao por zero"));
                } else {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    push(vm, fvm_val_float(da / db));
                }
                break;
            }

            case OP_IDIV: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (b.as.i64 == 0) {
                    push(vm, fvm_val_status(&vm->arena, "fail", fvm_val_int(0), "divisao por zero"));
                } else {
                    push(vm, fvm_val_int(a.as.i64 / b.as.i64));
                }
                break;
            }

            case OP_REM: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (b.as.i64 == 0) {
                    push(vm, fvm_val_status(&vm->arena, "fail", fvm_val_int(0), "divisao por zero"));
                } else {
                    int64_t r = a.as.i64 % b.as.i64;
                    if (r < 0) r += llabs(b.as.i64);
                    push(vm, fvm_val_int(r));
                }
                break;
            }

            case OP_NEG: {
                FluxVal v = fvm_unwrap(pop(vm));
                if (v.type == VAL_FLOAT) push(vm, fvm_val_float(-v.as.f64));
                else push(vm, fvm_val_int(-v.as.i64));
                break;
            }

            case OP_NOT: {
                FluxVal v = pop(vm);
                push(vm, fvm_val_bool(!fvm_val_is_truthy(v)));
                break;
            }

            case OP_EQ: {
                FluxVal b = pop(vm);
                FluxVal a = pop(vm);
                push(vm, fvm_val_bool(fvm_val_equal(a, b)));
                break;
            }

            case OP_NE: {
                FluxVal b = pop(vm);
                FluxVal a = pop(vm);
                push(vm, fvm_val_bool(!fvm_val_equal(a, b)));
                break;
            }

            case OP_LT: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_bool(da < db));
                } else {
                    push(vm, fvm_val_bool(a.as.i64 < b.as.i64));
                }
                break;
            }

            case OP_LE: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_bool(da <= db));
                } else {
                    push(vm, fvm_val_bool(a.as.i64 <= b.as.i64));
                }
                break;
            }

            case OP_GT: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_bool(da > db));
                } else {
                    push(vm, fvm_val_bool(a.as.i64 > b.as.i64));
                }
                break;
            }

            case OP_GE: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                if (a.type == VAL_FLOAT || b.type == VAL_FLOAT) {
                    double da = (a.type == VAL_FLOAT) ? a.as.f64 : (double)a.as.i64;
                    double db = (b.type == VAL_FLOAT) ? b.as.f64 : (double)b.as.i64;
                    push(vm, fvm_val_bool(da >= db));
                } else {
                    push(vm, fvm_val_bool(a.as.i64 >= b.as.i64));
                }
                break;
            }

            case OP_AND: {
                FluxVal b = pop(vm);
                FluxVal a = pop(vm);
                push(vm, fvm_val_bool(fvm_val_is_truthy(a) && fvm_val_is_truthy(b)));
                break;
            }

            case OP_OR: {
                FluxVal b = pop(vm);
                FluxVal a = pop(vm);
                push(vm, fvm_val_bool(fvm_val_is_truthy(a) || fvm_val_is_truthy(b)));
                break;
            }

            case OP_BAND: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                push(vm, fvm_val_int(a.as.i64 & b.as.i64));
                break;
            }

            case OP_BOR: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                push(vm, fvm_val_int(a.as.i64 | b.as.i64));
                break;
            }

            case OP_BXOR: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                push(vm, fvm_val_int(a.as.i64 ^ b.as.i64));
                break;
            }

            case OP_BSHL: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                push(vm, fvm_val_int(a.as.i64 << b.as.i64));
                break;
            }

            case OP_BSHR: {
                FluxVal b = fvm_unwrap(pop(vm));
                FluxVal a = fvm_unwrap(pop(vm));
                push(vm, fvm_val_int(a.as.i64 >> b.as.i64));
                break;
            }

            case OP_BNOT: {
                FluxVal a = fvm_unwrap(pop(vm));
                push(vm, fvm_val_int(~a.as.i64));
                break;
            }

            case OP_JMP:
                vm->ip = (size_t)inst->imm_int;
                break;

            case OP_JZ: {
                FluxVal v = pop(vm);
                if (!fvm_val_is_truthy(v)) {
                    vm->ip = (size_t)inst->imm_int;
                }
                break;
            }

            case OP_JNZ: {
                FluxVal v = pop(vm);
                if (fvm_val_is_truthy(v)) {
                    vm->ip = (size_t)inst->imm_int;
                }
                break;
            }

            case OP_JUMP_IF_NOT_MATCH: {
                FluxVal v = pop(vm);
                if (!fvm_val_is_truthy(v)) {
                    vm->ip = (size_t)inst->imm_int;
                }
                break;
            }

            case OP_JUMP_IF_NOT_MATCH_DROP: {
                FluxVal val = pop(vm);
                if (!fvm_val_is_truthy(val)) {
                    int depth = inst->aux;
                    for (int d = 0; d < depth; d++) pop(vm);
                    vm->ip = (size_t)inst->imm_int;
                }
                break;
            }

            case OP_MATCH_BIND: {
                FluxVal val = pop(vm);
                scope_declare(vm, inst->imm_str, val);
                break;
            }

            case OP_CALL: {
                if (inst->aux == 1) {
                    /* Chamada interna de função */
                    if (vm->csp < vm->call_stack_capacity) {
                        vm->call_stack[vm->csp].ret_ip = vm->ip;
                        vm->call_stack[vm->csp].scope = vm->scope;
                        vm->call_stack[vm->csp].sp_base = (size_t)(vm->sp - vm->stack);
                        vm->csp++;
                        vm->ip = (size_t)inst->imm_int;
                    }
                } else if (inst->imm_str) {
                    /* Builtin Call */
                    if (strcmp(inst->imm_str, "print") == 0) {
                        FluxVal v = pop(vm);
                        fvm_val_print(v, false, vm->out_stream, &vm->out_buffer, &vm->out_len, &vm->out_cap);
                    } else if (strcmp(inst->imm_str, "println") == 0) {
                        FluxVal v = pop(vm);
                        fvm_val_print(v, true, vm->out_stream, &vm->out_buffer, &vm->out_len, &vm->out_cap);
                    } else {
                        /* Retorna sucesso / dummy para builtins não críticos */
                        push(vm, fvm_val_nil());
                    }
                }
                break;
            }

            case OP_RET: {
                if (vm->csp > 0) {
                    vm->csp--;
                    vm->ip = vm->call_stack[vm->csp].ret_ip;
                    vm->scope = vm->call_stack[vm->csp].scope;
                }
                break;
            }

            case OP_PRINT:
            case OP_PRINTLN: {
                int count_vals = inst->imm_int > 0 ? inst->imm_int : 1;
                FluxVal tmp[16];
                if (count_vals > 16) count_vals = 16;
                for (int i = 0; i < count_vals; i++) {
                    tmp[i] = pop(vm);
                }
                for (int i = count_vals - 1; i >= 0; i--) {
                    bool nl = (inst->opcode == OP_PRINTLN && i == 0);
                    fvm_val_print(tmp[i], nl, vm->out_stream, &vm->out_buffer, &vm->out_len, &vm->out_cap);
                }
                break;
            }

            case OP_INPUT: {
                /* Leitura de linha com salvaguarda estrita contra loops infinitos de EOF */
                char line_buf[256] = {0};
                if (vm->stdin_cursor && *vm->stdin_cursor) {
                    const char *nl = strchr(vm->stdin_cursor, '\n');
                    if (nl) {
                        size_t llen = (size_t)(nl - vm->stdin_cursor);
                        if (llen >= sizeof(line_buf)) llen = sizeof(line_buf) - 1;
                        memcpy(line_buf, vm->stdin_cursor, llen);
                        line_buf[llen] = '\0';
                        vm->stdin_cursor = nl + 1;
                    } else {
                        strncpy(line_buf, vm->stdin_cursor, sizeof(line_buf) - 1);
                        vm->stdin_cursor += strlen(vm->stdin_cursor);
                    }
                }
                /* Remove carriage return */
                size_t ln = strlen(line_buf);
                if (ln > 0 && line_buf[ln - 1] == '\r') line_buf[ln - 1] = '\0';

                push(vm, fvm_val_str(&vm->arena, line_buf));
                break;
            }

            case OP_ENUM_NEW: {
                /* inst->imm_str = type_name, inst->imm_val = variant_str, inst->imm_int = tag */
                const char *type_name = inst->imm_str ? inst->imm_str : "Enum";
                const char *variant = (inst->imm_val.type == VAL_STRING && inst->imm_val.as.ptr) ?
                                      ((FvmString *)inst->imm_val.as.ptr)->chars : "Variant";
                int32_t tag = inst->imm_int;
                int32_t nfields = inst->field_count;

                FluxVal ev = fvm_val_enum(&vm->arena, type_name, variant, tag, nfields);
                FvmEnum *e = (FvmEnum *)ev.as.ptr;
                for (int i = nfields - 1; i >= 0; i--) {
                    e->fields[i].name = inst->field_names[i];
                    e->fields[i].val = pop(vm);
                }
                push(vm, ev);
                break;
            }

            case OP_ENUM_TAG: {
                FluxVal v = fvm_unwrap(pop(vm));
                if (v.type == VAL_ENUM && v.as.ptr) {
                    FvmEnum *e = (FvmEnum *)v.as.ptr;
                    push(vm, fvm_val_int(e->tag));
                } else {
                    push(vm, fvm_val_int(0));
                }
                break;
            }

            case OP_ENUM_FIELD: {
                FluxVal v = fvm_unwrap(pop(vm));
                FluxVal found = fvm_val_nil();
                if (v.type == VAL_ENUM && v.as.ptr && inst->imm_str) {
                    FvmEnum *e = (FvmEnum *)v.as.ptr;
                    for (uint32_t i = 0; i < e->field_count; i++) {
                        if (e->fields[i].name && strcmp(e->fields[i].name, inst->imm_str) == 0) {
                            found = e->fields[i].val;
                            break;
                        }
                    }
                }
                push(vm, found);
                break;
            }

            case OP_MAKE_STRUCT: {
                const char *tname = inst->imm_str ? inst->imm_str : "struct";
                int32_t nfields = inst->field_count;
                FluxVal sv = fvm_val_struct(&vm->arena, tname, nfields);
                FvmStruct *s = (FvmStruct *)sv.as.ptr;
                for (int i = nfields - 1; i >= 0; i--) {
                    s->fields[i].name = inst->field_names[i];
                    s->fields[i].val = pop(vm);
                }
                push(vm, sv);
                break;
            }

            case OP_FIELD_ACCESS:
            case OP_FIELD_GET: {
                FluxVal v = fvm_unwrap(pop(vm));
                FluxVal found = fvm_val_nil();
                if (v.type == VAL_STRUCT && v.as.ptr && inst->imm_str) {
                    FvmStruct *s = (FvmStruct *)v.as.ptr;
                    for (uint32_t i = 0; i < s->field_count; i++) {
                        if (s->fields[i].name && strcmp(s->fields[i].name, inst->imm_str) == 0) {
                            found = s->fields[i].val;
                            break;
                        }
                    }
                }
                push(vm, found);
                break;
            }

            case OP_EMIT: {
                FluxVal msg = pop(vm);
                FluxVal val = fvm_unwrap(pop(vm));
                char *smsg = fvm_val_to_str(&vm->arena, msg);
                const char *sta = inst->imm_str ? inst->imm_str : "nice";
                push(vm, fvm_val_status(&vm->arena, sta, val, smsg));
                break;
            }

            case OP_IS_FAIL: {
                FluxVal v = pop(vm);
                bool is_fail = false;
                if (v.type == VAL_STATUS && v.as.ptr) {
                    FvmStatus *st = (FvmStatus *)v.as.ptr;
                    if (st->status && strcmp(st->status, "fail") == 0) is_fail = true;
                } else if (v.type == VAL_BOOL) {
                    is_fail = (v.as.i64 == 0);
                }
                push(vm, fvm_val_bool(is_fail));
                break;
            }

            case OP_TO_STRING: {
                FluxVal v = pop(vm);
                char *s = fvm_val_to_str(&vm->arena, v);
                push(vm, fvm_val_str(&vm->arena, s));
                break;
            }

            case OP_UNWRAP_NICE: {
                FluxVal v = pop(vm);
                push(vm, fvm_unwrap(v));
                break;
            }

            case OP_MAKE_LIST: {
                int count_items = inst->imm_int;
                FluxVal lv = fvm_val_list(&vm->arena, count_items > 0 ? count_items : 4);
                FvmList *lst = (FvmList *)lv.as.ptr;
                lst->count = count_items;
                for (int i = count_items - 1; i >= 0; i--) {
                    lst->items[i] = pop(vm);
                }
                push(vm, lv);
                break;
            }

            default:
                break;
        }
    }

    return vm->exit_code;
}

int fvm_execute_json_buffer(
    const char *bytecode_json,
    const char *stdin_text,
    char **out_stdout,
    size_t *out_stdout_len,
    char **out_stderr,
    size_t *out_stderr_len
) {
    if (!bytecode_json) return 1;

    FvmState vm;
    fvm_state_init(&vm, stdin_text, NULL);

    FvmProgram prog;
    if (fvm_program_load_json(&prog, &vm.arena, bytecode_json) != 0) {
        if (out_stderr) {
            *out_stderr = strdup("FVM Error: Falha ao carregar JSON de bytecode.\n");
            if (out_stderr_len) *out_stderr_len = strlen(*out_stderr);
        }
        fvm_state_cleanup(&vm);
        return 1;
    }

    int res = fvm_execute_program(&vm, &prog);

    if (out_stdout) {
        *out_stdout = vm.out_buffer ? strdup(vm.out_buffer) : strdup("");
        if (out_stdout_len) *out_stdout_len = vm.out_len;
    }
    if (out_stderr) {
        *out_stderr = vm.err_buffer ? strdup(vm.err_buffer) : strdup("");
        if (out_stderr_len) *out_stderr_len = vm.err_len;
    }

    fvm_state_cleanup(&vm);
    return res;
}
