from __future__ import annotations
import os
import re
import subprocess
import sys
from pathlib import Path

os.environ["FLUX_CI"] = "1"
sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent.parent
FLUX_DIR = RAIZ / "flux"
FLUXC_EXE = RAIZ / "bin" / "fluxc.exe"
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


def limpar_scratch_dbs() -> None:
    scratch = RAIZ / "scratch"
    if scratch.exists():
        for pat in ("flux_*.db*", "flux_*.kv", "flux_*.unqlite", "flux_*.duckdb", "flux_*.kuzu", "flux_*.obx"):
            for f in scratch.glob(pat):
                try:
                    f.unlink()
                except Exception:
                    pass


filtro = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith("-") else None
flux_files = sorted(FLUX_DIR.glob("*.flux"))
if filtro:
    flux_files = [f for f in flux_files if filtro.lower() in f.name.lower()]

acertos = 0
erros = 0

for path in flux_files:
    nome = path.name
    if "DbStdLib" in nome:
        limpar_scratch_dbs()
    stdin_input = STDIN_MAP.get(nome, "")
    expected_code = obter_erro_esperado(path)
    fvmbc_path = T_FVMBC / f"{path.stem}.fvmbc"
    env = dict(
        os.environ,
        FLUX_CI="1",
        PYTHONUTF8="1",
        PYTHONIOENCODING="utf-8",
        _FLUXC_VM_DELEGATED="1",
    )

    try:
        res = subprocess.run(
            [str(FLUXC_EXE), str(path), "--target", "vmbc", "-o", str(fvmbc_path.with_suffix(""))],
            cwd=str(RAIZ),
            input=stdin_input,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            env=env,
        )
        ec = res.returncode
        output = res.stdout or ""
        err_output = ((res.stderr or "") or output).strip()
        if ec == 0 and not expected_code:
            acertos += 1
            print(f"  [bc]   {fvmbc_path.name}")
            if output.strip():
                for linha in output.splitlines():
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

print(f"\n{acertos} sucesso, {erros} falha(s)")
raise SystemExit(0 if erros == 0 else 1)
