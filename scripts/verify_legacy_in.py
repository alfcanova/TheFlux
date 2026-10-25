"""Automated Oracle Verifier against docs/legacy_in.txt.

Runs all flux/*.flux (or filtered subset) using the compiler in .\\src
and verifies exact stdout parity against docs/legacy_in.txt.
"""
from __future__ import annotations

import difflib
import io
import os
import re
import subprocess
import sys
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path

os.environ["FLUX_CI"] = "1"

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.cli import main as run_flux

LEGACY_TXT = ROOT / "docs" / "legacy_in.txt"
FLUX_DIR = ROOT / "flux"

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


def limpar_scratch_dbs() -> None:
    scratch = ROOT / "scratch"
    if scratch.exists():
        for pat in ("flux_*.db*", "flux_*.kv", "flux_*.unqlite", "flux_*.duckdb", "flux_*.kuzu", "flux_*.obx"):
            for f in scratch.glob(pat):
                try:
                    f.unlink()
                except Exception:
                    pass


def parse_legacy_oracle(path: Path) -> dict[str, tuple[str, str]]:
    """Return {test_name: (status, output_lines)} from docs/legacy_in.txt."""
    text = path.read_text(encoding="utf-8", errors="replace")
    root_posix = ROOT.as_posix()
    legacy_posix = (ROOT / "legacy").as_posix()
    runs: dict[str, tuple[str, str]] = {}
    lines: list[str] = []
    for line in text.splitlines():
        if line.startswith("  OK  ") or line.startswith("FALHA  "):
            parts = line.split()
            status = parts[0]
            name = parts[1].rstrip(":")
            out_text = "\n".join(lines).strip().replace(legacy_posix, root_posix)
            runs[name] = (status, out_text)
            lines = []
        elif line.startswith("  | "):
            lines.append(line[4:])
    return runs


def main() -> int:
    if not LEGACY_TXT.exists():
        print(f"Erro: arquivo de referencia nao encontrado em {LEGACY_TXT}", file=sys.stderr)
        return 1

    oracle = parse_legacy_oracle(LEGACY_TXT)
    use_fluxc_exe = "--use-fluxc-exe" in sys.argv[1:]
    filters = [a for a in sys.argv[1:] if not a.startswith("-")]
    fluxc_exe = ROOT / "bin" / "fluxc.exe"
    env = dict(os.environ, FLUX_CI="1", PYTHONUTF8="1", PYTHONIOENCODING="utf-8")

    flux_files = sorted(FLUX_DIR.glob("*.flux"))
    if filters:
        flux_files = [
            f for f in flux_files
            if any(flt.lower() in f.name.lower() for flt in filters)
        ]

    matched = 0
    diverged = 0
    diffs: list[str] = []

    for path in flux_files:
        nome = path.name
        if nome not in oracle:
            continue

        if "DbStdLib" in nome:
            limpar_scratch_dbs()

        exp_status, exp_out = oracle[nome]
        expected_code = obter_erro_esperado(path)
        stdin_input = STDIN_MAP.get(nome, "")
        if use_fluxc_exe:
            r = subprocess.run(
                [str(fluxc_exe), str(path)],
                input=stdin_input,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                env=env,
            )
            err_txt = (r.stderr or r.stdout).strip()
            if r.returncode == 0 and not expected_code:
                act_status = "OK"
                act_out = "\n".join(r.stdout.strip().splitlines())
            elif erro_esperado_obtido(expected_code, r.returncode, err_txt):
                act_status = "OK"
                act_out = "\n".join(err_txt.splitlines())
            else:
                act_status = "FALHA"
                act_out = err_txt
        else:
            old_stdin = sys.stdin
            sys.stdin = io.StringIO(stdin_input)
            out = io.StringIO()
            err = io.StringIO()
            try:
                with redirect_stdout(out), redirect_stderr(err):
                    try:
                        ec = run_flux([str(path)])
                    except SystemExit as se:
                        ec = se.code if isinstance(se.code, int) else (0 if se.code is None else 1)
                err_txt = (err.getvalue() or out.getvalue()).strip()
                if ec == 0 and not expected_code:
                    act_status = "OK"
                    act_out = "\n".join(out.getvalue().strip().splitlines())
                elif erro_esperado_obtido(expected_code, ec, err_txt):
                    act_status = "OK"
                    act_out = "\n".join(err_txt.splitlines())
                else:
                    act_status = "FALHA"
                    act_out = err_txt
            except Exception as exc:
                act_status = "FALHA"
                act_out = str(exc)
            finally:
                sys.stdin = old_stdin

        if act_status == exp_status and act_out == exp_out:
            matched += 1
        else:
            diverged += 1
            diff = "\n".join(
                difflib.unified_diff(
                    exp_out.splitlines(),
                    act_out.splitlines(),
                    fromfile=f"legacy_in.txt ({exp_status})",
                    tofile=f"src ({act_status})",
                    lineterm="",
                )
            )
            diffs.append(f">>> {nome}\n{diff}")

    total = matched + diverged
    print(f"Verificados contra docs/legacy_in.txt: {matched}/{total} identicos ({diverged} divergencias)")
    if diffs:
        for d in diffs[:10]:
            print(d)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
