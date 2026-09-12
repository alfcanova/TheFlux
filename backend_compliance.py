"""Executa cada arquivo em ./flux nos 6 backends e compara as saidas.

Backends (colunas da tabela): in, vm, vmr, llvm, wat, wasm
    in    interpretador AST (flux_in.py)              -> referencia
    vm    bytecode .fvmbc executado pela VM
    vmr   bytecode .fvmbc recarregado do disco e executado pela VM
    llvm  LLVM IR -> clang -> executavel nativo
    wat   WAT -> wat2wasm -> wasmer
    wasm  WASM binario -> wasmer

Gera backend_compliance.md com tabela de checks e totalizacao.

Uso: python backend_compliance.py [--out DIR] [--stdin 'k=texto']
"""
from __future__ import annotations

import difflib
import io
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
SRC = RAIZ / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

FLUX_DIR = RAIZ / "flux"
T_FVMBC = RAIZ / "t_fvmbc"
T_LLVM = RAIZ / "t_llvm"
T_WAT = RAIZ / "t_wat-1.0"
T_WASM = RAIZ / "t_wasm-1.0"

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}


def ler_inputs_yaml(path: Path) -> list[str] | None:
    """Le os `inputs` declarados em flux/<stem>.yaml (injetor de dados).

    Cada flux/ExampleOfX.flux pode ter um ExampleOfX.yaml companheiro com uma
    lista YAML `inputs:` (1 item por chamada de `input`, na ordem do programa).
    Devolve a lista, ou None se nao houver o .yaml / campo `inputs`.
    """
    yaml_path = path.with_suffix(".yaml")
    if not yaml_path.exists():
        return None
    try:
        import yaml as _yaml
    except ImportError:
        _yaml = None
    try:
        if _yaml is not None:
            data = _yaml.safe_load(yaml_path.read_text(encoding="utf-8"))
            inputs = data.get("inputs") if isinstance(data, dict) else None
        else:
            inputs = _ler_inputs_manual(yaml_path)
    except Exception:
        inputs = None
    if not isinstance(inputs, list):
        return None
    return [str(v) for v in inputs]


def _ler_inputs_manual(yaml_path: Path) -> list[str] | None:
    """Fallback sem PyYAML: extrai itens `- "valor"` da secao inputs:."""
    lines = yaml_path.read_text(encoding="utf-8").splitlines()
    result: list[str] = []
    in_inputs = False
    for ln in lines:
        s = ln.strip()
        if not in_inputs:
            in_inputs = s == "inputs:" or s.startswith("inputs:")
            continue
        if s.startswith("- "):
            item = s[2:].strip()
            if len(item) >= 2 and item[0] == '"' and item[-1] == '"':
                item = item[1:-1]
            result.append(item)
        elif s and not s.startswith("#"):
            break
    return result or None


def stdin_para(path: Path) -> str:
    """Determina o stdin a injetar para um arquivo .flux."""
    inputs = ler_inputs_yaml(path)
    if inputs is not None:
        return "\n".join(inputs) + "\n"
    return STDIN_MAP.get(path.name, "")

PYTHON = sys.executable
ENV = dict(os.environ, PYTHONPATH=str(SRC), PYTHONUTF8="1", PYTHONIOENCODING="utf-8")

T_DIRS = [
    RAIZ / "t_benchmarks",
    RAIZ / "t_fvmbc",
    RAIZ / "t_general",
    RAIZ / "t_llvm",
    RAIZ / "t_wasm-1.0",
    RAIZ / "t_wasm-2.0",
    RAIZ / "t_wasm-3.0",
    RAIZ / "t_wat-1.0",
    RAIZ / "t_wat-2.0",
    RAIZ / "t_wat-3.0",
    RAIZ / "intermediates" / "llvm",
]

WABT_DIR = RAIZ.parent / "wabt-1.0.41" / "bin"


def _find_tool(name: str, extra_dirs: list[Path]) -> str | None:
    p = shutil.which(name)
    if p:
        return p
    for d in extra_dirs:
        c = d / (name + ".exe")
        if c.exists():
            return str(c)
    return None


TOOLS = {
    "wat2wasm": _find_tool("wat2wasm", [WABT_DIR]),
    "wasmer": _find_tool("wasmer", [Path.home() / ".wasmer" / "bin"]),
    "clang": _find_tool("clang", [Path(r"C:\Program Files\LLVM\bin"), Path(r"C:\Arquivos de Programas\LLVM\bin")]),
}


