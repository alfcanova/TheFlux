#!/usr/bin/env python3
"""Tri-Engine Parity Verifier for Control Flow Examples (Route, Infinite, Match)."""
import os
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FLUX_DIR = ROOT / "flux"
BIN_FLUXC = ROOT / "bin" / "fluxc.exe"

FILES = [
    "ExampleOfInfinite.flux",
    "ExampleOfInfiniteFor.flux",
    "ExampleOfInfiniteWhile.flux",
    "ExampleOfMatch.flux",
    "ExampleOfRoute.flux",
    "ExampleOfRouteDefault.flux",
    "ExampleOfRouteIf.flux",
    "ExampleOfRouteLogical.flux",
    "ExampleOfRouteMembership.flux",
    "ExampleOfRouteNumeric.flux",
    "ExampleOfRouteSubjects.flux",
]

def run_cmd(cmd: list[str]) -> tuple[int, str]:
    legacy_dir = ROOT / "legacy" if (ROOT / "legacy").exists() else ROOT / "backup"
    env = os.environ.copy()
    env["PYTHONPATH"] = f"{ROOT / 'src'}{os.pathsep}{legacy_dir / 'src'}"
    res = subprocess.run(cmd, cwd=ROOT, env=env, capture_output=True, text=True, errors="replace", timeout=30)
    out = res.stdout.replace("\r\n", "\n").strip()
    return res.returncode, out

def main():
    print("=" * 80)
    print(">>> VERIFICACAO DE PARIDADE TRI-ENGINE: ROUTE, INFINITE & MATCH <<<")
    print(f"Total de Arquivos a Validar: {len(FILES)}")
    print("=" * 80)

    passed = 0
    failed = 0

    for idx, ex_name in enumerate(FILES, 1):
        ex_path = FLUX_DIR / ex_name
        t0 = time.time()

        # 1. Reference
        c1, out1 = run_cmd([sys.executable, str(legacy_dir / "flux_in.py"), str(ex_path)])
        # 2. Self-Hosted
        c2, out2 = run_cmd([sys.executable, str(legacy_dir / "flux_in.py"), str(ROOT / "src" / "main.flux"), "--target", "in", str(ex_path)])
        # 3. Independent Binary
        c3, out3 = run_cmd([str(BIN_FLUXC), "--target", "in", str(ex_path)])
        dt = time.time() - t0

        if c1 != 0 or c2 != 0 or c3 != 0:
            print(f"[{idx}/{len(FILES)}] [-] {ex_name}: Falha de codigo de retorno (Ref={c1}, SH={c2}, Bin={c3})")
            failed += 1
            continue

        if out1 == out2 == out3:
            print(f"[{idx}/{len(FILES)}] [+] 100% PARIDADE TRI-ENGINE: {ex_name} ({dt:.2f}s)")
            passed += 1
        else:
            print(f"[{idx}/{len(FILES)}] [-] DIVERGENCIA DE SAIDA: {ex_name}")
            if out1 != out2:
                print(f"  [Diff Ref vs SH]:\n  Ref: {out1[:100]}...\n  SH:  {out2[:100]}...")
            if out1 != out3:
                print(f"  [Diff Ref vs Bin]:\n  Ref: {out1[:100]}...\n  Bin: {out3[:100]}...")
            failed += 1

    print("=" * 80)
    print(f"Resultado Final: {passed}/{len(FILES)} com 100% de paridade tri-engine!")
    if failed == 0:
        print("TODOS OS TESTES PASSARAM COM SUCESSO!")
    print("=" * 80)

if __name__ == "__main__":
    main()
