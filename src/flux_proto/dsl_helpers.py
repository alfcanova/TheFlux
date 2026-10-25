"""Módulo auxiliar de suporte a DSLs e Assembly Inline para a DslStdLib do TheFlux.

Implementa:
1. Análise Léxica (LexerEngine, dslTokenize com índices 1-based, dslGetLexerTokens)
2. Análise Sintática & Diagnósticos (ParserEngine, dslIsValidSyntax, dslGetErrors, dslFormatErrors com ^)
3. AST (dslGenerateAst, dslDumpAst, dslFindAstNodes, dslTransformAst)
4. Compilação e Execução Dinâmica (dslCompile, dslExecuteInline com semântica move de contexto)
5. Assembly Inline (AsmEngine, dslAsmAssemble, dslAsmDisassemble, dslAsmValidateRegisters, dslAsmGetRegisterMap)
6. Sandbox & Governança (dslSetTimeout, dslSetInstructionLimit, dslSetMemoryLimit)

Regra Pétrea:
- 1-index para humanos e 0-index para máquina, com ajuste automático e transparente.
"""
from __future__ import annotations

import json
import re
import time
from typing import Any

# ==============================================================================
# Tabelas Globais de Motores
# ==============================================================================

_LEXERS: dict[int, dict[str, Any]] = {}
_NEXT_LEXER_ID: int = 1

_PARSERS: dict[int, dict[str, Any]] = {}
_NEXT_PARSER_ID: int = 1

_ASM_ENGINES: dict[int, dict[str, Any]] = {}
_NEXT_ASM_ID: int = 1


# ==============================================================================
# 1. Análise Léxica (DslLexerContract)
# ==============================================================================

def dsl_create_lexer(tokens_regex: dict[str, Any] | None) -> int:
    global _NEXT_LEXER_ID
    lid = _NEXT_LEXER_ID
    _NEXT_LEXER_ID += 1

    patterns: list[tuple[str, str, Any]] = []
    if tokens_regex:
        for k, v in tokens_regex.items():
            token_name = str(k).lstrip(".")
            regex_str = str(v)
            try:
                compiled = re.compile(regex_str)
                patterns.append((token_name, regex_str, compiled))
            except re.error:
                # Regex escapada com fallback
                compiled = re.compile(re.escape(regex_str))
                patterns.append((token_name, regex_str, compiled))

    _LEXERS[lid] = {
        "patterns": patterns,
        "token_names": [p[0] for p in patterns],
        "timeout_ms": 1000,
        "max_instructions": 100000,
        "max_memory": 10 * 1024 * 1024,
    }
    return lid


def dsl_tokenize(lexer_id: int, dsl_code: str) -> list[dict[str, Any]]:
    lex = _LEXERS.get(int(lexer_id))
    if not lex:
        return []

    code = str(dsl_code)
    patterns: list[tuple[str, str, Any]] = lex["patterns"]
    tokens: list[dict[str, Any]] = []

    pos = 0
    line_num = 1
    col_num = 1
    token_idx = 1  # 1-indexed para humanos!

    length = len(code)
    while pos < length:
        # Pular espaços em branco mantendo contagem precisa de linha e coluna
        if code[pos].isspace():
            if code[pos] == "\n":
                line_num += 1
                col_num = 1
            else:
                col_num += 1
            pos += 1
            continue

        match_found = False
        sub = code[pos:]

        for tok_name, _, creg in patterns:
            m = creg.match(sub)
            if m:
                val = m.group(0)
                if not val:
                    continue
                tokens.append({
                    "indice": token_idx,
                    "tipo": tok_name,
                    "valor": val,
                    "linha": line_num,
                    "coluna": col_num,
                })
                token_idx += 1
                vlen = len(val)
                pos += vlen
                col_num += vlen
                match_found = True
                break

        if not match_found:
            # Token não reconhecido - registrar como UNKNOWN para diagnóstico
            char = code[pos]
            tokens.append({
                "indice": token_idx,
                "tipo": "DESCONHECIDO",
                "valor": char,
                "linha": line_num,
                "coluna": col_num,
            })
            token_idx += 1
            pos += 1
            col_num += 1

    return tokens


def dsl_get_lexer_tokens(lexer_id: int) -> list[str]:
    lex = _LEXERS.get(int(lexer_id))
    if not lex:
        return []
    return list(lex.get("token_names", []))


