from __future__ import annotations
import io
import os
import shutil
import subprocess
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent
BIN = RAIZ / "bin"
FLUXC = BIN / "fluxc.exe"
FLUX_DIR = RAIZ / "flux"
T_LLVM = RAIZ / "t_llvm"
T_LLVM.mkdir(parents=True, exist_ok=True)
RUNTIME_C = RAIZ / "runtime" / "flux_input.c"

CLANG = (
    shutil.which("clang")
    or (lambda p: Path(p).exists() and p or None)(r"C:\Program Files\LLVM\bin\clang.exe")
    or (lambda p: Path(p).exists() and p or None)(r"C:\Arquivos de Programas\LLVM\bin\clang.exe")
)

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

if not FLUXC.exists():
    print(f"Erro: Binario do compilador nao encontrado em {FLUXC}")
    sys.exit(1)

if not CLANG or not Path(CLANG).exists():
    print(f"Erro: Clang nao encontrado: {CLANG}")
    sys.exit(1)

filtro = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith("-") else None
flux_files = sorted(FLUX_DIR.glob("*.flux"))
if filtro:
    flux_files = [f for f in flux_files if filtro.lower() in f.name.lower()]

acertos = 0
erros = 0

for flux_path in flux_files:
    nome = flux_path.name
    base_stem = flux_path.stem
    stdin_input = STDIN_MAP.get(nome, "")

    ll_path = T_LLVM / f"{base_stem}.ll"
    exe_path = T_LLVM / f"{base_stem}.exe"

    try:
        # 1. Emite LLVM IR via fluxc.exe
        res_ir = subprocess.run(
            [str(FLUXC), "--target", "llvm", "-o", str(T_LLVM / base_stem), str(flux_path.resolve())],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
        )
        if res_ir.returncode != 0 or not ll_path.exists():
            erros += 1
            msg = (res_ir.stderr or res_ir.stdout).strip().splitlines()
            error_msg = msg[-1] if msg else "falha ao emitir LLVM IR"
            print(f"FALHA  {nome} (LLVM IR): {error_msg}")
            continue

        # Normaliza escapes literais no LLVM IR se necessario
        try:
            content = ll_path.read_text(encoding="utf-8", errors="replace")
            if "\\n" in content and not ("\n" in content and len(content.splitlines()) > 5):
                content = content.replace("\\n", "\n").replace('\\"', '"')
            content = content.replace("\\\\0A", "\\0A").replace("\\\\00", "\\00")
            ll_path.write_text(content, encoding="utf-8")
        except Exception:
            pass

        print(f"  [ir]   {ll_path.name}")

        # 2. Compila via Clang linkando com runtime C
        if exe_path.exists():
            try:
                exe_path.unlink()
            except OSError:
                pass

        res_clang = subprocess.run(
            [str(CLANG), "-O2", "-Wno-deprecated-declarations", "-o", str(exe_path), str(ll_path), str(RUNTIME_C)],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
        )
        if res_clang.returncode != 0 or not exe_path.exists():
            erros += 1
            msg = res_clang.stderr.strip().splitlines()
            error_msg = msg[-1] if msg else "falha no clang"
            print(f"FALHA  {nome} (clang): {error_msg}")
            continue

        print(f"  [exe]  {exe_path.name}")

        # 3. Executa binario nativo
        run_res = subprocess.run(
            [str(exe_path)],
            input=stdin_input,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
        )
        if run_res.returncode == 0:
            acertos += 1
            if run_res.stdout.strip():
                for linha in run_res.stdout.splitlines():
                    print(f"  | {linha}")
            print(f"  OK    {nome}")
        else:
            erros += 1
            msg = (run_res.stderr or run_res.stdout).strip().splitlines()
            error_msg = msg[-1] if msg else f"exit code {run_res.returncode}"
            print(f"FALHA  {nome}: {error_msg}")
    except Exception as exc:
        erros += 1
        print(f"FALHA  {nome}: {exc}")

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
