"""TheFlux Backend Driver: IN (AST/FMIR Native Interpreter).

Executes a .flux source file using the self-hosted native compiler's interpreter backend.
Zero dependencies on legacy prototype code.
"""
from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FLUXC_EXE = ROOT / "bin" / "fluxc.exe"


def main() -> int:
    if not FLUXC_EXE.exists():
        print(f"Error: Native compiler binary not found at {FLUXC_EXE}", file=sys.stderr)
        return 1

    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print("Usage: python flux_in.py <source.flux> [options...]", file=sys.stderr)
        print("Executes FLUX source file using the native interpreter backend.", file=sys.stderr)
        return 0 if args else 1

    cmd = [str(FLUXC_EXE), "--target", "in"] + args
    res = subprocess.run(cmd)
    return res.returncode


if __name__ == "__main__":
    sys.exit(main())