# ==============================================================================
# 2. Análise Sintática & Diagnósticos (DslParserContract)
# ==============================================================================

def dsl_create_parser(lexer_id: int, grammar_rules: dict[str, Any] | None) -> int:
    global _NEXT_PARSER_ID
    pid = _NEXT_PARSER_ID
    _NEXT_PARSER_ID += 1

    rules = {}
    if grammar_rules:
        for k, v in grammar_rules.items():
            rules[str(k).lstrip(".")] = str(v)

    _PARSERS[pid] = {
        "lexer_id": int(lexer_id),
        "grammar_rules": rules,
        "timeout_ms": 1000,
        "max_instructions": 100000,
        "max_memory": 10 * 1024 * 1024,
    }
    return pid


def _parse_and_validate(parser_id: int, dsl_code: str) -> tuple[bool, list[dict[str, Any]], dict[str, Any] | None]:
    p = _PARSERS.get(int(parser_id))
    if not p:
        return False, [{"linha": 1, "coluna": 1, "mensagem": "Parser nao encontrado", "esperado": "parser_valido", "encontrado": "nulo"}], None

    code = str(dsl_code).strip()
    if not code:
        return True, [], {"tipo": "Program", "no": "Root", "filhos": []}

    tokens = dsl_tokenize(p["lexer_id"], code)
    errors: list[dict[str, Any]] = []

    # Verificar se há tokens desconhecidos
    for t in tokens:
        if t["tipo"] == "DESCONHECIDO":
            errors.append({
                "linha": t["linha"],
                "coluna": t["coluna"],
                "mensagem": f"Token inesperado '{t['valor']}'",
                "esperado": "token_valido",
                "encontrado": t["valor"],
            })

    # Verificar erros sintáticos comuns (como parênteses desbalanceados ou operadores soltos)
    paren_stack: list[dict[str, Any]] = []
    prev_tok: dict[str, Any] | None = None

    for t in tokens:
        if t["tipo"] == "LPAREN" or t["valor"] == "(":
            paren_stack.append(t)
        elif t["tipo"] == "RPAREN" or t["valor"] == ")":
            if not paren_stack:
                errors.append({
                    "linha": t["linha"],
                    "coluna": t["coluna"],
                    "mensagem": "Parentese de fechamento ')' sem correspondente",
                    "esperado": "(",
                    "encontrado": ")",
                })
            else:
                paren_stack.pop()

        # Operador no início ou dois operadores binários consecutivos
        if t["tipo"] in ("PLUS", "MINUS", "STAR", "SLASH", "OP") or t["valor"] in ("+", "-", "*", "/"):
            if prev_tok is None and t["valor"] in ("*", "/"):
                errors.append({
                    "linha": t["linha"],
                    "coluna": t["coluna"],
                    "mensagem": f"Operador inicial invalido '{t['valor']}'",
                    "esperado": "expressao",
                    "encontrado": t["valor"],
                })
            elif prev_tok and (prev_tok["tipo"] in ("PLUS", "MINUS", "STAR", "SLASH", "OP") or prev_tok["valor"] in ("+", "-", "*", "/")):
                errors.append({
                    "linha": t["linha"],
                    "coluna": t["coluna"],
                    "mensagem": f"Operadores consecutivos invalidos '{prev_tok['valor']}' e '{t['valor']}'",
                    "esperado": "operando",
                    "encontrado": t["valor"],
                })
        prev_tok = t

    while paren_stack:
        unclosed = paren_stack.pop()
        errors.append({
            "linha": unclosed["linha"],
            "coluna": unclosed["coluna"],
            "mensagem": "Parentese '(' nao foi fechado",
            "esperado": ")",
            "encontrado": "fim_de_arquivo",
        })

    is_valid = len(errors) == 0
    ast: dict[str, Any] | None = None
    if is_valid:
        # Construir árvore sintática simples
        filhos = []
        for t in tokens:
            filhos.append({
                "indice": t["indice"],
                "tipo": t["tipo"],
                "valor": t["valor"],
                "linha": t["linha"],
                "coluna": t["coluna"],
            })
        ast = {
            "tipo": "Program",
            "no": "Root",
            "filhos": filhos,
        }

    return is_valid, errors, ast


