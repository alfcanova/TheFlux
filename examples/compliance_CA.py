"""Executor e validador de conformidade multi-backend para Canon (examples/Canon).

Executa a suite exclusivamente na arquitetura do compilador self-hosted
(`bin/fluxc.exe` + `wasmer` + `clang`/`lib/`) e compara as saidas contra `in`:

Colunas (5 backends agregados + result): in, vm, llvm, wat, was, result
    in     interpretador AST (fluxc --target in) -> referencia
    vm     vm + vmr: compila .fvmbc (fluxc --target vm) e executa (fluxc --target vmr)
    llvm   compila nativo (fluxc --target lv -> clang + lib/) e executa .exe
    wat    wat + watr: compila .wat (fluxc --target wat) e executa via wasmer
    was    was + wasr: compila .wasm (fluxc --target wasm) e executa via wasmer
    result verde apenas se todos os 5 backends forem aprovados

Baselines fixos em `examples/00_Standarts/compliance_XX00.md`.
Relatorios gerados em `examples/00_Standarts/compliance_XX01.md` com relatorio de regressao.

Uso:
    python examples/compliance_CA.py [--filter SUB] [--jobs N] [--no-md]
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
import difflib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from pathlib import Path
from typing import Callable

SCRIPT_DIR = Path(__file__).resolve().parent
RAIZ = SCRIPT_DIR if (SCRIPT_DIR / "examples").exists() else SCRIPT_DIR.parent
EXAMPLES_DIR = RAIZ / "examples"
CANON_DIR = EXAMPLES_DIR / "Canon"
STANDARTS_DIR = EXAMPLES_DIR / "00_Standarts"
BIN_DIR = RAIZ / "bin"
LIB_DIR = RAIZ / "lib"
TMP_BASE = RAIZ / "build" / "intermediates" / "tmp"
DBS_DIR = RAIZ / "dbs"

COLS = ["in", "vm", "llvm", "wat", "was"]

GREEN = "\033[92m✓\033[0m"
RED = "\033[91m✗\033[0m"
MD_GREEN = "✅"
MD_RED = "❌"

PAGE_SIZE = 10
CA_COL_WIDTH = 67

MD_CELL = {c: " ✅ " for c in COLS}
MD_CELL["result"] = "  ✅  "
MD_CELL_ERR = {c: " ❌ " for c in COLS}
MD_CELL_ERR["result"] = "  ❌  "
MD_HEAD = {
    "in": " in  ",
    "vm": " vm ",
    "llvm": "llvm",
    "wat": " wat",
    "was": " was",
    "result": "result",
}
MD_SEP = {
    "in": 5,
    "vm": 4,
    "llvm": 4,
    "wat": 4,
    "was": 4,
    "result": 6,
}

STDIN_MAP: dict[str, str] = {
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

EXPECT_ERROR_RE = re.compile(r"^#L\s+EXPECT_ERROR:\s*([A-Z]{2,4}\d{3})", re.MULTILINE)
FNAME_ERROR_RE = re.compile(r"^ExampleOfError_([A-Z]{2,4}\d{3})_")

os.environ["FLUX_CI"] = "1"
ENV = dict(
    os.environ,
    PYTHONUTF8="1",
    PYTHONIOENCODING="utf-8",
    PYTHONDONTWRITEBYTECODE="1",
    FLUX_CI="1",
)

_SHARED_IO_LOCK = threading.Lock()
_PRINT_LOCK = threading.Lock()
_DEFAULT_TMP_DIR: Path | None = None


def _find_tool(name: str, extra_dirs: list[Path]) -> str | None:
    """Localiza binario executavel no PATH ou em diretorios conhecidos."""
    p = shutil.which(name)
    if p:
        return p
    for d in extra_dirs:
        for cand_name in (name + ".exe", name):
            c = d / cand_name
            if c.exists():
                return str(c)
    return None


def discover_tools() -> dict[str, str | None]:
    """Localiza executaveis da toolchain self-hosted (fluxc, wasmer, clang)."""
    return {
        "fluxc": _find_tool("fluxc", [BIN_DIR]),
        "wasmer": _find_tool("wasmer", [Path.home() / ".wasmer" / "bin"]),
        "clang": _find_tool(
            "clang",
            [Path(r"C:\Program Files\LLVM\bin"), Path(r"C:\Arquivos de Programas\LLVM\bin")],
        ),
    }


TOOLS = discover_tools()


def _get_default_tmp_dir() -> Path:
    global _DEFAULT_TMP_DIR
    if _DEFAULT_TMP_DIR is None or not _DEFAULT_TMP_DIR.exists():
        TMP_BASE.mkdir(parents=True, exist_ok=True)
        _DEFAULT_TMP_DIR = Path(tempfile.mkdtemp(prefix="cmp_adhoc_", dir=str(TMP_BASE)))
    return _DEFAULT_TMP_DIR


def ler_inputs_yaml(path: Path) -> list[str] | None:
    """Le os `inputs` declarados em `<stem>.yaml` companheiro do arquivo `.flux`."""
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
    """Determina o stdin a injetar para um arquivo `.flux`."""
    inputs = ler_inputs_yaml(path)
    if inputs is not None:
        return "\n".join(inputs) + "\n"
    return STDIN_MAP.get(path.name, "")


obter_stdin_para_arquivo = stdin_para


def obter_erro_esperado(path: Path) -> str | None:
    """Extrai codigo de erro estatico esperado; exclui testes de runtime (`RT*`)."""
    if not path.name.startswith("ExampleOfError"):
        return None
    if path.name.startswith("ExampleOfError_RT"):
        return None
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
        m = EXPECT_ERROR_RE.search(content)
        if m:
            code = m.group(1).upper()
            return None if code.startswith("RT") else code
    except Exception:
        pass
    m_fn = FNAME_ERROR_RE.match(path.name)
    if m_fn:
        code = m_fn.group(1).upper()
        return None if code.startswith("RT") else code
    return None


def limpar_scratch_dbs() -> None:
    """Remove artefatos temporarios de banco de dados em `dbs/`, preservando `.gitkeep`."""
    if not DBS_DIR.exists():
        return
    for entry in DBS_DIR.iterdir():
        if entry.name == ".gitkeep":
            continue
        try:
            if entry.is_dir():
                shutil.rmtree(entry, ignore_errors=True)
            else:
                entry.unlink()
        except Exception:
            pass


limpar_dbs = limpar_scratch_dbs


def limpar_io_temporarios() -> None:
    """Remove restos temporarios gerados por testes `IoStdLib`, mantendo a fixture."""
    for rel in ("io_stdlib_copy.txt", "io_stdlib_moved.txt", "io_stdlib_lines.txt", "io_stdlib_test_dir"):
        target = RAIZ / rel
        if not target.exists():
            continue
        try:
            if target.is_dir():
                shutil.rmtree(target, ignore_errors=True)
            else:
                target.unlink()
        except Exception:
            pass


def garantir_fixture_io() -> None:
    """Garante existencia de `io_stdlib_fixture.txt` na raiz."""
    fix = RAIZ / "io_stdlib_fixture.txt"
    if not fix.exists():
        fix.write_text("conteudo fixture io_stdlib\n", encoding="utf-8")


def limpar_t(tmp_dir: Path | None = None) -> None:
    """Limpa temporarios da rodada (`build/intermediates/tmp/...` e `dbs/`), preservando `t_*`."""
    limpar_scratch_dbs()
    limpar_io_temporarios()
    garantir_fixture_io()
    if tmp_dir is not None and tmp_dir.exists():
        shutil.rmtree(tmp_dir, ignore_errors=True)


def _needs_serial(fname: str) -> bool:
    return any(
        tok in fname
        for tok in ("DbStdLib", "IoStdLib", "ArchiveStdLib", "FileSignatureStdLib", "CompressStdLib", "FvmClient")
    )


def _run(
    cmd: list[str],
    *,
    timeout: int = 60,
    input_text: str = "",
    cwd: Path | None = None,
) -> subprocess.CompletedProcess:
    try:
        return subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=timeout,
            env=ENV,
            input=input_text,
            cwd=str(cwd or RAIZ),
        )
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(cmd, -1, "", "timeout")
    except OSError as exc:
        return subprocess.CompletedProcess(cmd, -1, "", str(exc))


def _fluxc_bin() -> str | None:
    return TOOLS.get("fluxc") or _find_tool("fluxc", [BIN_DIR])


def _run_wasmer(artifact_path: Path, stdin_text: str) -> tuple[bool, str, str]:
    wasmer = TOOLS.get("wasmer")
    if not wasmer:
        return False, "", "wasmer nao encontrado"
    res = _run([wasmer, "run", "--forward-host-env", str(artifact_path)], input_text=stdin_text, timeout=30)
    if res.returncode == 0:
        return True, res.stdout, ""
    detail = _one_line((res.stderr or "") + "\n" + (res.stdout or ""))
    return False, res.stdout, f"EXEC_FAIL(rc={res.returncode}): {detail}"


def _one_line(text: str, max_len: int = 90) -> str:
    clean = " ".join(text.replace("\r", "\n").split())
    return clean[:max_len] if len(clean) > max_len else clean


# ---------------------------------------------------------------------------
# Execucao de backends — Compilador Self-Hosted (bin/fluxc.exe)
# ---------------------------------------------------------------------------

def _fluxc_run_backend_detailed(
    path: Path,
    col: str,
    stdin_text: str,
    work_dir: Path,
) -> tuple[bool, str | None, str]:
    """Executa compilacao/execucao de um backend self-hosted.

    Retorna `(exec_ok, stdout_ou_None, motivo_curto)`.
    """
    fluxc = _fluxc_bin()
    if not fluxc:
        return False, None, "fluxc nao encontrado em bin/"
    work_dir.mkdir(parents=True, exist_ok=True)
    stem = path.stem

    if col == "in":
        r = _run([fluxc, "--target", "in", str(path)], input_text=stdin_text)
        if r.returncode == 0:
            return True, r.stdout, "OK"
        return False, None, f"EXEC_FAIL(rc={r.returncode}): {_one_line((r.stderr or '') + ' ' + (r.stdout or ''))}"

    if col == "vm":
        # Etapa 1 (vm): compila para bytecode .fvmbc
        out_base = work_dir / f"{stem}_vm"
        fvmbc = Path(str(out_base) + ".fvmbc")
        c = _run([fluxc, "--no-run", "--target", "vm", "-o", str(out_base), str(path)])
        if c.returncode != 0 or not fvmbc.exists():
            return False, None, f"COMP_FAIL[vm](rc={c.returncode}): {_one_line((c.stderr or '') + ' ' + (c.stdout or ''))}"
        # Etapa 2 (vmr): carrega .fvmbc do disco e executa na VM
        r = _run([fluxc, "--target", "vmr", str(fvmbc)], input_text=stdin_text, timeout=30)
        if r.returncode != 0:
            return False, None, f"EXEC_FAIL[vmr](rc={r.returncode}): {_one_line((r.stderr or '') + ' ' + (r.stdout or ''))}"
        return True, r.stdout, "OK"

    if col == "llvm":
        out_base = work_dir / f"{stem}_lv"
        exe_path = Path(str(out_base) + ".exe")
        c = _run([fluxc, "--no-run", "--target", "lv", "-o", str(out_base), str(path)], timeout=60)
        if c.returncode != 0 or not exe_path.exists():
            return False, None, f"COMP_FAIL(rc={c.returncode}): {_one_line((c.stderr or '') + ' ' + (c.stdout or ''))}"
        r = _run([str(exe_path)], input_text=stdin_text, timeout=30)
        if r.returncode != 0 and not r.stdout:
            time.sleep(0.25)
            r = _run([str(exe_path)], input_text=stdin_text, timeout=30)
        if r.returncode != 0:
            return False, None, f"EXEC_FAIL(rc={r.returncode}): {_one_line((r.stderr or '') + ' ' + (r.stdout or ''))}"
        return True, r.stdout, "OK"

    if col == "wat":
        out_base = work_dir / f"{stem}_wat"
        wat_path = Path(str(out_base) + ".wat")
        c = _run([fluxc, "--no-run", "--target", "wat", "-o", str(out_base), str(path)], timeout=60)
        if c.returncode != 0 or not wat_path.exists():
            return False, None, f"COMP_FAIL[wat](rc={c.returncode}): {_one_line((c.stderr or '') + ' ' + (c.stdout or ''))}"
        ok_w, out_w, reason_w = _run_wasmer(wat_path, stdin_text)
        return (True, out_w, "OK") if ok_w else (False, None, reason_w)

    if col == "was":
        out_base = work_dir / f"{stem}_was"
        wasm_path = Path(str(out_base) + ".wasm")
        c = _run([fluxc, "--no-run", "--target", "wasm", "-o", str(out_base), str(path)], timeout=60)
        if c.returncode != 0 or not wasm_path.exists():
            return False, None, f"COMP_FAIL[was](rc={c.returncode}): {_one_line((c.stderr or '') + ' ' + (c.stdout or ''))}"
        ok_w, out_w, reason_w = _run_wasmer(wasm_path, stdin_text)
        return (True, out_w, "OK") if ok_w else (False, None, reason_w)

    return False, None, f"backend desconhecido: {col}"


def _fluxc_check_static_error(
    path: Path,
    col: str,
    expected_code: str,
    stdin_text: str,
    work_dir: Path,
) -> tuple[bool, str]:
    fluxc = _fluxc_bin()
    if not fluxc:
        return False, "fluxc nao encontrado em bin/"
    work_dir.mkdir(parents=True, exist_ok=True)
    targets_by_col = {
        "in": ("in",),
        "vm": ("vm", "vmr"),
        "llvm": ("lv",),
        "wat": ("wat",),
        "was": ("wasm",),
    }
    for target_flag in targets_by_col[col]:
        if target_flag == "in":
            cmd = [fluxc, "--target", "in", str(path)]
        else:
            out_base = work_dir / f"{path.stem}_{target_flag}"
            cmd = [fluxc, "--no-run", "--target", target_flag, "-o", str(out_base), str(path)]
        r = _run(cmd, input_text=stdin_text)
        combined = (r.stdout or "") + "\n" + (r.stderr or "")
        matched = (r.returncode != 0) and (
            f"[{expected_code} - " in combined or f"[{expected_code}]" in combined
        )
        if not matched:
            return False, f"{target_flag}: {_one_line(combined) or f'rc={r.returncode}'}"
    return True, f"[{expected_code} capturado]"


def _run_backend_simple(path: Path, col: str, stdin_text: str) -> str | None:
    ok, out, _ = _fluxc_run_backend_detailed(path, col, stdin_text, _get_default_tmp_dir())
    return out if ok else None


def saida_interp(path: Path, stdin_text: str = "") -> str | None:
    return _run_backend_simple(path, "in", stdin_text)


run_interpreter = saida_interp


def saida_vm(path: Path, stdin_text: str = "") -> str | None:
    return _run_backend_simple(path, "vm", stdin_text)


def saida_lv(path: Path, stdin_text: str = "") -> str | None:
    return _run_backend_simple(path, "llvm", stdin_text)


def saida_wat(path: Path, stdin_text: str = "") -> str | None:
    return _run_backend_simple(path, "wat", stdin_text)


def saida_was(path: Path, stdin_text: str = "") -> str | None:
    return _run_backend_simple(path, "was", stdin_text)


BACKENDS = {
    "in": lambda p, s: saida_interp(p, s),
    "vm": lambda p, s: saida_vm(p, s),
    "llvm": lambda p, s: saida_lv(p, s),
    "wat": lambda p, s: saida_wat(p, s),
    "was": lambda p, s: saida_was(p, s),
}


# ---------------------------------------------------------------------------
# Normalizacao, Diffs e Parsing/Formatacao Markdown (5 colunas + result)
# ---------------------------------------------------------------------------

def normalizar_saida(texto: str | None) -> str | None:
    """Normaliza fins de linha e zeros flutuantes isolados (`0.0`/`-0.0` -> `0`)."""
    if texto is None:
        return None
    clean = texto.replace("\r\n", "\n").replace("\r", "\n")
    return re.sub(r"(^|[^\w.])(-?0\.0+)(?=[^\w.]|$)", r"\g<1>0", clean)


def diff_em_colunas(nome: str, col: str, ref: str, out: str) -> list[str]:
    """Devolve linhas divergentes alinhadas em duas colunas (`in` vs backend)."""
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


def _first_diff_preview(ref_norm: str, out_norm: str) -> str:
    rl = ref_norm.splitlines()
    ol = out_norm.splitlines()
    limit = min(len(rl), len(ol))
    for i in range(limit):
        if rl[i] != ol[i]:
            return f"linha {i + 1}: esperado '{_one_line(rl[i], 35)}', obtido '{_one_line(ol[i], 35)}'"
    return f"linhas: esperado {len(rl)}, obtido {len(ol)}"


def ler_tabela_md(md_path: Path) -> dict[str, dict[str, bool]]:
    """Le arquivo markdown de conformidade (7 cols self-hosted ou 8 cols legado).

    Baselines legados de 8 colunas (`in, vm, vmr, llvm, wat, wasm, result`) tem
    `vm` e `vmr` agregados como `vm = vm and vmr`.
    """
    if not md_path.exists():
        return {}
    res: dict[str, dict[str, bool]] = {}
    for line in md_path.read_text(encoding="utf-8").splitlines():
        line_s = line.strip()
        if not line_s.startswith("|") or line_s.startswith("| arquivo") or line_s.startswith("| -"):
            continue
        parts = [p.strip() for p in line_s.split("|")[1:-1]]
        if not parts or not parts[0].endswith(".flux"):
            continue
        nome = parts[0]
        if nome in res:
            continue
        if len(parts) == 8:
            res[nome] = {
                "in": "✅" in parts[1],
                "vm": ("✅" in parts[2]) and ("✅" in parts[3]),
                "llvm": "✅" in parts[4],
                "wat": "✅" in parts[5],
                "was": "✅" in parts[6],
            }
        elif len(parts) == 7:
            res[nome] = {
                "in": "✅" in parts[1],
                "vm": "✅" in parts[2],
                "llvm": "✅" in parts[3],
                "wat": "✅" in parts[4],
                "was": "✅" in parts[5],
            }
    return res


def detectar_regressoes(
    results: dict[str, dict[str, bool]],
    baseline: dict[str, dict[str, bool]],
) -> list[tuple[str, dict[str, bool], dict[str, bool]]]:
    """Identifica arquivos que passaram em um backend no baseline e falharam agora."""
    regressoes: list[tuple[str, dict[str, bool], dict[str, bool]]] = []
    if not baseline:
        return regressoes
    for nome, nova in results.items():
        antiga = baseline.get(nome)
        if antiga and any(antiga.get(c, False) and not nova.get(c, False) for c in COLS):
            regressoes.append((nome, antiga, nova))
    return regressoes


# ---------------------------------------------------------------------------
# Avaliacao unitaria (segura para execucao sequencial ou paralela)
# ---------------------------------------------------------------------------

def avaliar_arquivo(
    path: Path,
    work_dir: Path,
) -> tuple[dict[str, bool], dict[str, str | None], list[tuple[str, str, str | None, str | None]], str]:
    """Executa todos os 5 backends agregados para um arquivo `.flux`."""
    nome = path.name
    stdin_text = stdin_para(path)
    expected_code = obter_erro_esperado(path)
    linha: dict[str, bool] = {}
    out_map: dict[str, str | None] = {}
    falhas_local: list[tuple[str, str, str | None, str | None]] = []
    notes: list[str] = []

    def _run_locked_if_needed(fn: Callable[[], object]) -> object:
        if _needs_serial(nome):
            with _SHARED_IO_LOCK:
                return fn()
        return fn()

    if expected_code:
        for col in COLS:
            ok, detail = _run_locked_if_needed(
                lambda c=col: _fluxc_check_static_error(path, c, expected_code, stdin_text, work_dir)
            )
            linha[col] = bool(ok)
            out_map[col] = str(detail)
            if not ok:
                falhas_local.append((nome, col, f"esperava [{expected_code}]", str(detail)))
                notes.append(f"{col}: ERR_MISMATCH({detail})")
        return linha, out_map, falhas_local, " ; ".join(notes)

    def _exec_positive() -> None:
        if "DbStdLib" in nome:
            limpar_scratch_dbs()
        ok_ref, ref, reason_ref = _fluxc_run_backend_detailed(path, "in", stdin_text, work_dir)
        out_map["in"] = ref if ok_ref else None
        linha["in"] = ok_ref
        if not ok_ref or ref is None:
            falhas_local.append((nome, "in", None, None))
            notes.append(f"in: {reason_ref}")
        ref_norm = normalizar_saida(ref.rstrip()) if ok_ref and ref is not None else None

        for col in COLS:
            if col == "in":
                continue
            if "DbStdLib" in nome:
                limpar_scratch_dbs()
            ok_run, out, reason_run = _fluxc_run_backend_detailed(path, col, stdin_text, work_dir)
            out_map[col] = out if ok_run else None
            out_norm = normalizar_saida(out.rstrip()) if ok_run and out is not None else None
            if not ok_run or out_norm is None:
                linha[col] = False
                falhas_local.append((nome, col, ref, None))
                notes.append(f"{col}: {reason_run}")
            elif ref_norm is None:
                linha[col] = False
                falhas_local.append((nome, col, None, out))
                notes.append(f"{col}: NO_IN_REF")
            elif out_norm != ref_norm:
                linha[col] = False
                falhas_local.append((nome, col, ref, out))
                notes.append(f"{col}: OUT_DIFF({_first_diff_preview(ref_norm, out_norm)})")
            else:
                linha[col] = True

        if "DbStdLib" in nome:
            limpar_scratch_dbs()
        elif "IoStdLib" in nome:
            limpar_io_temporarios()

    _run_locked_if_needed(_exec_positive)
    return linha, out_map, falhas_local, " ; ".join(notes)


# ---------------------------------------------------------------------------
# Relatorio de Regressao Unificado (`XX00.md` -> `XX01.md`)
# ---------------------------------------------------------------------------

def _fmt_rel_display(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(RAIZ.resolve())).replace("\\", "/")
    except ValueError:
        return str(path)


def _metric_row(label: str, old_val: int, old_tot: int, new_val: int, new_tot: int) -> str:
    diff = new_val - old_val
    d_str = "=" if diff == 0 else (f"+{diff}" if diff > 0 else str(diff))
    return f"| {label:<8} | {f'{old_val}/{old_tot}':>11} | {f'{new_val}/{new_tot}':>11} | {d_str:>6} |"


def _build_regression_lines(
    results: dict[str, dict[str, bool]],
    baseline_results: dict[str, dict[str, bool]],
    base_md: Path,
    out_md: Path,
    fail_notes: dict[str, str],
) -> tuple[list[str], list[tuple[str, dict[str, bool], dict[str, bool]]]]:
    """Monta secao completa de regressao comparando XX01.md contra a baseline fixa XX00.md."""
    base_rel = _fmt_rel_display(base_md)
    out_rel = _fmt_rel_display(out_md)
    lines: list[str] = [
        "",
        "## 📊 Relatório de Regressão vs Baseline Fixa",
        "",
        f"- **Baseline de referência (fixa):** `{base_rel}`",
        f"- **Relatório atual:** `{out_rel}`",
    ]
    regressoes = detectar_regressoes(results, baseline_results)

    if not baseline_results:
        lines.extend([
            "",
            f"> ⚠️ Arquivo baseline `{base_rel}` não encontrado; comparação de regressão indisponível.",
        ])
    else:
        base_tot = len(baseline_results)
        cur_tot = len(results)
        lines.extend([
            "",
            "| Métrica  | Baseline 00 | Atual 01    | Delta  |",
            "| -------- | ----------- | ----------- | ------ |",
        ])
        for col in COLS:
            old_v = sum(1 for r in baseline_results.values() if r.get(col, False))
            new_v = sum(1 for r in results.values() if r.get(col, False))
            lines.append(_metric_row(col, old_v, base_tot, new_v, cur_tot))
        old_res = sum(1 for r in baseline_results.values() if all(r.get(c, False) for c in COLS))
        new_res = sum(1 for r in results.values() if all(r.get(c, False) for c in COLS))
        lines.append(_metric_row("result", old_res, base_tot, new_res, cur_tot))

        reg_items: list[str] = []
        imp_items: list[str] = []
        added_files: list[str] = []
        removed_files = [f"`{fn}`" for fn in baseline_results if fn not in results]

        for fn, cur in results.items():
            old = baseline_results.get(fn)
            if old is None:
                added_files.append(f"`{fn}`")
                continue
            cur_res = all(cur.get(c, False) for c in COLS)
            old_res_fn = all(old.get(c, False) for c in COLS)
            regs_fn: list[str] = []
            imps_fn: list[str] = []
            for key, cur_ok, old_ok in [(c, cur.get(c, False), old.get(c, False)) for c in COLS] + [("result", cur_res, old_res_fn)]:
                if old_ok and not cur_ok:
                    regs_fn.append(f"{key}: ✅→❌")
                elif not old_ok and cur_ok:
                    imps_fn.append(f"{key}: ❌→✅")
            if regs_fn:
                reg_items.append(f"`{fn}` ({', '.join(regs_fn)})")
            if imps_fn:
                imp_items.append(f"`{fn}` ({', '.join(imps_fn)})")

        lines.extend(["", f"### ❌ Regressões Detectadas (✅ → ❌): {len(reg_items)}", ""])
        if reg_items:
            lines.extend([f"- {item}" for item in reg_items])
        else:
            lines.append(f"Nenhuma regressão detectada em relação à baseline `{base_rel}`.")

        lines.extend(["", f"### ✅ Melhorias Detectadas (❌ → ✅): {len(imp_items)}", ""])
        if imp_items:
            lines.extend([f"- {item}" for item in imp_items])
        else:
            lines.append("Nenhuma melhoria pontual em relação à baseline.")

        if added_files or removed_files:
            lines.extend(["", "### 📂 Diferenças de Conjunto de Arquivos vs Baseline", ""])
            if added_files:
                lines.append(f"- **Adicionados ({len(added_files)}):** {', '.join(added_files)}")
            if removed_files:
                lines.append(f"- **Removidos ({len(removed_files)}):** {', '.join(removed_files)}")

    fail_lines = [f"`{fn}`: {fail_notes[fn]}" for fn in results if fn in fail_notes and fail_notes[fn]]
    if fail_lines:
        lines.extend(["", f"### 🔍 Detalhamento de Falhas e Divergências vs `in` ({len(fail_lines)} arquivo(s))", ""])
        lines.extend([f"- {fl}" for fl in fail_lines])

    return lines, regressoes


# ---------------------------------------------------------------------------
# Geracao de relatorio Canon (`compliance_CA01.md` vs `compliance_CA00.md`)
# ---------------------------------------------------------------------------

def gerar_md(
    results: dict[str, dict[str, bool]],
    totais: dict[str, int],
    md_path: Path,
    fail_notes: dict[str, str],
    baseline_results: dict[str, dict[str, bool]] | None = None,
    base_md_path: Path | None = None,
) -> list[tuple[str, dict[str, bool], dict[str, bool]]]:
    """Gera `compliance_CA01.md` com 5 colunas agregadas + `result` e relatorio de regressao."""
    larg_arq = max([len(n) for n in results] + [CA_COL_WIDTH])

    def linha_md(nome: str, linha: dict[str, bool]) -> str:
        cells = [nome.ljust(larg_arq)]
        for c in COLS:
            cells.append(MD_CELL[c] if linha.get(c, False) else MD_CELL_ERR[c])
        cells.append(MD_CELL["result"] if all(linha.get(c, False) for c in COLS) else MD_CELL_ERR["result"])
        return "| " + " | ".join(cells) + " |"

    def cabecalho() -> list[str]:
        header = "| " + "arquivo".ljust(larg_arq) + " | " + " | ".join([MD_HEAD[c] for c in COLS] + [MD_HEAD["result"]]) + " |"
        sep = "| " + "-" * larg_arq + " | " + " | ".join(["-" * MD_SEP[c] for c in COLS] + ["-" * MD_SEP["result"]]) + " |"
        return [header, sep]

    pos_items = [(n, l) for n, l in results.items() if not n.startswith("ExampleOfError")]
    err_items = [(n, l) for n, l in results.items() if n.startswith("ExampleOfError")]

    linhas: list[str] = []
    if pos_items:
        linhas.append("## 📦 Programas Regulares de Execução")
        linhas.append("")
        for n_page in range(0, len(pos_items), PAGE_SIZE):
            chunk = pos_items[n_page : n_page + PAGE_SIZE]
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

    reg_lines, regressoes = _build_regression_lines(
        results,
        baseline_results or {},
        base_md_path or (STANDARTS_DIR / "compliance_CA00.md"),
        md_path,
        fail_notes,
    )
    linhas.extend(reg_lines)

    md_path.parent.mkdir(parents=True, exist_ok=True)
    md_path.write_text("\n".join(linhas) + "\n", encoding="utf-8")
    print(f"Relatorio gerado: {md_path}")
    return regressoes


# ---------------------------------------------------------------------------
# Runner compartilhado para suites agrupadas (compliance_NR / compliance_SA)
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class GroupedSuiteConfig:
    suite_name: str
    suite_label: str
    suite_dir: Path
    base_md: Path
    out_md: Path
    category_titles: dict[str, str]
    fallback_prefix: str
    col_name_width: int = 77
    md_header_lines: tuple[str, ...] = ()
    trailing_group_blank_lines: int = 1
    include_consolidated_heading: bool = False
    summary_blank_lines: int = 1
    show_progress_per_item: bool = False


def formatar_linha_md_agrupada(fname: str, linha: dict[str, bool], col_width: int = 77) -> str:
    """Formata linha da tabela Markdown de 5 colunas + result para suites NR/SA."""
    cells = [f"  {'✅' if linha.get(c, False) else '❌'}  " for c in COLS]
    all_ok = all(linha.get(c, False) for c in COLS)
    res_icon = "   ✅   " if all_ok else "   ❌   "
    return f"| {fname:<{col_width}} |" + "|".join(cells) + f"|{res_icon}|\n"


def _gerar_grouped_md(
    cfg: GroupedSuiteConfig,
    results: dict[str, dict[str, bool]],
    all_flux_files: list[Path],
    baseline_results: dict[str, dict[str, bool]],
    fail_notes: dict[str, str],
) -> list[tuple[str, dict[str, bool], dict[str, bool]]]:
    cat_files: dict[str, list[tuple[str, Path]]] = {}
    suite_root = cfg.suite_dir.resolve()
    for path in all_flux_files:
        rel = path.resolve().relative_to(suite_root)
        cat_key = rel.parts[0] if len(rel.parts) > 1 else "geral"
        cat_files.setdefault(cat_key, []).append((path.name, path))

    w = cfg.col_name_width
    header = (
        f"| {'arquivo':<{w}} |  in   |  vm  | llvm |  wat |  was | result |\n"
        f"| {'-' * w} | ----- | ---- | ---- | ---- | ---- | ------ |\n"
    )
    linhas: list[str] = list(cfg.md_header_lines)
    totais = {c: 0 for c in COLS}
    total_checks = 0
    total_checks_ok = 0
    total_arquivos = len(all_flux_files)

    for cat_key in sorted(cat_files.keys()):
        titulo = cfg.category_titles.get(cat_key, f"{cfg.fallback_prefix} {cat_key}")
        linhas.append(f"### Tabela de conformidade — {titulo}\n\n")
        linhas.append(header)
        for fname, _ in sorted(cat_files[cat_key], key=lambda x: x[0].lower()):
            linha = results.get(fname, {c: False for c in COLS})
            for col in COLS:
                total_checks += 1
                if linha.get(col, False):
                    totais[col] += 1
                    total_checks_ok += 1
            linhas.append(formatar_linha_md_agrupada(fname, linha, w))
        linhas.append("\n" * cfg.trailing_group_blank_lines)

    if cfg.include_consolidated_heading:
        linhas.append("## 📈 Sumário Consolidado de Backends\n\n")

    num_w = max(2, len(str(total_arquivos)))
    tot_w = max(2, len(str(total_checks)))
    labels = [("in", "  IN"), ("vm", "  VM"), ("llvm", "LLVM"), ("wat", " WAT"), ("was", " WAS")]
    for col, lbl in labels:
        passed = totais[col]
        icon = MD_GREEN if passed == total_arquivos else MD_RED
        linhas.append(f"- {lbl} : {icon}  {passed:>{num_w}} of  {total_arquivos:>{num_w}} — {icon}\n")
    all_icon = MD_GREEN if total_checks_ok == total_checks else MD_RED
    linhas.append(f"-  ALL : {all_icon}  {total_checks_ok:>{tot_w}} of  {total_checks:>{tot_w}} — {all_icon}")
    linhas.append("\n" * cfg.summary_blank_lines)

    reg_lines, regressoes = _build_regression_lines(results, baseline_results, cfg.base_md, cfg.out_md, fail_notes)
    linhas.append("\n".join(reg_lines).lstrip("\n") + "\n")

    cfg.out_md.parent.mkdir(parents=True, exist_ok=True)
    cfg.out_md.write_text("".join(linhas), encoding="utf-8")
    print(f"\n📄 Tabela de conformidade gerada em:\n   {cfg.out_md}")
    return regressoes


def _imprimir_resumo_terminal(
    results: dict[str, dict[str, bool]],
    *,
    col_header: str,
    baseline: dict[str, dict[str, bool]],
    baseline_name: str,
    falhas: list[tuple[str, str, str | None, str | None]],
    ordenar_chaves: bool = False,
) -> tuple[dict[str, int], list[tuple[str, dict[str, bool], dict[str, bool]]]]:
    col_w = {c: max(len(c), 3) for c in COLS}
    larg = max((len(n) for n in results), default=len(col_header))
    cab = col_header.ljust(larg) + "  " + "  ".join(c.rjust(col_w[c]) for c in COLS)
    print()
    print(cab)
    print("-" * len(cab))
    totais = {c: 0 for c in COLS}
    items = sorted(results.items(), key=lambda kv: kv[0].lower()) if ordenar_chaves else list(results.items())
    for nome, linha in items:
        cel = []
        for c in COLS:
            if linha.get(c, False):
                totais[c] += 1
                cel.append(GREEN.rjust(col_w[c] + 4))
            else:
                cel.append(RED.rjust(col_w[c] + 4))
        print(nome.ljust(larg) + "    " + "    ".join(cel))
    print("-" * len(cab))

    ok_arquivos = sum(1 for linha in results.values() if all(linha.values()))
    print(f"Resultado Geral: {ok_arquivos}/{len(results)} arquivo(s) com todos os 5 backends OK")
    for c in COLS:
        print(f"  {c}: {totais[c]}/{len(results)} OK")

    regressoes = detectar_regressoes(results, baseline)
    print()
    if not baseline:
        print(f"Rastreamento de regressão: baseline {baseline_name} não encontrado.")
    elif regressoes:
        print(f"⚠️ ATENÇÃO: {len(regressoes)} regressão(ões) detectada(s) em relação a {baseline_name}:")
        for nome, l_old, l_new in regressoes:
            detalhes = [c for c in COLS if l_old.get(c, False) and not l_new.get(c, False)]
            print(f"  ❌ {nome} regrediu em: {', '.join(detalhes)}")
    else:
        print(f"Rastreamento de regressão: ✅ Nenhuma regressão detectada em relação a {baseline_name}!")

    print()
    print(f"Legenda:  {GREEN} coincide com o interpretador   {RED} diverge ou falhou")
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
            if ref is not None and out is not None and not str(ref).startswith("esperava ["):
                for ln in diff_em_colunas(nome, col, ref, out):
                    print(ln)
    return totais, regressoes


def _avisar_ferramentas() -> None:
    if not _fluxc_bin():
        print("AVISO: 'fluxc' nao encontrado em bin/ ou no PATH (execute scripts/bootstrap.bat)")
    for lib_pair in (("libfluxrt.a", "fluxrt.lib"),):
        if not any((LIB_DIR / name).exists() for name in lib_pair):
            print(f"AVISO: biblioteca {lib_pair[0]} ausente em lib/; compilacao LLVM pode falhar")
    for nome in ("wasmer", "clang"):
        if not TOOLS.get(nome):
            print(f"AVISO: ferramenta '{nome}' nao encontrada")


def _imprimir_progresso_realtime(
    done: int,
    total: int,
    path: Path,
    linha: dict[str, bool],
    name_w: int,
) -> None:
    """Imprime linha de progresso em tempo real com flush imediato."""
    w_tot = max(3, len(str(total)))
    cells = " | ".join(MD_GREEN if linha.get(c, False) else MD_RED for c in COLS)
    res_icon = MD_GREEN if all(linha.get(c, False) for c in COLS) else MD_RED
    msg = f"[{done:>{w_tot}}/{total:>{w_tot}}] | {path.name.ljust(name_w)} | {cells} | {res_icon}"
    with _PRINT_LOCK:
        print(msg, flush=True)


def _executar_em_lote(
    files: list[Path],
    run_tmp: Path,
    *,
    jobs: int,
    on_done: Callable[[int, int, Path], None] | None = None,
) -> tuple[
    dict[str, dict[str, bool]],
    dict[str, dict[str, str | None]],
    list[tuple[str, str, str | None, str | None]],
    dict[str, str],
]:
    results_by_name: dict[str, dict[str, bool]] = {}
    outs_by_name: dict[str, dict[str, str | None]] = {}
    falhas: list[tuple[str, str, str | None, str | None]] = []
    fail_notes: dict[str, str] = {}
    total = len(files)
    name_w = max((len(p.name) for p in files), default=20)
    w_tot = max(3, len(str(total)))

    print(f"[*] Executando {total} arquivo(s) (jobs={jobs})...", flush=True)
    prog_hdr = f"{'progresso'.ljust(w_tot * 2 + 3)} | {'arquivo'.ljust(name_w)} | in | vm | lv | wt | ws | res"
    print(prog_hdr, flush=True)
    print("-" * len(prog_hdr), flush=True)

    if jobs <= 1 or total <= 1:
        for idx, path in enumerate(files, 1):
            wdir = run_tmp / f"f_{idx:04d}"
            linha, out_map, f_loc, note = avaliar_arquivo(path, wdir)
            results_by_name[path.name] = linha
            outs_by_name[path.name] = out_map
            falhas.extend(f_loc)
            if note:
                fail_notes[path.name] = note
            _imprimir_progresso_realtime(idx, total, path, linha, name_w)
            if on_done:
                on_done(idx, total, path)
        return results_by_name, outs_by_name, falhas, fail_notes

    ordered_res: dict[
        int,
        tuple[dict[str, bool], dict[str, str | None], list[tuple[str, str, str | None, str | None]], str],
    ] = {}
    done_cnt = 0
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        future_map = {
            pool.submit(avaliar_arquivo, path, run_tmp / f"f_{idx:04d}"): (idx, path)
            for idx, path in enumerate(files, 1)
        }
        for fut in as_completed(future_map):
            idx, path = future_map[fut]
            done_cnt += 1
            res_item = fut.result()
            ordered_res[idx] = res_item
            _imprimir_progresso_realtime(done_cnt, total, path, res_item[0], name_w)
            if on_done:
                on_done(done_cnt, total, path)

    for idx, path in enumerate(files, 1):
        linha, out_map, f_loc, note = ordered_res[idx]
        results_by_name[path.name] = linha
        outs_by_name[path.name] = out_map
        falhas.extend(f_loc)
        if note:
            fail_notes[path.name] = note
    return results_by_name, outs_by_name, falhas, fail_notes


def executar_suite_agrupada(
    cfg: GroupedSuiteConfig,
    *,
    filter_arg: str | None = None,
    force: bool = False,
    write_md: bool = True,
    jobs: int = 1,
) -> int:
    """Executa uma suite organizada em subpastas (`NumericalRecipes` ou `ScientificAlgorithms`)."""
    os.chdir(RAIZ)
    _avisar_ferramentas()

    if not cfg.suite_dir.exists():
        print(f"Diretorio da suite nao encontrado: {cfg.suite_dir}")
        return 1

    baseline_results = ler_tabela_md(cfg.base_md) if cfg.base_md.exists() else {}
    prev_out_results = ler_tabela_md(cfg.out_md) if cfg.out_md.exists() else {}

    all_flux_files = sorted(cfg.suite_dir.glob("**/*.flux"), key=lambda p: str(p).lower())
    target_files = all_flux_files
    if filter_arg:
        target_files = [f for f in target_files if filter_arg.lower() in f.name.lower()]
        print(f"Executando filtro '{filter_arg}': {len(target_files)} arquivo(s) selecionado(s)")

    if not target_files:
        print(f"Nenhum arquivo .flux encontrado em {cfg.suite_dir}")
        return 0

    results: dict[str, dict[str, bool]] = {}
    to_run: list[Path] = []
    pulados = 0
    if filter_arg:
        to_run = list(target_files)
    else:
        for path in all_flux_files:
            fname = path.name
            if not force and fname in prev_out_results and all(prev_out_results[fname].get(c, False) for c in COLS):
                results[fname] = prev_out_results[fname]
                pulados += 1
                continue
            to_run.append(path)

    print()
    print(f"Iniciando verificação [selfhosted] de {cfg.suite_label}: {len(target_files)} arquivo(s) | {len(to_run)} a testar | {pulados} mantido(s) de {cfg.out_md.name}...")

    TMP_BASE.mkdir(parents=True, exist_ok=True)
    run_tmp = Path(tempfile.mkdtemp(prefix=f"cmp_{cfg.suite_name}_", dir=str(TMP_BASE)))
    garantir_fixture_io()
    falhas: list[tuple[str, str, str | None, str | None]] = []
    fail_notes: dict[str, str] = {}

    try:
        if to_run:
            ran_res, _, falhas, fail_notes = _executar_em_lote(to_run, run_tmp, jobs=jobs)
            results.update(ran_res)
    finally:
        limpar_t(run_tmp)

    print("-" * 72)
    print(f"Arquivos processados: {len(results)} total | {len(to_run)} testados agora | {pulados} mantido(s) (5/5 OK)")
    print("-" * 72)

    _, regressoes = _imprimir_resumo_terminal(
        results,
        col_header="algoritmo",
        baseline=baseline_results,
        baseline_name=cfg.base_md.name,
        falhas=falhas,
        ordenar_chaves=True,
    )

    if write_md and not filter_arg:
        regressoes = _gerar_grouped_md(cfg, results, all_flux_files, baseline_results, fail_notes)
    elif write_md and filter_arg:
        print(f"\n[*] Modo --filter ativo: '{cfg.out_md}' preservado sem alteracoes.")

    ok_arquivos = sum(1 for linha in results.values() if all(linha.values()))
    if regressoes:
        return 1
    return 0 if ok_arquivos == len(results) else 1


def criar_parser_suite(description: str, md_name: str) -> argparse.ArgumentParser:
    """Constroi ArgumentParser padrao para os scripts `compliance_XX.py`."""
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("--filter", "-f", type=str, default=None, help="Filtra arquivos por substring no nome")
    parser.add_argument("--force", action="store_true", help="Forca reteste de todos os arquivos, mesmo os ja 5/5 OK em XX01.md")
    parser.add_argument("--no-md", action="store_true", help=f"Nao grava o arquivo {md_name}")
    parser.add_argument("--jobs", "-j", type=int, default=1, help="Workers paralelos (padrao: 1)")
    return parser


def main() -> int:
    parser = argparse.ArgumentParser(description="Validador de conformidade multi-backend self-hosted para Canon (examples/Canon).")
    parser.add_argument("target", nargs="?", default=None, help="Filtro opcional (arquivo, pasta, substring, --stdlib ou --modular)")
    parser.add_argument("--filter", "-f", dest="filter_opt", default=None, help="Filtra arquivos por substring no nome")
    parser.add_argument("--stdlib", action="store_true", help="Filtra exemplos de StdLib")
    parser.add_argument("--modular", action="store_true", help="Filtra exemplos Modulares")
    parser.add_argument("--no-md", action="store_true", help="Nao grava compliance_CA01.md")
    parser.add_argument("--jobs", "-j", type=int, default=1, help="Workers paralelos (padrao: 1)")
    args = parser.parse_args()

    jobs = max(1, args.jobs)
    filter_arg = args.filter_opt or args.target
    if args.stdlib:
        filter_arg = "--stdlib"
    elif args.modular:
        filter_arg = "--modular"

    os.chdir(RAIZ)
    _avisar_ferramentas()

    base_md = STANDARTS_DIR / "compliance_CA00.md"
    out_md = STANDARTS_DIR / "compliance_CA01.md"
    baseline_results = ler_tabela_md(base_md) if base_md.exists() else {}

    if not CANON_DIR.exists():
        print(f"Diretorio Canon nao encontrado: {CANON_DIR}")
        return 1

    flux_files = sorted(CANON_DIR.glob("*.flux"), key=lambda p: p.name.lower())
    if filter_arg:
        exact_p = Path(filter_arg)
        if not exact_p.exists() and not exact_p.is_absolute():
            for cand in (RAIZ / filter_arg, EXAMPLES_DIR / filter_arg, CANON_DIR / filter_arg):
                if cand.exists():
                    exact_p = cand
                    break
        if exact_p.is_file():
            flux_files = [exact_p]
        elif exact_p.is_dir():
            files = list(exact_p.glob("*.flux")) or list(exact_p.rglob("*.flux"))
            flux_files = sorted(files, key=lambda p: p.name.lower())
        elif filter_arg in ("--stdlib", "--modular", "modular", "stdlib"):
            flux_files = [f for f in flux_files if "StdLib" in f.name or "Modular" in f.name]
        else:
            needle = exact_p.name.lower()
            flux_files = [f for f in flux_files if needle in f.name.lower()]
        print(f"Executando filtro '{filter_arg}': {len(flux_files)} arquivo(s) encontrado(s)")

    if not flux_files:
        print(f"Nenhum arquivo .flux encontrado em {CANON_DIR}")
        return 1

    TMP_BASE.mkdir(parents=True, exist_ok=True)
    run_tmp = Path(tempfile.mkdtemp(prefix="cmp_ca_", dir=str(TMP_BASE)))
    garantir_fixture_io()

    try:
        results, _, falhas, fail_notes = _executar_em_lote(flux_files, run_tmp, jobs=jobs)
    finally:
        limpar_t(run_tmp)

    totais, _ = _imprimir_resumo_terminal(
        results,
        col_header="arquivo",
        baseline=baseline_results,
        baseline_name=base_md.name,
        falhas=falhas,
        ordenar_chaves=False,
    )

    pos_items = [n for n in results if not n.startswith("ExampleOfError")]
    err_items = [n for n in results if n.startswith("ExampleOfError")]
    pos_ok = sum(1 for n in pos_items if all(results[n].values()))
    err_ok = sum(1 for n in err_items if all(results[n].values()))
    if pos_items and err_items:
        print(f"  - Programas regulares: {pos_ok}/{len(pos_items)} OK")
        print(f"  - Diagnósticos & erros: {err_ok}/{len(err_items)} OK")

    if not filter_arg and not args.no_md:
        gerar_md(results, totais, out_md, fail_notes, baseline_results, base_md)
    elif filter_arg and not args.no_md:
        print(f"[*] Modo filtro ativo: '{out_md}' preservado sem alteracoes.")

    return 0 if sum(1 for linha in results.values() if all(linha.values())) == len(results) else 1


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", line_buffering=True)
    raise SystemExit(main())
