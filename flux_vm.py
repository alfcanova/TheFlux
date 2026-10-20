"""TheFlux Backend Driver: VM (Bytecode Compiler).

Compiles a .flux source file into FVM bytecode (.fvmbc) using the self-hosted native compiler.
Zero dependencies on legacy prototype code.
"""
from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FLUXC_EXE = ROOT / "bin" / "fluxc.exe"


def _extract_io(args: list[str]) -> tuple[str | None, str | None, list[str]]:
    input_file = None
    output_base = None
    pass_through = []
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("-o", "--output") and i + 1 < len(args):
            output_base = args[i + 1]
            i += 2
            continue
        if a == "--target" and i + 1 < len(args):
            # Target is forced by this driver
            i += 2
            continue
        if not a.startswith("-") and input_file is None:
            input_file = a
            i += 1
            continue
        pass_through.append(a)
        i += 1
    return input_file, output_base, pass_through


def main() -> int:
    if not FLUXC_EXE.exists():
        print(f"Error: Native compiler binary not found at {FLUXC_EXE}", file=sys.stderr)
        return 1

    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print("Usage: python flux_vm.py <source.flux> [-o <output_base>] [options...]", file=sys.stderr)
        print("Compiles FLUX source file into FVM bytecode (.fvmbc).", file=sys.stderr)
        return 0 if args else 1

    input_file, output_base, extra = _extract_io(args)
    if not input_file:
        print("Error: No input .flux file specified.", file=sys.stderr)
        return 1

    in_path = Path(input_file)
    if not in_path.exists():
        print(f"Error: Input file '{in_path}' does not exist.", file=sys.stderr)
        return 1

    if not output_base:
        output_base = str(in_path.with_suffix(""))

    # bin/fluxc.exe --target vmr -o <output_base> <input_file>
    cmd = [str(FLUXC_EXE), "--target", "vmr", "-o", output_base, str(in_path)] + extra
    res = subprocess.run(cmd)
    if res.returncode == 0:
        bc_path = Path(output_base if output_base.endswith(".fvmbc") else output_base + ".fvmbc")
        if bc_path.exists():
            print(f"[+] Bytecode generated: {bc_path}")
    return res.returncode


if __name__ == "__main__":
    sys.exit(main())