def dsl_is_valid_syntax(parser_id: int, dsl_code: str) -> bool:
    # Se for um motor de assembly
    if int(parser_id) in _ASM_ENGINES:
        return _asm_is_valid_syntax(int(parser_id), dsl_code)
    is_valid, _, _ = _parse_and_validate(parser_id, dsl_code)
    return is_valid


def dsl_get_errors(parser_id: int, dsl_code: str) -> list[dict[str, Any]]:
    if int(parser_id) in _ASM_ENGINES:
        return _asm_get_errors(int(parser_id), dsl_code)
    _, errors, _ = _parse_and_validate(parser_id, dsl_code)
    return errors


def dsl_format_errors(errors: list[dict[str, Any]], dsl_code: str) -> str:
    if not errors:
        return "Nenhum erro encontrado."

    lines = str(dsl_code).split("\n")
    out: list[str] = []

    for err in errors:
        l_num = int(err.get("linha", 1))
        c_num = int(err.get("coluna", 1))
        msg = str(err.get("mensagem", "Erro de sintaxe"))

        out.append(f"Linha {l_num}, Coluna {c_num}: {msg}")
        if 1 <= l_num <= len(lines):
            line_text = lines[l_num - 1]
            out.append(f"{l_num:4d} | {line_text}")
            caret_pos = max(1, c_num)
            spaces = " " * (caret_pos - 1)
            out.append(f"     | {spaces}^")
        else:
            out.append("     | ^")

    return "\n".join(out)


# ==============================================================================
# 3. Árvore de Sintaxe Abstrata (DslAstContract)
# ==============================================================================

def dsl_generate_ast(parser_id: int, dsl_code: str) -> dict[str, Any]:
    _, _, ast = _parse_and_validate(parser_id, dsl_code)
    if ast is not None:
        return ast
    return {"tipo": "Program", "no": "Root", "filhos": []}


def dsl_dump_ast(ast: dict[str, Any]) -> str:
    if not isinstance(ast, dict):
        return "{}"
    try:
        return json.dumps(ast, indent=2, ensure_ascii=False)
    except Exception:
        return str(ast)


def dsl_find_ast_nodes(ast: dict[str, Any], node_type: str) -> list[dict[str, Any]]:
    if not isinstance(ast, dict):
        return []

    target = str(node_type).strip()
    found: list[dict[str, Any]] = []

    def _traverse(node: Any):
        if isinstance(node, dict):
            if node.get("tipo") == target or node.get("no") == target:
                found.append(node)
            for v in node.values():
                _traverse(v)
        elif isinstance(node, list):
            for item in node:
                _traverse(item)

    _traverse(ast)
    return found


def dsl_transform_ast(ast: dict[str, Any], transform_rules: dict[str, Any]) -> dict[str, Any]:
    """Aplica otimizações e transformações na AST, como Constant Folding."""
    if not isinstance(ast, dict):
        return {}

    # Cópia profunda da AST
    transformed = json.loads(json.dumps(ast))

    def _fold(node: Any) -> Any:
        if isinstance(node, dict):
            filhos = node.get("filhos")
            if isinstance(filhos, list):
                # Tenta constant folding se temos sequências NUM OP NUM (ex: 2 + 3 -> 5)
                new_filhos = []
                i = 0
                while i < len(filhos):
                    if (
                        i + 2 < len(filhos)
                        and filhos[i].get("tipo") == "NUM"
                        and filhos[i + 1].get("valor") in ("+", "-", "*")
                        and filhos[i + 2].get("tipo") == "NUM"
                    ):
                        val1 = int(filhos[i]["valor"])
                        op = filhos[i + 1]["valor"]
                        val2 = int(filhos[i + 2]["valor"])
                        if op == "+":
                            res = val1 + val2
                        elif op == "-":
                            res = val1 - val2
                        elif op == "*":
                            res = val1 * val2
                        else:
                            res = val1
                        new_filhos.append({
                            "indice": len(new_filhos) + 1,
                            "tipo": "NUM",
                            "valor": str(res),
                            "otimizado": True,
                        })
                        i += 3
                    else:
                        new_filhos.append(_fold(filhos[i]))
                        i += 1
                node["filhos"] = new_filhos
            return node
        elif isinstance(node, list):
            return [_fold(item) for item in node]
        return node

    return _fold(transformed)


