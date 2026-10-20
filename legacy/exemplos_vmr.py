from __future__ import annotations
import io
import json
import sys
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

SRC = Path(__file__).resolve().parent / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.vm.runtime import execute_bytecode

RAIZ = Path(__file__).resolve().parent
T_FVMBC = RAIZ / "t_fvmbc"

import os

STDIN_MAP: dict[str, str] = {
    "input.fvmbc": "dado\n",
    "ExampleOfInput.fvmbc": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.fvmbc": "andre\nluiz\n",
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

fvmbc_files = sorted(T_FVMBC.glob("*.fvmbc"))
acertos = 0
erros = 0

for path in fvmbc_files:
    nome = path.name
    stdin_input = STDIN_MAP.get(nome, "")
    old_stdin = sys.stdin
    sys.stdin = io.StringIO(stdin_input)

    try:
        with open(path) as f:
            bc = json.load(f)

        out = io.StringIO()
        err = io.StringIO()
        with redirect_stdout(out), redirect_stderr(err):
            execute_bytecode(bc)

        output = out.getvalue()
        acertos += 1
        if output.strip():
            for linha in output.splitlines():
                print(f"  | {linha}")
        print(f"  OK  {nome}")
    except Exception as exc:
        erros += 1
        print(f"FALHA  {nome}: {exc}")
    finally:
        sys.stdin = old_stdin

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
