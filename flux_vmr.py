"""TheFlux Backend Driver: VMR (Bytecode Runner & Just-In-Time VM Exec).

Loads and executes VM bytecode (.fvmbc) on the native FluxVM, or compiles a .flux
source file to bytecode on the fly and immediately runs it on the VM.
Zero dependencies on legacy prototype code.
"""
from __future__ import annotations

import os
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FLUXC_EXE = ROOT / "bin" / "fluxc.exe"
FLUXVM_EXE = ROOT / "bin" / "fluxvm.exe"


def _extract_file_and_flags(args: list[str]) -> tuple[str | None, list[str]]:
    target_file = None
    flags = []
    for a in args:
        if not a.startswith("-") and target_file is None:
            target_file = a
        else:
            flags.append(a)
    return target_file, flags


def main() -> int:
    if not FLUXVM_EXE.exists():
        print(f"Error: Native VM binary not found at {FLUXVM_EXE}", file=sys.stderr)
        return 1

    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print("Usage: python flux_vmr.py <file.fvmbc|file.flux> [--bench] [options...]", file=sys.stderr)
        print("Executes bytecode directly or compiles and executes FLUX source on FluxVM.", file=sys.stderr)
        return 0 if args else 1

    input_arg, vm_flags = _extract_file_and_flags(args)
    if not input_arg:
        print("Error: No input file specified (expected .fvmbc or .flux).", file=sys.stderr)
        return 1

    in_path = Path(input_arg)
    if not in_path.exists():
        print(f"Error: File not found: {in_path}", file=sys.stderr)
        return 1

    if in_path.suffix == ".fvmbc":
        # Direct execution of precompiled bytecode
        cmd = [str(FLUXVM_EXE), "--inject", str(in_path.resolve())] + vm_flags
        res = subprocess.run(cmd)
        return res.returncode

    elif in_path.suffix == ".flux":
        if not FLUXC_EXE.exists():
            print(f"Error: Native compiler binary not found at {FLUXC_EXE}", file=sys.stderr)
            return 1

        # Compile .flux to bytecode first
        build_tmp = ROOT / "build" / "intermediates" / "tmp"
        build_tmp.mkdir(parents=True, exist_ok=True)
        tmp_bc_base = build_tmp / f"tmp_vmr_{os.getpid()}_{in_path.stem}"
        tmp_bc_file = Path(f"{tmp_bc_base}.fvmbc")

        try:
            build_cmd = [str(FLUXC_EXE), "--target", "vmr", "-o", str(tmp_bc_base), str(in_path.resolve())]
            build_res = subprocess.run(build_cmd, capture_output=True, text=True)
            if build_res.returncode != 0:
                if build_res.stdout:
                    print(build_res.stdout, file=sys.stdout)
                if build_res.stderr:
                    print(build_res.stderr, file=sys.stderr)
                return build_res.returncode

            if not tmp_bc_file.exists():
                print(f"Error: Failed to produce bytecode at {tmp_bc_file}", file=sys.stderr)
                return 1

            # Run bytecode on FluxVM
            run_cmd = [str(FLUXVM_EXE), "--inject", str(tmp_bc_file.resolve())] + vm_flags
            run_res = subprocess.run(run_cmd)
            return run_res.returncode
        finally:
            if tmp_bc_file.exists():
                try:
                    tmp_bc_file.unlink()
                except OSError:
                    pass

    else:
        print(f"Error: Unsupported file extension '{in_path.suffix}' (expected .fvmbc or .flux).", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
