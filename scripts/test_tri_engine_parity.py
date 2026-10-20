#!/usr/bin/env python3
"""Tri-Engine Parity Verifier for Canonical Examples.

Verifies 100% byte-for-byte execution parity across:
  1) Reference compiler (flux_in.py)
  2) Self-hosted compiler (python flux_in.py src/main.flux --target in)
  3) Independent native binary (bin/fluxc.exe --target in)
"""
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FLUX_DIR = ROOT / "flux"
BIN_FLUXC = ROOT / "bin" / "fluxc.exe"

EXAMPLES = [
    "ExampleOfPrint.flux",
    "ExampleOfMut.flux",
    "ExampleOfImut.flux",
    "ExampleOfChar.flux",
    "ExampleOfString.flux",
    "ExampleOfStringType.flux",
    "ExampleOfStringInterpolation.flux",
    "ExampleOfInteger.flux",
    "ExampleOfIntType.flux",
    "ExampleOfFloat.flux",
    "ExampleOfFloatType.flux",
    "ExampleOfComplexType.flux",
    "ExampleOfList.flux",
    "ExampleOfMap.flux",
    "ExampleOfSet.flux",
    "ExampleOfStruct.flux",
    "ExampleOfAccessors.flux",
]

def run_cmd(cmd: list[str]) -> tuple[int, str]:
    env = os.environ.copy()
    env["PYTHONPATH"] = f"{ROOT / 'src'}{os.pathsep}{ROOT / 'backup' / 'src'}"
    res = subprocess.run(cmd, cwd=ROOT, env=env, capture_output=True, text=True, errors="replace")
    out = res.stdout.replace("\r\n", "\n").strip()
    return res.returncode, out

def main():
    print("=" * 80)
    print(">>> VERIFICAÇÃO DE PARIDADE TRI-ENGINE: THEFLUX NATIVE COMPILER <<<")
    print(f"Total de Exemplos a Validar: {len(EXAMPLES)}")
    print("=" * 80)

    if not BIN_FLUXC.exists():
        print(f"[-] Erro: {BIN_FLUXC} não encontrado!")
        sys.exit(1)

    # Smoke test binary version
    code, out = run_cmd([str(BIN_FLUXC), "--version"])
    print(f"[*] bin/fluxc.exe --version: {out}")
    if code != 0 or out != "0.9.9":
        print(f"[-] Erro: Versão esperada 0.9.9, obteve '{out}' (code {code})")
        sys.exit(1)

    passed = 0
    failed = 0

    for idx, ex_name in enumerate(EXAMPLES, 1):
        ex_path = FLUX_DIR / ex_name
        if not ex_path.exists():
            print(f"[{idx}/{len(EXAMPLES)}] [-] ARQUIVO NÃO ENCONTRADO: {ex_name}")
            failed += 1
            continue

        # 1. Reference
        c1, out1 = run_cmd([sys.executable, str(ROOT / "backup" / "flux_in.py"), str(ex_path)])
        # 2. Self-Hosted
        c2, out2 = run_cmd([sys.executable, str(ROOT / "backup" / "flux_in.py"), str(ROOT / "src" / "main.flux"), "--target", "in", str(ex_path)])
        # 3. Independent Binary
        c3, out3 = run_cmd([str(BIN_FLUXC), "--target", "in", str(ex_path)])

        if c1 != 0:
            print(f"[{idx}/{len(EXAMPLES)}] [-] {ex_name}: Engine 1 (Reference) falhou (code {c1})")
            failed += 1
            continue
        if c2 != 0:
            print(f"[{idx}/{len(EXAMPLES)}] [-] {ex_name}: Engine 2 (Self-Hosted) falhou (code {c2})")
            failed += 1
            continue
        if c3 != 0:
            print(f"[{idx}/{len(EXAMPLES)}] [-] {ex_name}: Engine 3 (Binary) falhou (code {c3})")
            failed += 1
            continue

        if out1 == out2 == out3:
            print(f"[{idx}/{len(EXAMPLES)}] [+] 100% PARIDADE TRI-ENGINE: {ex_name}")
            passed += 1
        else:
            print(f"[{idx}/{len(EXAMPLES)}] [-] DIVERGÊNCIA DE SAÍDA: {ex_name}")
            if out1 != out2:
                print("  [Diff Engine 1 vs 2]:")
                print(f"  Ref:\n{out1[:200]}\n  Self-Hosted:\n{out2[:200]}")
            if out1 != out3:
                print("  [Diff Engine 1 vs 3]:")
                print(f"  Ref:\n{out1[:200]}\n  Binary:\n{out3[:200]}")
            failed += 1

    print("=" * 80)
    print(f"RESULTADO FINAL: {passed}/{len(EXAMPLES)} APROVADOS ({passed/len(EXAMPLES)*100:.1f}%)")
    print("=" * 80)

    if failed > 0:
        sys.exit(1)
    else:
        print("[+] TODOS OS EXEMPLOS POSSUEM 100% DE PARIDADE NAS TRÊS ENGINES!")
        sys.exit(0)

if __name__ == "__main__":
    main()
