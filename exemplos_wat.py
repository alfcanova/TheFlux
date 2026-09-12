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
T_WAT = RAIZ / "t_wat-1.0"

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

T_WAT.mkdir(parents=True, exist_ok=True)
flux_files = sorted(FLUX_DIR.glob("*.flux"))
acertos = 0
erros = 0

PYTHON = sys.executable
ENV = dict(os.environ, PYTHONPATH=str(SRC))

for flux_path in flux_files:
    nome = flux_path.name
    base_stem = flux_path.stem
    stdin_input = STDIN_MAP.get(nome, "")

    wat_path = T_WAT / f"{base_stem}.wat"

    result = subprocess.run(
        [PYTHON, "-m", "flux_proto", str(flux_path), "--target", "wat", "--output", str(wat_path.with_suffix(""))],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60, env=ENV, input=stdin_input,
    )

    if result.returncode != 0:
        erros += 1
        print(f"FALHA  {nome}: {result.stderr.strip()}")
        continue

    result_stdout = result.stdout.strip()
    for line in result_stdout.splitlines():
        if line.startswith("WAT"):
            print(f"  {line}")

    if wat_path.exists():
        print(f"  [wat]  {wat_path.name}")
    else:
        erros += 1
        print(f"FALHA  {nome}: .wat nao gerado")
        continue

    acertos += 1
    print(f"  OK    {nome}")

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
