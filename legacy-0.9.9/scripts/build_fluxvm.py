#!/usr/bin/env python3
"""Script de Compilação do TheFlux Fast Virtual Machine (bin/fluxvm.exe)."""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BIN = ROOT / "bin"
RUNTIME = ROOT / "runtime"
FVM = RUNTIME / "fvm"


def build_fluxvm() -> bool:
    BIN.mkdir(parents=True, exist_ok=True)
    out_exe = BIN / "fluxvm.exe"

    clang = (
        shutil.which("clang")
        or r"C:\Program Files\LLVM\bin\clang.exe"
        or r"C:\Arquivos de Programas\LLVM\bin\clang.exe"
    )

    sources = [
        str(FVM / "fvm_arena.c"),
        str(FVM / "fvm_parser.c"),
        str(FVM / "fvm_core.c"),
        str(FVM / "fvm_main.c"),
        str(RUNTIME / "flux_service.c"),
    ]

    cmd = [
        clang,
        "-O3",
        "-Wno-deprecated-declarations",
        f"-I{RUNTIME}",
        f"-I{FVM}",
        *sources,
        "-ladvapi32",
        "-o",
        str(out_exe),
    ]

    print("[*] Compilando bin/fluxvm.exe via Clang -O3...")
    res = subprocess.run(cmd, cwd=str(ROOT), capture_output=True, text=True)
    if res.returncode != 0:
        print("[-] Erro na compilação do fluxvm.exe:")
        print(res.stderr)
        return False

    print(f"[+] Compilação concluída com sucesso: {out_exe} ({out_exe.stat().st_size // 1024} KB)")

    # Smoke Test
    test = subprocess.run([str(out_exe), "--version"], capture_output=True, text=True)
    if test.returncode == 0:
        print(f"[+] Smoke test aprovado: fluxvm v{test.stdout.strip()}")
        return True
    else:
        print(f"[-] Smoke test falhou com código {test.returncode}")
        return False


if __name__ == "__main__":
    if not build_fluxvm():
        sys.exit(1)