def limpar_t() -> None:
    for d in T_DIRS:
        if d.exists():
            for f in d.iterdir():
                if f.is_file() and f.name != ".gitkeep":
                    try:
                        f.unlink()
                    except Exception:
                        pass
    print("Limpado: t_* e intermediates/llvm")


def _run(cmd: list[str], *, timeout: int = 60, input_text: str = "", cwd: Path | None = None) -> subprocess.CompletedProcess:
    try:
        return subprocess.run(
            cmd, capture_output=True, text=True, encoding="utf-8", errors="replace",
            timeout=timeout, env=ENV, input=input_text, cwd=str(cwd) if cwd else None,
        )
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(cmd, -1, "", "timeout")


def saida_interp(path: Path, stdin_text: str) -> str | None:
    r = _run([PYTHON, str(RAIZ / "flux_in.py"), str(path.resolve())], input_text=stdin_text)
    if r.returncode != 0:
        return None
    return r.stdout


def saida_vm(path: Path, stdin_text: str) -> str | None:
    out = _run([PYTHON, "-m", "flux_proto", str(path), "--target", "vmbc", "--output", str(T_FVMBC / path.stem)], input_text=stdin_text)
    if out.returncode != 0:
        return None
    bc_path = T_FVMBC / (path.stem + ".fvmbc")
    return _executa_bc(bc_path, stdin_text)


def _executa_bc(bc_path: Path, stdin_text: str) -> str | None:
    if not bc_path.exists():
        return None
    try:
        with open(bc_path, encoding="utf-8") as f:
            bc = json.load(f)
        from flux_proto.vm.runtime import execute_bytecode
        cap = io.StringIO()
        old_in, old_out = sys.stdin, sys.stdout
        sys.stdin = io.StringIO(stdin_text)
        try:
            with redirect_stdout(cap):
                execute_bytecode(bc)
        finally:
            sys.stdin, sys.stdout = old_in, old_out
        return cap.getvalue()
    except Exception:
        return None


def saida_vmr(path: Path, stdin_text: str) -> str | None:
    out = _run([PYTHON, "-m", "flux_proto", str(path), "--target", "vmbc", "--output", str(T_FVMBC / path.stem)], input_text=stdin_text)
    if out.returncode != 0:
        return None
    bc_path = T_FVMBC / (path.stem + ".fvmbc")
    return _executa_bc(bc_path, stdin_text)


def saida_lv(path: Path, stdin_text: str) -> str | None:
    out = _run([PYTHON, "-m", "flux_proto", str(path), "--emit-llvm"], input_text=stdin_text)
    if out.returncode != 0:
        return None
    ll_path = RAIZ / "intermediates" / "llvm" / (path.stem + ".ll")
    if not ll_path.exists():
        return None
    clang = TOOLS.get("clang")
    if not clang:
        return None
    exe_path = T_LLVM / (path.stem + ".exe")
    runtime_c = RAIZ / "src" / "flux_proto" / "llvm" / "runtime" / "flux_input.c"
    c = _run([clang, "-o", str(exe_path), str(ll_path), str(runtime_c)])
    if c.returncode != 0:
        return None
    return _run([str(exe_path)], input_text=stdin_text, timeout=30).stdout


def saida_wat(path: Path, stdin_text: str) -> str | None:
    out = _run([PYTHON, "-m", "flux_proto", str(path), "--target", "wat", "--output", str(T_WAT / path.stem)], input_text=stdin_text)
    if out.returncode != 0:
        return None
    wat_path = T_WAT / (path.stem + ".wat")
    if not wat_path.exists():
        return None
    w2w = TOOLS.get("wat2wasm")
    wasmer = TOOLS.get("wasmer")
    if not w2w or not wasmer:
        return None
    with tempfile.TemporaryDirectory(prefix="flux_cmp_") as td:
        bin_path = Path(td) / (path.stem + ".wasm")
        c = _run([w2w, str(wat_path), "-o", str(bin_path)])
        if c.returncode != 0:
            return None
        return _run([wasmer, "run", str(bin_path)], input_text=stdin_text, timeout=30).stdout


def saida_wasm(path: Path, stdin_text: str) -> str | None:
    out = _run([PYTHON, "-m", "flux_proto", str(path), "--target", "wasm", "--output", str(T_WASM / path.stem)], input_text=stdin_text)
    if out.returncode != 0:
        return None
    wasm_path = T_WASM / (path.stem + ".wasm")
    if not wasm_path.exists():
        return None
    wasmer = TOOLS.get("wasmer")
    if not wasmer:
        return None
    return _run([wasmer, "run", str(wasm_path)], input_text=stdin_text, timeout=30).stdout


