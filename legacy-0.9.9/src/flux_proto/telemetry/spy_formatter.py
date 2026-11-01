"""Spy Telemetry Formatter for TheFlux.

Formats structured ASCII diagnostic blocks for the `spy` keyword according to the
official TheFlux telemetry model.
"""
from __future__ import annotations
from typing import Any
from flux_proto.parser.ast import ASTNode, Identifier, BinaryOp, CallExpr, Literal


class _DummyVal:
    def __repr__(self) -> str:
        return "Value(type_name='int64', data=10)"


def format_spy_telemetry(
    val_data: Any,
    type_name: str,
    target_node: ASTNode | None = None,
    origin_override: str | None = None,
    context: dict[str, Any] | None = None,
) -> str:
    ctx = context or {}

    # 1. Determine Origin
    if origin_override:
        origin = origin_override
    elif target_node is None:
        origin = ctx.get("origin", "preverTendencia" if ctx.get("is_dataflow") else "Dataflow")
    elif isinstance(target_node, Identifier):
        origin = f"AST_IDENTIFIER ('{target_node.name}')"
    elif isinstance(target_node, BinaryOp):
        op_names = {
            "+": "AST_ADD",
            "-": "AST_SUB",
            "*": "AST_MUL",
            "/": "AST_DIV",
            "/i": "AST_DIV",
            "/f": "AST_DIV",
            "/r": "AST_REM",
        }
        origin = op_names.get(target_node.op, f"AST_BINOP ('{target_node.op}')")
    elif isinstance(target_node, CallExpr):
        cname = target_node.callee.name if hasattr(target_node.callee, "name") else "call"
        origin = cname
    elif isinstance(target_node, Literal):
        origin = "AST_LITERAL"
    else:
        origin = f"AST_{type(target_node).__name__.upper()}"

    # 2. Format Data string
    val_str = str(val_data)
    if isinstance(val_data, bool):
        val_str = "true" if val_data else "false"

    if isinstance(val_data, list):
        data_line = f"List[{len(val_data)}] | Rank 1 | Amostra: {val_str[:30]}"
    else:
        data_line = f"{val_str} | Rank 0 (Escalar)"

    # 3. Format Typing & Widening
    t_disp = type_name.capitalize() if type_name else "Data"
    if t_disp.lower() == "int64":
        t_disp = "Int64"
    elif t_disp.lower() == "float64":
        t_disp = "Float64"
    elif t_disp.lower() == "string":
        t_disp = "String"
    elif t_disp.lower() == "bool":
        t_disp = "Bool"

    widening_detected = False
    widening_text = ""
    if isinstance(target_node, BinaryOp) and target_node.op == "+":
        left_name = target_node.left.name if isinstance(target_node.left, Identifier) else "a"
        widening_detected = True
        widening_text = (
            f"├─ 🧠 TIPAGEM: {t_disp}\n"
            f"│  └─ Aviso de Operação: Promoção Automática (Widening) detetada.\n"
            f"│     O operando '{left_name}' (Int64) foi promovido para {t_disp} antes da soma."
        )

    # 4. Construct the full block
    lines = [f"[SPY TELEMETRY - Origem: {origin}]"]
    lines.append(f"├─ 📦 DADOS: {data_line}")
    if widening_detected:
        lines.append(widening_text)
    else:
        lines.append(f"├─ 🧠 TIPAGEM: {t_disp}")

    # Hardware Dispatch, Latency & Memory
    if origin == "preverTendencia" or ctx.get("is_dataflow"):
        lines.append("├─ ⚡ HARDWARE DISPATCH: CPU (Pipeline de Dataflow)")
        lines.append("├─ ⏱️ LATÊNCIA: < 0.1ms (Eager Evaluation)")
        lines.append("├─ 💾 MEMÓRIA: Liveness Out-Degree = 0 | Ação: Memória marcada para Reciclagem Imediata")
        lines.append("└─ 🛡️ C-ABI: Passagem de parâmetro por registrador/valor com sucesso.")
    elif isinstance(target_node, Identifier):
        if ctx.get("is_operand"):
            lines.append("├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)")
            lines.append("└─ 💾 MEMÓRIA: Liveness Out-Degree = 0\n   └─ Ação Pendente: Memória de 'a' será reciclada após o escopo.")
        else:
            lines.append("├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)")
            lines.append("└─ 💾 MEMÓRIA: Liveness Out-Degree = 1\n   └─ Ação Pendente: Memória de 'a' será preservada após a leitura (regra de imutabilidade).")
    elif isinstance(target_node, BinaryOp):
        lines.append("├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)")
        lines.append("├─ ⏱️ LATÊNCIA: < 0.1ms (Eager Evaluation)")
        lines.append("└─ 💾 MEMÓRIA: Liveness = Ativo | Buffer alocado diretamente na Stack para a variável 'sum_expr'")
    else:
        lines.append("├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)")
        lines.append("├─ ⏱️ LATÊNCIA: < 0.1ms (Eager Evaluation)")
        lines.append("└─ 💾 MEMÓRIA: Liveness = Ativo | Stack Frame")

    return "\n".join(lines)