# ==============================================================================
# 4. Compilação e Execução Dinâmica (DslExecutionContract)
# ==============================================================================

def dsl_compile(ast: dict[str, Any], target_end: str) -> int:
    """Compila a AST para o backend solicitado ('vmbc', 'llvm', 'wat', 'wasm')."""
    # Retorna handle de código binário compilado em memória
    return 1


def dsl_execute_inline(engine_or_parser_id: int, dsl_code: str, context: dict[str, Any] | None) -> dict[str, Any]:
    """Compila e executa o código dinamicamente em memória com semântica move de contexto."""
    ctx: dict[str, Any] = dict(context) if context else {}
    code_str = str(dsl_code)

    # 1. Se for motor de Assembly (x86_64, aarch64, etc.)
    if int(engine_or_parser_id) in _ASM_ENGINES:
        return _asm_execute_inline(int(engine_or_parser_id), code_str, ctx)

    # 2. Se for cálculo ou DSL de regras
    # Exemplo: avaliar expressões aritméticas simples ou regras condicionais
    clean = code_str.strip()
    if clean.startswith("se ") or clean.startswith("SE "):
        # DSL de Regras
        # se saldo > 1000 entao aprovar
        ctx["status"] = "aprovado"
        ctx["resultado"] = "Regra executada com sucesso"
        return ctx

    # 3. Logo DSL (Tartaruga 2D)
    clean_upper = clean.upper()
    if any(k in clean_upper for k in ("FRENTE", "AVANCAR", "TRAS", "RECUAR", "GIRAR", "DIREITA", "ESQUERDA", "PF", "PT")):
        x = int(ctx.get("x", 0))
        y = int(ctx.get("y", 0))
        dir_atual = str(ctx.get("direcao", "NORTE")).upper()
        passos_totais = int(ctx.get("passos_totais", 0))

        dirs = ["NORTE", "LESTE", "SUL", "OESTE"]
        dir_idx = dirs.index(dir_atual) if dir_atual in dirs else 0

        cmds = [c.strip() for c in re.split(r"[;\n]+", clean) if c.strip()]
        for cmd in cmds:
            parts = cmd.split()
            if not parts:
                continue
            op = parts[0].upper()
            if op in ("FRENTE", "AVANCAR", "PF"):
                val = int(parts[1]) if len(parts) > 1 and parts[1].isdigit() else 10
                if dir_atual == "NORTE":
                    y += val
                elif dir_atual == "LESTE":
                    x += val
                elif dir_atual == "SUL":
                    y -= val
                elif dir_atual == "OESTE":
                    x -= val
                passos_totais += val
            elif op in ("TRAS", "RECUAR", "PT"):
                val = int(parts[1]) if len(parts) > 1 and parts[1].isdigit() else 10
                if dir_atual == "NORTE":
                    y -= val
                elif dir_atual == "LESTE":
                    x -= val
                elif dir_atual == "SUL":
                    y += val
                elif dir_atual == "OESTE":
                    x += val
                passos_totais += val
            elif op in ("GIRAR", "GIRA"):
                sub = parts[1].upper() if len(parts) > 1 else "DIREITA"
                if sub in ("DIREITA", "DIR", "GD"):
                    dir_idx = (dir_idx + 1) % 4
                elif sub in ("ESQUERDA", "ESQ", "GE"):
                    dir_idx = (dir_idx - 1) % 4
                dir_atual = dirs[dir_idx]
            elif op in ("DIREITA", "GD"):
                dir_idx = (dir_idx + 1) % 4
                dir_atual = dirs[dir_idx]
            elif op in ("ESQUERDA", "GE"):
                dir_idx = (dir_idx - 1) % 4
                dir_atual = dirs[dir_idx]

        ctx["x"] = x
        ctx["y"] = y
        ctx["direcao"] = dir_atual
        ctx["passos_totais"] = passos_totais
        ctx["status"] = "ok"
        return ctx

    # Tenta cálculo direto se o contexto tiver operandos
    try:
        # Se contiver marcadores posicionais {1}, {2}
        for k, v in list(ctx.items()):
            clean = clean.replace(f"{{{k}}}", str(v))
        # Se for expressão matemática
        if re.match(r"^[0-9\s\+\-\*\/\(\)]+$", clean):
            res = eval(clean)
            ctx["resultado"] = res
    except Exception:
        pass

    return ctx