BACKENDS = {
    "in": lambda p, s: saida_interp(p, s),
    "vm": lambda p, s: saida_vm(p, s),
    "vmr": lambda p, s: saida_vmr(p, s),
    "llvm": lambda p, s: saida_lv(p, s),
    "wat": lambda p, s: saida_wat(p, s),
    "wasm": lambda p, s: saida_wasm(p, s),
}

COLS = ["in", "vm", "vmr", "llvm", "wat", "wasm"]

GREEN = "\033[92m✓\033[0m"
RED = "\033[91m✗\033[0m"

MD_GREEN = "✅"
MD_RED = "❌"


def normalizar_saida(texto: str | None) -> str | None:
    """Normaliza saida para comparacao de conformidade entre backends.

    Trata valores numericos como 0 e 0.0 (ou -0.0) como equivalentes.
    """
    if texto is None:
        return None
    # Substitui 0.0, -0.0, 0.00... isolados por 0
    return re.sub(r'(^|[^\w.])(-?0\.0+)(?=[^\w.]|$)', r'\g<1>0', texto)


def diff_em_colunas(nome: str, col: str, ref: str, out: str) -> list[str]:
    """Devolve as linhas que divergem entre a saida do interpretador (referencia)
    e a saida do backend, alinhadas em duas colunas."""
    rl = ref.splitlines()
    ol = out.splitlines()
    rl_norm = [normalizar_saida(l) for l in rl]
    ol_norm = [normalizar_saida(l) for l in ol]
    sm = difflib.SequenceMatcher(None, rl_norm, ol_norm, autojunk=False)
    rows: list[tuple[int | None, str, str]] = []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        n = max(i2 - i1, j2 - j1)
        for k in range(n):
            ri = i1 + k if i1 + k < i2 else None
            oj = j1 + k if j1 + k < j2 else None
            rows.append((ri, rl[ri] if ri is not None else "", ol[oj] if oj is not None else ""))
    if not rows:
        return []
    w1 = max([len(r) for _, r, _ in rows] + [len("in (referencia)")])
    w2 = max([len(o) for _, _, o in rows] + [len(col)])
    out_lines = [f"{nome} [{col}] - valores que divergiram:"]
    out_lines.append(f"  {'linha':>6} | {'in (referencia)'.ljust(w1)} | {col.ljust(w2)}")
    for ri, rv, ov in rows:
        rn = str(ri + 1) if ri is not None else "-"
        out_lines.append(f"  {rn:>6} | {rv.ljust(w1)} | {ov}")
    return out_lines


def bloco_colunas(nome: str, outs: dict[str, str | None]) -> list[str]:
    """Gera bloco markdown com a saida de cada backend em colunas (1 coluna por
    backend, linhas alinhadas por indice; celulas vazias se um backend nao tem
    aquela linha)."""
    cols = COLS
    split: dict[str, list[str]] = {}
    for c in cols:
        if outs.get(c) is None:
            split[c] = ["(sem saida/falhou)"]
        else:
            split[c] = outs[c].splitlines()
    nrows = max((len(v) for v in split.values()), default=0)
    widths = {c: max([len(l) for l in split[c]] + [len(c)]) for c in cols}
    esc = lambda s: s.replace("|", "\\|")
    out = [f"### {nome}", ""]
    out.append("| " + " | ".join(c.ljust(widths[c]) for c in cols) + " |")
    out.append("| " + " | ".join("-" * widths[c] for c in cols) + " |")
    for i in range(nrows):
        cells = [esc((split[c][i] if i < len(split[c]) else "").ljust(widths[c])) for c in cols]
        out.append("| " + " | ".join(cells) + " |")
    out.append("")
    return out


PAGE_SIZE = 10

MD_CELL = {
    "in": " ✅ ",
    "vm": " ✅ ",
    "vmr": " ✅ ",
    "llvm": " ✅ ",
    "wat": " ✅ ",
    "wasm": " ✅ ",
    "result": "  ✅  ",
}
MD_CELL_ERR = {
    "in": " ❌ ",
    "vm": " ❌ ",
    "vmr": " ❌ ",
    "llvm": " ❌ ",
    "wat": " ❌ ",
    "wasm": " ❌ ",
    "result": "  ❌  ",
}
MD_HEAD = {
    "in": " in  ",
    "vm": " vm ",
    "vmr": " vmr",
    "llvm": "llvm",
    "wat": " wat",
    "wasm": "wasm ",
    "result": "result",
}
MD_SEP = {
    "in": 5,
    "vm": 4,
    "vmr": 4,
    "llvm": 4,
    "wat": 4,
    "wasm": 5,
    "result": 6,
}


