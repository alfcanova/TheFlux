"""TheFlux Backend Driver: WAS (WebAssembly Binary & Wasmer Runner).

Compiles a .flux source file to WebAssembly binary (.wasm) using the self-hosted native compiler,
and executes it using Wasmer.
Zero dependencies on legacy prototype code.
"""
from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FLUXC_EXE = ROOT / "bin" / "fluxc.exe"


def _find_wasmer() -> str | None:
    p = shutil.which("wasmer")
    if p:
        return p
    c = Path.home() / ".wasmer" / "bin" / "wasmer.exe"
    if c.exists():
        return str(c)
    return None


def _parse_args(args: list[str]) -> tuple[str | None, str | None, bool, list[str]]:
    input_file = None
    output_base = None
    no_run = False
    pass_through = []
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--no-run":
            no_run = True
            i += 1
            continue
        if a in ("-o", "--output") and i + 1 < len(args):
            output_base = args[i + 1]
            i += 2
            continue
        if a == "--target" and i + 1 < len(args):
            i += 2
            continue
        if not a.startswith("-") and input_file is None:
            input_file = a
            i += 1
            continue
        pass_through.append(a)
        i += 1
    return input_file, output_base, no_run, pass_through


def main() -> int:
    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print("Usage: python flux_was.py <source.flux|source.wasm> [-o <output_base>] [--no-run] [args...]", file=sys.stderr)
        print("Compiles FLUX source file to WebAssembly binary (.wasm) and executes it on Wasmer.", file=sys.stderr)
        return 0 if args else 1

    input_file, output_base, no_run, extra_args = _parse_args(args)
    if not input_file:
        print("Error: No input file specified.", file=sys.stderr)
        return 1

    in_path = Path(input_file)
    if not in_path.exists():
        print(f"Error: File not found: {in_path}", file=sys.stderr)
        return 1

    if in_path.suffix == ".wasm":
        wasm_path = in_path
    elif in_path.suffix == ".flux":
        if not FLUXC_EXE.exists():
            print(f"Error: Native compiler binary not found at {FLUXC_EXE}", file=sys.stderr)
            return 1

        if not output_base:
            output_base = str(in_path.with_suffix(""))

        cmd = [str(FLUXC_EXE), "--target", "wasm", "-o", output_base, str(in_path)]
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode != 0:
            if res.stdout:
                print(res.stdout, file=sys.stdout)
            if res.stderr:
                print(res.stderr, file=sys.stderr)
            return res.returncode

        wasm_path = Path(output_base if output_base.endswith(".wasm") else output_base + ".wasm")
        if not wasm_path.exists():
            print(f"Error: WASM file not generated at {wasm_path}", file=sys.stderr)
            return 1

        print(f"[+] WASM binary generated: {wasm_path}")
    else:
        print(f"Error: Unsupported file extension '{in_path.suffix}' (expected .flux or .wasm).", file=sys.stderr)
        return 1

    if no_run:
        return 0

    wasmer_exe = _find_wasmer()
    if not wasmer_exe:
        print("Error: Wasmer not found on PATH or in ~/.wasmer/bin/", file=sys.stderr)
        return 1

    run_cmd = [wasmer_exe, "run", "--forward-host-env", str(wasm_path.resolve())] + extra_args
    res_run = subprocess.run(run_cmd)
    return res_run.returncode


if __name__ == "__main__":
    sys.exit(main())