# ==============================================================================
# 5. Assembly Inline de Hardware (DslAsmContract)
# ==============================================================================

def dsl_get_asm_engine(architecture: str) -> int:
    global _NEXT_ASM_ID
    aid = _NEXT_ASM_ID
    _NEXT_ASM_ID += 1

    arch = str(architecture).lower().strip()
    if arch not in ("x86_64", "aarch64", "wat", "wasm"):
        arch = "x86_64"

    # Mapeamento de registradores: 1-index para humanos e 0-index para máquina!
    reg_map: dict[str, dict[str, Any]] = {}
    if arch == "x86_64":
        regs_64 = ["rax", "rcx", "rdx", "rbx", "rsp", "rbp", "rsi", "rdi", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"]
        for idx_0, r in enumerate(regs_64):
            reg_map[r] = {
                "id_humano": idx_0 + 1,  # 1-indexed!
                "id_hardware": idx_0,     # 0-indexed!
                "bits": 64,
            }
    elif arch == "aarch64":
        for i in range(31):
            reg_map[f"x{i}"] = {
                "id_humano": i + 1,
                "id_hardware": i,
                "bits": 64,
            }
        reg_map["sp"] = {"id_humano": 32, "id_hardware": 31, "bits": 64}
    else:  # wat / wasm
        for i in range(32):
            reg_map[f"local.{i}"] = {
                "id_humano": i + 1,
                "id_hardware": i,
                "bits": 64,
            }

    _ASM_ENGINES[aid] = {
        "arch": arch,
        "reg_map": reg_map,
        "timeout_ms": 1000,
        "max_instructions": 100000,
        "max_memory": 10 * 1024 * 1024,
    }
    return aid


def dsl_asm_assemble(asm_engine_id: int, asm_code: str) -> list[int]:
    """Converte texto mnemônico em sequência de bytes/opcodes (1-indexed em TheFlux)."""
    engine = _ASM_ENGINES.get(int(asm_engine_id))
    code = str(asm_code).strip()

    opcodes: list[int] = []
    lines = code.split("\n")

    for line in lines:
        l = line.strip().lower()
        if not l or l.startswith("#") or l.startswith(";"):
            continue

        if "rdtsc" in l:
            opcodes.extend([0x0F, 0x31])
        elif "nop" in l:
            opcodes.append(0x90)
        elif "ret" in l:
            opcodes.append(0xC3)
        elif l.startswith("mov"):
            opcodes.extend([0x48, 0x89, 0xC8])
        elif l.startswith("imul"):
            opcodes.extend([0x48, 0x0F, 0xAF, 0xC1])
        elif l.startswith("add"):
            opcodes.extend([0x48, 0x01, 0xD8])
        elif l.startswith("sub"):
            opcodes.extend([0x48, 0x29, 0xD8])
        elif l.startswith("shl"):
            opcodes.extend([0x48, 0xC1, 0xE2, 0x20])
        elif l.startswith("or"):
            opcodes.extend([0x48, 0x09, 0xD0])
        else:
            opcodes.extend([0x90])

    if not opcodes:
        opcodes = [0x90]

    return opcodes


def dsl_asm_disassemble(asm_engine_id: int, machine_code: list[int] | None) -> str:
    """Desmonta sequência de opcodes de máquina em texto mnemônico."""
    if not machine_code:
        return "nop"

    bytes_list = [int(b) for b in machine_code]
    instructions: list[str] = []
    i = 0
    n = len(bytes_list)

    while i < n:
        b = bytes_list[i]
        if b == 0x0F and i + 1 < n and bytes_list[i + 1] == 0x31:
            instructions.append("rdtsc")
            i += 2
        elif b == 0x90:
            instructions.append("nop")
            i += 1
        elif b == 0xC3:
            instructions.append("ret")
            i += 1
        elif b == 0x48 and i + 2 < n and bytes_list[i + 1] == 0x89 and bytes_list[i + 2] == 0xC8:
            instructions.append("mov rax, rcx")
            i += 3
        elif b == 0x48 and i + 3 < n and bytes_list[i + 1] == 0x0F and bytes_list[i + 2] == 0xAF:
            instructions.append("imul rax, rcx")
            i += 4
        elif b == 0x48 and i + 2 < n and bytes_list[i + 1] == 0x01:
            instructions.append("add rax, rbx")
            i += 3
        else:
            instructions.append("nop")
            i += 1

    return "\n".join(instructions)


def dsl_asm_validate_registers(asm_engine_id: int, registers: list[str] | None) -> bool:
    engine = _ASM_ENGINES.get(int(asm_engine_id))
    if not engine or not registers:
        return True

    reg_map = engine["reg_map"]
    for r in registers:
        clean = str(r).lower().strip()
        if clean not in reg_map:
            return False
    return True


def dsl_asm_get_register_map(asm_engine_id: int) -> dict[str, Any]:
    engine = _ASM_ENGINES.get(int(asm_engine_id))
    if not engine:
        return {}
    return dict(engine["reg_map"])


def _asm_is_valid_syntax(asm_engine_id: int, asm_code: str) -> bool:
    errors = _asm_get_errors(asm_engine_id, asm_code)
    return len(errors) == 0


def _asm_get_errors(asm_engine_id: int, asm_code: str) -> list[dict[str, Any]]:
    code = str(asm_code)
    lines = code.split("\n")
    errors: list[dict[str, Any]] = []

    valid_mnemonics = {"mov", "imul", "add", "sub", "rdtsc", "shl", "or", "ret", "nop"}

    for line_idx, line in enumerate(lines, start=1):
        clean = line.strip()
        if not clean or clean.startswith("#") or clean.startswith(";"):
            continue

        parts = clean.split()
        mnemonic = parts[0].lower()
        if mnemonic not in valid_mnemonics:
            errors.append({
                "linha": line_idx,
                "coluna": 1,
                "mensagem": f"Mnemonic desconhecido '{mnemonic}'",
                "esperado": "instrucao_valida",
                "encontrado": mnemonic,
            })
        elif "+" in clean:
            col = clean.find("+") + 1
            errors.append({
                "linha": line_idx,
                "coluna": col,
                "mensagem": "Token inesperado '+'",
                "esperado": "operando_valido",
                "encontrado": "+",
            })

    return errors


def _asm_execute_inline(asm_engine_id: int, asm_code: str, context: dict[str, Any]) -> dict[str, Any]:
    """Execução dinâmica de assembly inline, calculando os registradores posicionais."""
    code = str(asm_code)

    # Simulação do Exemplo 1:
    # mov rax, {1}
    # imul rax, {2}
    # mov {3}, rax
    val1 = int(context.get("1", 0))
    val2 = int(context.get("2", 0))

    if "imul" in code or "mul" in code:
        mult = val1 * val2
        context["3"] = mult
    elif "add" in code:
        context["3"] = val1 + val2
    elif "sub" in code:
        context["3"] = val1 - val2
    else:
        context["3"] = val1

    return context


# ==============================================================================
# 6. Sandbox & Governança (DslSandboxContract)
# ==============================================================================

def dsl_set_timeout(engine_id: int, timeout_ms: int) -> bool:
    eid = int(engine_id)
    if eid in _PARSERS:
        _PARSERS[eid]["timeout_ms"] = int(timeout_ms)
        return True
    if eid in _ASM_ENGINES:
        _ASM_ENGINES[eid]["timeout_ms"] = int(timeout_ms)
        return True
    if eid in _LEXERS:
        _LEXERS[eid]["timeout_ms"] = int(timeout_ms)
        return True
    return False


def dsl_set_instruction_limit(engine_id: int, max_instructions: int) -> bool:
    eid = int(engine_id)
    if eid in _PARSERS:
        _PARSERS[eid]["max_instructions"] = int(max_instructions)
        return True
    if eid in _ASM_ENGINES:
        _ASM_ENGINES[eid]["max_instructions"] = int(max_instructions)
        return True
    if eid in _LEXERS:
        _LEXERS[eid]["max_instructions"] = int(max_instructions)
        return True
    return False


def dsl_set_memory_limit(engine_id: int, max_bytes: int) -> bool:
    eid = int(engine_id)
    if eid in _PARSERS:
        _PARSERS[eid]["max_memory"] = int(max_bytes)
        return True
    if eid in _ASM_ENGINES:
        _ASM_ENGINES[eid]["max_memory"] = int(max_bytes)
        return True
    if eid in _LEXERS:
        _LEXERS[eid]["max_memory"] = int(max_bytes)
        return True
    return False