def ler_tabela_md(md_path: Path) -> dict[str, dict[str, bool]]:
    """Le um arquivo de compliance markdown e extrai os resultados por arquivo e backend."""
    if not md_path.exists():
        return {}
    res: dict[str, dict[str, bool]] = {}
    for line in md_path.read_text(encoding="utf-8").splitlines():
        line_s = line.strip()
        if not line_s.startswith("|") or line_s.startswith("| arquivo") or line_s.startswith("| -"):
            continue
        parts = [p.strip() for p in line_s.split("|")[1:-1]]
        if len(parts) >= 8 and parts[0].endswith(".flux"):
            nome = parts[0]
            if nome not in res:
                res[nome] = {
                    "in": "✅" in parts[1],
                    "vm": "✅" in parts[2],
                    "vmr": "✅" in parts[3],
                    "llvm": "✅" in parts[4],
                    "wat": "✅" in parts[5],
                    "wasm": "✅" in parts[6],
                }
    return res


def gerar_md(results: dict[str, dict[str, bool]], totais: dict[str, int], md_path: Path, outs: dict[str, dict[str, str | None]], old_results: dict[str, dict[str, bool]] | None = None) -> None:
    """Gera backend_compliance.md: tabela paginada com ✅ verde / ❌ vermelho por
    backend e coluna result (verde se todos os backends concordam, vermelho caso
    contrario), seguida da totalizacao por backend, secao de regressao (comparando
    com backend_compliance_OLD.md) e, por fim, blocos com as saidas colunadas dos
    arquivos que divergem."""
    larg_arq = max([len(n) for n in results] + [len("arquivo")])

    def linha_md(nome: str, linha: dict[str, bool]) -> str:
        cells = [nome.ljust(larg_arq)]
        for c in COLS:
            cells.append(MD_CELL[c] if linha.get(c, False) else MD_CELL_ERR[c])
        ok_todos = all(linha.get(c, False) for c in COLS)
        cells.append(MD_CELL["result"] if ok_todos else MD_CELL_ERR["result"])
        return "| " + " | ".join(cells) + " |"

    def cabecalho() -> list[str]:
        header = "| " + "arquivo".ljust(larg_arq) + " | " + " | ".join([MD_HEAD[c] for c in COLS] + [MD_HEAD["result"]]) + " |"
        sep = "| " + "-" * larg_arq + " | " + " | ".join(["-" * MD_SEP[c] for c in COLS] + ["-" * MD_SEP["result"]]) + " |"
        return [header, sep]

    items = list(results.items())
    linhas: list[str] = []
    for n_page in range(0, len(items), PAGE_SIZE):
        chunk = items[n_page: n_page + PAGE_SIZE]
        linhas.append(f"### Tabela de conformidade — página {n_page // PAGE_SIZE + 1}")
        linhas.append("")
        linhas.extend(cabecalho())
        for nome, linha in chunk:
            linhas.append(linha_md(nome, linha))
        linhas.append("")

    n = len(results)
    for c in COLS:
        total = totais[c]
        cor = MD_GREEN if total == n else MD_RED
        linhas.append(f"- {c.upper().rjust(4)} : {cor} {total:>4} of {n:>4} — {cor}")
    verde_cells = sum(totais[c] for c in COLS)
    total_cells = n * len(COLS)
    cor_final = MD_GREEN if verde_cells == total_cells else MD_RED
    linhas.append(f"- {'ALL'.rjust(4)} : {cor_final} {verde_cells:>4} of {total_cells:>4} — {cor_final}")
    linhas.append("")

    # --- Secao de Regressao ---
    regressoes: list[tuple[str, dict[str, bool], dict[str, bool]]] = []
    if old_results:
        for nome, linha_nova in results.items():
            if nome in old_results:
                linha_antiga = old_results[nome]
                if any(linha_antiga.get(c, False) and not linha_nova.get(c, False) for c in COLS):
                    regressoes.append((nome, linha_antiga, linha_nova))

    linhas.append("### Regressão:")
    linhas.append("")
    if regressoes:
        linhas.extend(cabecalho())
        for nome, l_old, l_new in regressoes:
            linhas.append(linha_md(nome, l_old))
            linhas.append(linha_md(nome, l_new))
        linhas.append("")
    else:
        linhas.append("Nenhuma regressão detectada.")
        linhas.append("")

    for nome, linha in results.items():
        if not all(linha.values()):
            linhas.extend(bloco_colunas(nome, outs[nome]))

    md_path.write_text("\n".join(linhas) + "\n", encoding="utf-8")
    print(f"Relatorio gerado: {md_path}")


