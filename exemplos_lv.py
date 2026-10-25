from __future__ import annotations
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

os.environ["FLUX_CI"] = "1"
sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent
SRC = RAIZ / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

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

EXPECT_ERROR_RE = re.compile(r"^#L\s+EXPECT_ERROR:\s*([A-Z]{2,4}\d{3})", re.MULTILINE)


def obter_erro_esperado(path: Path) -> str | None:
    if not path.name.startswith("ExampleOfError"):
        return None
    try:
        m = EXPECT_ERROR_RE.search(path.read_text(encoding="utf-8"))
        return m.group(1).upper() if m else None
    except Exception:
        return None


def erro_esperado_obtido(expected_code: str | None, ec: int, texto_erro: str) -> bool:
    if not expected_code or ec == 0:
        return False
    return (f"[{expected_code} - " in texto_erro) and ("💡 Dica:" in texto_erro)


T_LLVM.mkdir(parents=True, exist_ok=True)
filtro = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith("-") else None
flux_files = sorted(FLUX_DIR.glob("*.flux"))
if filtro:
    flux_files = [f for f in flux_files if filtro.lower() in f.name.lower()]

acertos = 0
erros = 0

PYTHON = sys.executable
ENV = dict(os.environ, PYTHONPATH=str(SRC), FLUX_CI="1")

for flux_path in flux_files:
    nome = flux_path.name
    base_stem = flux_path.stem
    expected_code = obter_erro_esperado(flux_path)

    print(f"--- {nome} ---")

    stdin_input = STDIN_MAP.get(nome, "")

    result = subprocess.run(
        [PYTHON, "-m", "flux_proto", str(flux_path), "--emit-llvm"],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60, env=ENV, input=stdin_input,
    )
    if result.returncode != 0:
        err_output = (result.stderr or result.stdout).strip()
        if erro_esperado_obtido(expected_code, result.returncode, err_output):
            acertos += 1
            for linha in err_output.splitlines():
                print(f"  | {linha}")
            print(f"  OK    {nome}")
        else:
            erros += 1
            print(f"FALHA  {nome} (LLVM IR): {err_output}")
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
        [str(exe_path)], capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=30, input=stdin_input, env=ENV,
    )
    out_str = run_result.stdout or ""
    err_str = run_result.stderr or ""
    if run_result.returncode == 0 and not expected_code:
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
