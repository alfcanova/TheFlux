from __future__ import annotations
import io
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
FLUX_DIR = RAIZ / "flux"
T_WAT = RAIZ / "t_wat"
T_WAT.mkdir(parents=True, exist_ok=True)

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

if not FLUXC.exists():
    print(f"Erro: Binario do compilador nao encontrado em {FLUXC}")
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
    wat_path = T_WAT / f"{base_stem}.wat"

    try:
        # Emite WAT via fluxc.exe
        res = subprocess.run(
            [str(FLUXC), "--target", "wat", "-o", str(T_WAT / base_stem), str(flux_path.resolve())],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
        )
        if res.returncode != 0 or not wat_path.exists():
            erros += 1
            msg = (res.stderr or res.stdout).strip().splitlines()
            error_msg = msg[-1] if msg else "falha ao emitir WAT"
            print(f"FALHA  {nome}: {error_msg}")
            continue

        print(f"  [wat]  {wat_path.name}")
        acertos += 1
        print(f"  OK    {nome}")

    except Exception as exc:
        erros += 1
        print(f"FALHA  {nome}: {exc}")

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