def main() -> int:
    md_path = RAIZ / "backend_compliance.md"
    old_md_path = RAIZ / "backend_compliance_OLD.md"

    # Copia backend_compliance.md para backend_compliance_OLD.md antes de executar
    if md_path.exists():
        shutil.copyfile(md_path, old_md_path)
        print(f"Copiado: {md_path.name} -> {old_md_path.name}")

    old_results = ler_tabela_md(old_md_path) if old_md_path.exists() else {}

    limpar_t()

    for d in (T_FVMBC, T_LLVM, T_WAT, T_WASM):
        d.mkdir(parents=True, exist_ok=True)

    for nome, path in TOOLS.items():
        if not path:
            print(f"AVISO: ferramenta '{nome}' nao encontrada")

    flux_files = sorted(FLUX_DIR.glob("*.flux"))
    results: dict[str, dict[str, bool]] = {}
    outs: dict[str, dict[str, str | None]] = {}
    falhas = []

    for path in flux_files:
        nome = path.name
        stdin_text = stdin_para(path)
        linha: dict[str, bool] = {}
        outs[nome] = {}
        ref = BACKENDS["in"](path, stdin_text)
        outs[nome]["in"] = ref
        for col in COLS:
            if col == "in":
                linha[col] = ref is not None
            else:
                out = BACKENDS[col](path, stdin_text)
                outs[nome][col] = out
                ref_norm = normalizar_saida(ref.rstrip("\n")) if ref is not None else None
                out_norm = normalizar_saida(out.rstrip("\n")) if out is not None else None
                ok = ref_norm is not None and out_norm is not None and out_norm == ref_norm
                linha[col] = ok
                if not ok:
                    falhas.append((path.name, col, ref, out))
        results[path.name] = linha

    # --- tabela ---
    col_w = {c: max(len(c), 3) for c in COLS}
    larg = max(len(n) for n in results) if results else 7

    cab = "arquivo".ljust(larg) + "  " + "  ".join(c.rjust(col_w[c]) for c in COLS)
    print()
    print(cab)
    print("-" * len(cab))
    totais = {c: 0 for c in COLS}
    for nome, linha in results.items():
        cel = []
        for c in COLS:
            if linha[c]:
                totais[c] += 1
                cel.append(GREEN.rjust(col_w[c] + 4))
            else:
                cel.append(RED.rjust(col_w[c] + 4))
        print(nome.ljust(larg) + "    " + "    ".join(cel))
    print("-" * len(cab))

    ok_arquivos = sum(1 for linha in results.values() if all(linha.values()))
    print(f"{ok_arquivos}/{len(results)} arquivo(s) com todos os backends OK")
    for c in COLS:
        print(f"  {c}: {totais[c]}/{len(results)} OK")

    gerar_md(results, totais, md_path, outs, old_results)

    # Rastreamento de regressoes no terminal
    regressoes = [
        nome for nome, linha_nova in results.items()
        if nome in old_results and any(old_results[nome].get(c, False) and not linha_nova.get(c, False) for c in COLS)
    ]
    print()
    if not old_results:
        print("Rastreamento de regressão: Nenhum baseline anterior para comparação.")
    elif regressoes:
        print(f"ATENÇÃO: {len(regressoes)} regressão(ões) detectada(s) em relação ao OLD:")
        for r in regressoes:
            detalhes = [c for c in COLS if old_results[r].get(c, False) and not results[r].get(c, False)]
            print(f"  ❌ {r} regrediu em: {', '.join(detalhes)}")
    else:
        print("Rastreamento de regressão: ✅ Nenhuma regressão detectada em relação ao backend_compliance_OLD.md!")

    print()
    print("Legenda:  {} coincide com o interpretador   {} diverge ou falhou".format(GREEN, RED))
    if falhas:
        print("\nFalhas:")
        for nome, col, ref, out in falhas:
            if ref is None:
                detalhe = "referencia (in) falhou"
            elif out is None:
                detalhe = "sem saida/falhou"
            else:
                detalhe = "diverge"
            print(f"  {nome} [{col}] {detalhe}")
            if ref is not None and out is not None:
                for linha in diff_em_colunas(nome, col, ref, out):
                    print(linha)

    print()
    limpar_t()

    return 0


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    raise SystemExit(main())