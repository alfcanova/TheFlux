from __future__ import annotations
import io
import sys
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

SRC = Path(__file__).resolve().parent / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.cli import main as run_flux

RAIZ = Path(__file__).resolve().parent
FLUX_DIR = RAIZ / "flux"
T_FVMBC = RAIZ / "t_fvmbc"

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

T_FVMBC.mkdir(parents=True, exist_ok=True)
flux_files = sorted(FLUX_DIR.glob("*.flux"))
acertos = 0
erros = 0

for path in flux_files:
    nome = path.name
    stdin_input = STDIN_MAP.get(nome, "")
    old_stdin = sys.stdin
    sys.stdin = io.StringIO(stdin_input)

    fvmbc_path = T_FVMBC / f"{path.stem}.fvmbc"

    try:
        out = io.StringIO()
        err = io.StringIO()
        with redirect_stdout(out), redirect_stderr(err):
            ec = run_flux([str(path), "--target", "vmbc", "--output", str(fvmbc_path.with_suffix(""))])
        if ec == 0:
            acertos += 1
            print(f"  [bc]   {fvmbc_path.name}")
            if out.getvalue().strip():
                for linha in out.getvalue().splitlines():
                    print(f"  | {linha}")
            print(f"  OK  {nome}")
        else:
            erros += 1
            error_msg = (err.getvalue() or out.getvalue()).strip().split("\n")[-1]
            print(f"FALHA  {nome}: {error_msg}")
    except Exception as exc:
        erros += 1
        print(f"FALHA  {nome}: {exc}")
    finally:
        sys.stdin = old_stdin

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
