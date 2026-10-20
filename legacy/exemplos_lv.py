from __future__ import annotations
import io
import os
import shutil
import subprocess
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

SRC = Path(__file__).resolve().parent / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

RAIZ = Path(__file__).resolve().parent
FLUX_DIR = RAIZ / "flux"
T_LLVM = RAIZ / "t_llvm"
CLANG = (
    shutil.which("clang")
    or (lambda p: Path(p).exists() and p or None)(r"C:\Program Files\LLVM\bin\clang.exe")
    or r"C:\Arquivos de Programas\LLVM\bin\clang.exe"
)

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

T_LLVM.mkdir(parents=True, exist_ok=True)
flux_files = sorted(FLUX_DIR.glob("*.flux"))
acertos = 0
erros = 0

PYTHON = sys.executable
ENV = dict(os.environ, PYTHONPATH=str(SRC))

for flux_path in flux_files:
    nome = flux_path.name
    base_stem = flux_path.stem

    print(f"--- {nome} ---")

    stdin_input = STDIN_MAP.get(nome, "")

    result = subprocess.run(
        [PYTHON, "-m", "flux_proto", str(flux_path), "--emit-llvm"],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60, env=ENV, input=stdin_input,
    )
    if result.returncode != 0:
        erros += 1
        print(f"FALHA  {nome} (LLVM IR): {result.stderr.strip()}")
        continue

    ll_path = RAIZ / "intermediates" / "llvm" / f"{base_stem}.ll"
    if not ll_path.exists():
        erros += 1
        print(f"FALHA  {nome} (.ll nao gerado)")
        continue

    print(f"  [ir]   {ll_path.name}")

    if not Path(CLANG).exists():
        erros += 1
        print(f"FALHA  {nome} (clang nao encontrado: {CLANG})")
        continue

    exe_path = T_LLVM / f"{base_stem}.exe"
    runtime_c = SRC / "flux_proto" / "llvm" / "runtime" / "flux_input.c"
    clang_result = subprocess.run(
        [CLANG, "-o", str(exe_path), str(ll_path), str(runtime_c)],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60,
    )
    if clang_result.returncode != 0:
        erros += 1
        err = clang_result.stderr.strip()
        print(f"FALHA  {nome} (clang): {err.split(chr(10))[-1] if err else 'erro desconhecido'}")
        continue

    print(f"  [exe]  {exe_path.name}")

    run_result = subprocess.run(
        [str(exe_path)], capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=30, input=stdin_input,
    )
    out_str = run_result.stdout or ""
    err_str = run_result.stderr or ""
    if run_result.returncode == 0:
        acertos += 1
        if out_str.strip():
            for linha in out_str.splitlines():
                print(f"  | {linha}")
        print(f"  OK    {nome}")
    else:
        erros += 1
        msg = out_str.strip() or err_str.strip() or f"(exit code {run_result.returncode})"
        print(f"FALHA  {nome}: {msg}")

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
