from __future__ import annotations
import io
import os
import re
import sys
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path

os.environ["FLUX_CI"] = "1"
sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent
SRC = RAIZ / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.cli import main as run_flux

FLUX_DIR = RAIZ / "flux"
T_FVMBC = RAIZ / "t_fvmbc"
T_FVMBC.mkdir(parents=True, exist_ok=True)

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


filtro = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith("-") else None
flux_files = sorted(FLUX_DIR.glob("*.flux"))
if filtro:
    flux_files = [f for f in flux_files if filtro.lower() in f.name.lower()]

acertos = 0
erros = 0

for path in flux_files:
    nome = path.name
    stdin_input = STDIN_MAP.get(nome, "")
    expected_code = obter_erro_esperado(path)
    old_stdin = sys.stdin
    sys.stdin = io.StringIO(stdin_input)

    fvmbc_path = T_FVMBC / f"{path.stem}.fvmbc"

    try:
        out = io.StringIO()
        err = io.StringIO()
        with redirect_stdout(out), redirect_stderr(err):
            try:
                ec = run_flux([str(path), "--target", "vmbc", "--output", str(fvmbc_path.with_suffix(""))])
            except SystemExit as se:
                ec = se.code if isinstance(se.code, int) else (0 if se.code is None else 1)
        err_output = (err.getvalue() or out.getvalue()).strip()
        if ec == 0 and not expected_code:
            acertos += 1
            print(f"  [bc]   {fvmbc_path.name}")
            if out.getvalue().strip():
                for linha in out.getvalue().splitlines():
                    print(f"  | {linha}")
            print(f"  OK  {nome}")
        elif erro_esperado_obtido(expected_code, ec, err_output):
            acertos += 1
            for linha in err_output.splitlines():
                print(f"  | {linha}")
            print(f"  OK  {nome}")
        else:
            erros += 1
            error_msg = err_output.split("\n")[-1] if err_output else f"esperava erro {expected_code}"
            print(f"FALHA  {nome}: {error_msg}")
    except Exception as exc:
        erros += 1
        print(f"FALHA  {nome}: {exc}")
    finally:
        sys.stdin = old_stdin

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
