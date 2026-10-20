"""Validador e Certificador de Conformidade dos 6 Backends TheFlux (Self-Hosted Nativo).

Backends (colunas da tabela): in, vm, vmr, llvm, wat, wasm
    in    interpretador AST/FMIR via compilador nativo self-hosted (bin/fluxc.exe) -> referencia
    vm    bytecode .fvmbc emitido via fluxc.exe e executado via bin/fluxvm.exe
    vmr   bytecode .fvmbc recarregado do disco e executado via bin/fluxvm.exe
    llvm  LLVM IR emitido via fluxc.exe -> clang -> executavel nativo
    wat   WAT emitido via fluxc.exe -> wat2wasm -> wasmer
    wasm  WASM binario emitido via fluxc.exe -> wasmer

Gera compliance_backend00.md com tabela de checks e totalizacao.
Baseline de regressao: compliance_backend01.md.

Uso: python compliance_backend.py [FILTRO] [--compiler PATH] [--out DIR] [--stdin 'k=texto']
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
from contextlib import redirect_stdout
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
SRC = RAIZ / "src"
BIN = RAIZ / "bin"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

FLUX_DIR = RAIZ / "flux"
T_FVMBC = RAIZ / "t_fvmbc"
T_LLVM = RAIZ / "t_llvm"
T_WAT = RAIZ / "t_wat"
T_WASM = RAIZ / "t_wasm"

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}


def ler_inputs_yaml(path: Path) -> list[str] | None:
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
    inputs = ler_inputs_yaml(path)
    if inputs is not None:
        return "\n".join(inputs) + "\n"
    return STDIN_MAP.get(path.name, "")


EXPECT_ERROR_RE = re.compile(r"^#L\s+EXPECT_ERROR:\s*([A-Z]{2,4}\d{3})", re.MULTILINE)


def obter_erro_esperado(path: Path) -> str | None:
    if not path.name.startswith("ExampleOfError"):
        return None
    try:
        content = path.read_text(encoding="utf-8")
        m = EXPECT_ERROR_RE.search(content)
        if m:
            return m.group(1).upper()
    except Exception:
        pass
    return None


PYTHON = sys.executable
os.environ["FLUX_CI"] = "1"
ENV = dict(os.environ, PYTHONPATH=str(SRC), PYTHONUTF8="1", PYTHONIOENCODING="utf-8", FLUX_CI="1")

T_DIRS = [
    T_FVMBC,
    T_LLVM,
    T_WAT,
    T_WASM,
    RAIZ / "t_benchmarks",
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


def resolver_compilador_selfhosted(custom_path: str | None = None) -> list[str]:
    if custom_path:
        p = Path(custom_path)
        if p.exists():
            return [str(p)]
    exe = BIN / "fluxc.exe"
    if exe.exists():
        return [str(exe)]
    raise FileNotFoundError(f"Compilador nativo TheFlux não encontrado em {exe}")


COMPILER_CMD = resolver_compilador_selfhosted()


def limpar_scratch_dbs() -> None:
    scratch = RAIZ / "scratch"
    if scratch.exists():
        for pat in ("flux_*.db*", "flux_*.kv", "flux_*.unqlite", "flux_*.duckdb", "flux_*.kuzu", "flux_*.obx"):
            for f in scratch.glob(pat):
                try:
                    f.unlink()
                except Exception:
                    pass


def limpar_t() -> None:
    for d in T_DIRS:
        if d.exists():
            for f in d.iterdir():
                if f.is_file() and f.name != ".gitkeep":
                    try:
                        f.unlink()
                    except Exception:
                        pass
    limpar_scratch_dbs()


MAX_CAPTURE_BYTES = 512 * 1024


def _kill_proc_tree(pid: int) -> None:
    try:
        if sys.platform == "win32":
            subprocess.run(["taskkill", "/F", "/T", "/PID", str(pid)], capture_output=True, timeout=3)
        else:
            import signal
            os.kill(pid, signal.SIGKILL)
    except Exception:
        pass


def _run(cmd: list[str], *, timeout: int = 10, input_text: str = "", cwd: Path | None = None) -> subprocess.CompletedProcess:
    try:
        proc = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            errors="replace",
            env=ENV,
            cwd=str(cwd) if cwd else None,
        )
        try:
            stdout, stderr = proc.communicate(input=input_text, timeout=timeout)
        except subprocess.TimeoutExpired:
            _kill_proc_tree(proc.pid)
            try:
                proc.kill()
            except Exception:
                pass
            try:
                stdout, stderr = proc.communicate(timeout=1)
            except Exception:
                stdout, stderr = "", "timeout"
            return subprocess.CompletedProcess(cmd, -1, (stdout or "")[:MAX_CAPTURE_BYTES], "timeout")

        if stdout and len(stdout) > MAX_CAPTURE_BYTES:
            stdout = stdout[:MAX_CAPTURE_BYTES]
        if stderr and len(stderr) > MAX_CAPTURE_BYTES:
            stderr = stderr[:MAX_CAPTURE_BYTES]
        return subprocess.CompletedProcess(cmd, proc.returncode, stdout, stderr)
    except Exception as e:
        return subprocess.CompletedProcess(cmd, -1, "", str(e))


def saida_interp(path: Path, stdin_text: str) -> str | None:
    exe = BIN / "fluxc.exe"
    if not exe.exists():
        return None
    r = _run([str(exe), "--target", "in", str(path.resolve())], input_text=stdin_text, timeout=10)
    if r.returncode != 0:
        return None
    return r.stdout


run_interpreter = saida_interp
obter_stdin_para_arquivo = stdin_para


def saida_vm(path: Path, stdin_text: str) -> str | None:
    out = _run(COMPILER_CMD + ["--target", "vmr", "-o", str(T_FVMBC / path.stem), str(path.resolve())], input_text=stdin_text, timeout=10)
    if out.returncode != 0:
        return None
    bc_path = T_FVMBC / (path.stem + ".fvmbc")
    return _executa_bc(bc_path, stdin_text)


def _executa_bc(bc_path: Path, stdin_text: str) -> str | None:
    if not bc_path.exists():
        return None
    fluxvm = BIN / "fluxvm.exe"
    if not fluxvm.exists():
        return None
    res = _run([str(fluxvm), "--inject", str(bc_path.resolve())], input_text=stdin_text, timeout=10)
    if res.returncode != 0 and not res.stdout:
        return None
    return res.stdout


def saida_vmr(path: Path, stdin_text: str) -> str | None:
    out = _run(COMPILER_CMD + ["--target", "vmr", "-o", str(T_FVMBC / path.stem), str(path.resolve())], input_text=stdin_text, timeout=10)
    if out.returncode != 0:
        return None
    bc_path = T_FVMBC / (path.stem + ".fvmbc")
    return _executa_bc(bc_path, stdin_text)


def saida_lv(path: Path, stdin_text: str) -> str | None:
    out = _run(COMPILER_CMD + ["--target", "llvm", "-o", str(T_LLVM / path.stem), str(path.resolve())], input_text=stdin_text, timeout=10)
    if out.returncode != 0:
        return None
    ll_path = T_LLVM / (path.stem + ".ll")
    if not ll_path.exists():
        ll_path = RAIZ / "intermediates" / "llvm" / (path.stem + ".ll")
    if not ll_path.exists():
        return None
    clang = TOOLS.get("clang")
    if not clang:
        return None
    exe_path = T_LLVM / (path.stem + ".exe")
    runtime_c = RAIZ / "runtime" / "flux_input.c"
    c = _run([clang, "-O2", "-Wno-deprecated-declarations", "-o", str(exe_path), str(ll_path), str(runtime_c)], timeout=10)
    if c.returncode != 0:
        import time
        time.sleep(0.5)
        c = _run([clang, "-O2", "-Wno-deprecated-declarations", "-o", str(exe_path), str(ll_path), str(runtime_c)], timeout=10)
        if c.returncode != 0:
            return None
    res = _run([str(exe_path)], input_text=stdin_text, timeout=10)
    if res.returncode != 0 and not res.stdout:
        import time
        time.sleep(0.5)
        res = _run([str(exe_path)], input_text=stdin_text, timeout=10)
    return res.stdout


def saida_wat(path: Path, stdin_text: str) -> str | None:
    out = _run(COMPILER_CMD + ["--target", "wat", "-o", str(T_WAT / path.stem), str(path.resolve())], input_text=stdin_text, timeout=10)
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
        c = _run([w2w, str(wat_path), "-o", str(bin_path)], timeout=10)
        if c.returncode != 0:
            return None
        return _run([wasmer, "run", "--forward-host-env", str(bin_path)], input_text=stdin_text, timeout=10).stdout


def saida_wasm(path: Path, stdin_text: str) -> str | None:
    out = _run(COMPILER_CMD + ["--target", "wasm", "-o", str(T_WASM / path.stem), str(path.resolve())], input_text=stdin_text, timeout=10)
    if out.returncode != 0:
        return None
    wasm_path = T_WASM / (path.stem + ".wasm")
    if not wasm_path.exists():
        return None
    wasmer = TOOLS.get("wasmer")
    if not wasmer:
        return None
    return _run([wasmer, "run", "--forward-host-env", str(wasm_path)], input_text=stdin_text, timeout=10).stdout


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
    if texto is None:
        return None
    return re.sub(r'(^|[^\w.])(-?0\.0+)(?=[^\w.]|$)', r'\g<1>0', texto)


def diff_em_colunas(nome: str, col: str, ref: str, out: str) -> list[str]:
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

    pos_items = [(n, l) for n, l in results.items() if not n.startswith("ExampleOfError")]
    err_items = [(n, l) for n, l in results.items() if n.startswith("ExampleOfError")]

    linhas: list[str] = []

    if pos_items:
        linhas.append("## 📦 Programas Regulares de Execução (Self-Hosted Compiler)")
        linhas.append("")
        for n_page in range(0, len(pos_items), PAGE_SIZE):
            chunk = pos_items[n_page: n_page + PAGE_SIZE]
            linhas.append(f"### Tabela de conformidade — página {n_page // PAGE_SIZE + 1}")
            linhas.append("")
            linhas.extend(cabecalho())
            for nome, linha in chunk:
                linhas.append(linha_md(nome, linha))
            linhas.append("")

    if err_items:
        linhas.append("## 🧪 Tabela de Conformidade — Testes de Diagnósticos e Erros (Negativos)")
        linhas.append("")
        linhas.append("> Testes de validação de diagnósticos estáticos canônicos e operações matemáticas de erro em runtime.")
        linhas.append("")
        linhas.extend(cabecalho())
        for nome, linha in err_items:
            linhas.append(linha_md(nome, linha))
        linhas.append("")

    n = len(results)
    pos_ok = sum(1 for _, l in pos_items if all(l.values()))
    err_ok = sum(1 for _, l in err_items if all(l.values()))
    linhas.append("### Resumo de Conformidade:")
    linhas.append("")
    if pos_items:
        cor_pos = MD_GREEN if pos_ok == len(pos_items) else MD_RED
        linhas.append(f"- {'POSITIVOS'.rjust(12)} : {cor_pos} {pos_ok:>4} of {len(pos_items):>4} — {cor_pos}")
    if err_items:
        cor_err = MD_GREEN if err_ok == len(err_items) else MD_RED
        linhas.append(f"- {'DIAGNÓSTICO'.rjust(12)} : {cor_err} {err_ok:>4} of {len(err_items):>4} — {cor_err}")

    for c in COLS:
        total = totais[c]
        cor = MD_GREEN if total == n else MD_RED
        linhas.append(f"- {c.upper().rjust(12)} : {cor} {total:>4} of {n:>4} — {cor}")

    verde_cells = sum(totais[c] for c in COLS)
    total_cells = n * len(COLS)
    cor_final = MD_GREEN if verde_cells == total_cells else MD_RED
    linhas.append(f"- {'TOTAL GERAL'.rjust(12)} : {cor_final} {verde_cells:>4} of {total_cells:>4} — {cor_final}")
    linhas.append("")

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
    print(f"Relatório gerado: {md_path}")


def main() -> int:
    if any(a in ("-h", "--help") for a in sys.argv[1:]):
        print(__doc__)
        return 0

    filter_arg = None
    compiler_arg = None
    force = False
    incremental = False
    write_md = False
    i = 1
    while i < len(sys.argv):
        a = sys.argv[i]
        if a == "--compiler" and i + 1 < len(sys.argv):
            compiler_arg = sys.argv[i + 1]
            i += 2
            continue
        elif a == "--force":
            force = True
        elif a == "--incremental":
            incremental = True
        elif a in ("--write-md", "-w"):
            write_md = True
        elif a in ("--modular", "--stdlib"):
            filter_arg = a
        elif not a.startswith("--"):
            filter_arg = a
        i += 1

    global COMPILER_CMD
    if compiler_arg:
        COMPILER_CMD = resolver_compilador_selfhosted(compiler_arg)

    md_path = RAIZ / "compliance_BE00.md"
    old_md_path = RAIZ / "compliance_BE01.md"

    is_full_canonical = not filter_arg or filter_arg in ("flux", "flux/", str(FLUX_DIR), str(FLUX_DIR.resolve()))

    if is_full_canonical and md_path.exists():
        shutil.copyfile(md_path, old_md_path)
        print(f"Copiado: {md_path.name} -> {old_md_path.name}")

    old_results = ler_tabela_md(old_md_path) if old_md_path.exists() else {}
    if len(old_results) < 50:
        for legacy_md in (RAIZ / "compliance_backend00.md", md_path):
            if legacy_md.exists():
                cur_results = ler_tabela_md(legacy_md)
                if len(cur_results) > len(old_results):
                    old_results = cur_results
        if len(cur_results) > len(old_results):
            old_results = cur_results

    limpar_t()

    for d in (T_FVMBC, T_LLVM, T_WAT, T_WASM):
        d.mkdir(parents=True, exist_ok=True)

    for nome, path in TOOLS.items():
        if not path:
            print(f"AVISO: ferramenta '{nome}' nao encontrada")

    flux_files = sorted(FLUX_DIR.glob("*.flux"))
    if filter_arg:
        exact_p = Path(filter_arg)
        if exact_p.is_file():
            flux_files = [exact_p]
        elif exact_p.is_dir():
            files = list(exact_p.glob("*.flux"))
            if not files:
                files = list(exact_p.rglob("*.flux"))
            flux_files = sorted(files)
        elif filter_arg in ("--stdlib", "--modular", "modular", "stdlib"):
            flux_files = [f for f in flux_files if "StdLib" in f.name or "Modular" in f.name]
        else:
            target = exact_p.name.lower()
            flux_files = [f for f in flux_files if target in f.name.lower()]
        print(f"Executando filtro '{filter_arg}': {len(flux_files)} arquivo(s) encontrado(s)")
    results: dict[str, dict[str, bool]] = {}
    outs: dict[str, dict[str, str | None]] = {}
    falhas = []
    testados = 0
    pulados = 0

    for path in flux_files:
        nome = path.name

        if (incremental or not force) and nome in old_results and all(old_results[nome].get(c, False) for c in COLS):
            results[nome] = old_results[nome]
            pulados += 1
            continue

        testados += 1
        if testados % 25 == 0 or testados == len(flux_files):
            print(f"  ⚡ Processados: {testados}/{len(flux_files)} arquivos...", flush=True)

        nome = path.name
        stdin_text = stdin_para(path)
        linha: dict[str, bool] = {}
        outs[nome] = {}
        expected_code = obter_erro_esperado(path)

        if expected_code:
            r_in = _run(COMPILER_CMD + ["--target", "in", str(path.resolve())], input_text=stdin_text)
            ok_in = (r_in.returncode != 0) and (f"[{expected_code} - " in r_in.stderr or expected_code in r_in.stdout or expected_code in r_in.stderr)
            linha["in"] = ok_in
            outs[nome]["in"] = f"[{expected_code} capturado]" if ok_in else r_in.stderr

            r_vm = _run(COMPILER_CMD + ["--target", "vmr", "-o", str(T_FVMBC / path.stem), str(path.resolve())], input_text=stdin_text)
            ok_vm = (r_vm.returncode != 0) and (f"[{expected_code} - " in r_vm.stderr or expected_code in r_vm.stdout or expected_code in r_vm.stderr)
            linha["vm"] = ok_vm
            outs[nome]["vm"] = f"[{expected_code} capturado]" if ok_vm else r_vm.stderr
            linha["vmr"] = ok_vm
            outs[nome]["vmr"] = outs[nome]["vm"]

            r_lv = _run(COMPILER_CMD + ["--target", "llvm", "-o", str(T_LLVM / path.stem), str(path.resolve())], input_text=stdin_text)
            ok_lv = (r_lv.returncode != 0) and (f"[{expected_code} - " in r_lv.stderr or expected_code in r_lv.stdout or expected_code in r_lv.stderr)
            linha["llvm"] = ok_lv
            outs[nome]["llvm"] = f"[{expected_code} capturado]" if ok_lv else r_lv.stderr

            r_wat = _run(COMPILER_CMD + ["--target", "wat", "-o", str(T_WAT / path.stem), str(path.resolve())], input_text=stdin_text)
            ok_wat = (r_wat.returncode != 0) and (f"[{expected_code} - " in r_wat.stderr or expected_code in r_wat.stdout or expected_code in r_wat.stderr)
            linha["wat"] = ok_wat
            outs[nome]["wat"] = f"[{expected_code} capturado]" if ok_wat else r_wat.stderr

            r_wasm = _run(COMPILER_CMD + ["--target", "wasm", "-o", str(T_WASM / path.stem), str(path.resolve())], input_text=stdin_text)
            ok_wasm = (r_wasm.returncode != 0) and (f"[{expected_code} - " in r_wasm.stderr or expected_code in r_wasm.stdout or expected_code in r_wasm.stderr)
            linha["wasm"] = ok_wasm
            outs[nome]["wasm"] = f"[{expected_code} capturado]" if ok_wasm else r_wasm.stderr

            for col in COLS:
                if not linha[col]:
                    falhas.append((path.name, col, f"esperava [{expected_code}]", outs[nome][col]))
            results[path.name] = linha
        else:
            if nome.startswith("ExampleOfUseDbStdLib_"):
                limpar_scratch_dbs()
            ref = BACKENDS["in"](path, stdin_text)
            outs[nome]["in"] = ref
            for col in COLS:
                if col == "in":
                    linha[col] = ref is not None
                else:
                    if nome.startswith("ExampleOfUseDbStdLib_"):
                        limpar_scratch_dbs()
                    out = BACKENDS[col](path, stdin_text)
                    outs[nome][col] = out
                    ref_norm = normalizar_saida(ref.rstrip("\n")) if ref is not None else None
                    out_norm = normalizar_saida(out.rstrip("\n")) if out is not None else None
                    ok = ref_norm is not None and out_norm is not None and out_norm == ref_norm
                    linha[col] = ok
                    if not ok:
                        falhas.append((path.name, col, ref, out))
            results[path.name] = linha
        import gc
        gc.collect()

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
    pos_items = [n for n in results if not n.startswith("ExampleOfError")]
    err_items = [n for n in results if n.startswith("ExampleOfError")]
    pos_ok = sum(1 for n in pos_items if all(results[n].values()))
    err_ok = sum(1 for n in err_items if all(results[n].values()))

    print(f"{ok_arquivos}/{len(results)} arquivo(s) com todos os backends OK")
    if pos_items and err_items:
        print(f"  - Programas regulares: {pos_ok}/{len(pos_items)} OK")
        print(f"  - Diagnósticos & erros: {err_ok}/{len(err_items)} OK")
    for c in COLS:
        print(f"  {c}: {totais[c]}/{len(results)} OK")

    if is_full_canonical or write_md:
        gerar_md(results, totais, md_path, outs, old_results)

    regressoes = [
        nome for nome, linha_nova in results.items()
        if nome in old_results and any(old_results[nome].get(c, False) and not linha_nova.get(c, False) for c in COLS)
    ]
    print()
    if not old_results:
        print("Rastreamento de regressão: Nenhum baseline anterior para comparação.")
    elif regressoes:
        print(f"ATENÇÃO: {len(regressoes)} regressão(ões) detectada(s) em relação ao compliance_backend01.md:")
        for r in regressoes:
            detalhes = [c for c in COLS if old_results[r].get(c, False) and not results[r].get(c, False)]
            print(f"  ❌ {r} regrediu em: {', '.join(detalhes)}")
    else:
        print("Rastreamento de regressão: ✅ Nenhuma regressão detectada em relação ao compliance_backend01.md!")

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
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    raise SystemExit(main())
