from __future__ import annotations
import os
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
FLUXVM = BIN / "fluxvm.exe"
FLUX_DIR = RAIZ / "flux"
T_FVMBC = RAIZ / "t_fvmbc"
T_FVMBC.mkdir(parents=True, exist_ok=True)

STDIN_MAP: dict[str, str] = {
    "input.fvmbc": "dado\n",
    "ExampleOfInput.fvmbc": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.fvmbc": "andre\nluiz\n",
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

if not FLUXVM.exists():
    print(f"Erro: Binario do FluxVM nao encontrado em {FLUXVM}")
    sys.exit(1)

filtro = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith("-") else None

flux_files = sorted(FLUX_DIR.glob("*.flux"))
if filtro:
    flux_files = [f for f in flux_files if filtro.lower() in f.name.lower()]

acertos = 0
erros = 0

for path in flux_files:
    nome = path.name
    stdin_input = STDIN_MAP.get(nome, "")
    bc_path = T_FVMBC / f"{path.stem}.fvmbc"

    # Se o bytecode nao existir, compila via fluxc.exe
    if not bc_path.exists() and FLUXC.exists():
        subprocess.run(
            [str(FLUXC), "--target", "vmr", "-o", str(T_FVMBC / path.stem), str(path.resolve())],
            capture_output=True,
            text=True,
            timeout=30,
        )

    if not bc_path.exists():
        erros += 1
        print(f"FALHA  {nome}: bytecode .fvmbc nao encontrado")
        continue

    try:
        res = subprocess.run(
            [str(FLUXVM), "--inject", str(bc_path.resolve())],
            input=stdin_input,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
        )
        if res.returncode == 0:
            acertos += 1
            if res.stdout.strip():
                for linha in res.stdout.splitlines():
                    print(f"  | {linha}")
            print(f"  OK  {nome}")
        else:
            erros += 1
            msg = (res.stderr or res.stdout).strip().splitlines()
            error_msg = msg[-1] if msg else f"exit code {res.returncode}"
            print(f"FALHA  {nome}: {error_msg}")
    except Exception as exc:
        erros += 1
        print(f"FALHA  {nome}: {exc}")

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
