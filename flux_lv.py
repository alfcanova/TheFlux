"""TheFlux Backend Driver: LV (LLVM Native Compilation and Execution).

Compiles a .flux source file to LLVM IR (.ll) using the self-hosted native compiler,
compiles it to a native executable (.exe) using Clang and the Flux C runtime,
and optionally executes the resulting binary.
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
RUNTIME_C = ROOT / "runtime" / "flux_input.c"


def _find_clang() -> str | None:
    candidates = [
        shutil.which("clang"),
        r"C:\Program Files\LLVM\bin\clang.exe",
        r"C:\Arquivos de Programas\LLVM\bin\clang.exe",
        str(ROOT / "llvm" / "bin" / "clang.exe"),
    ]
    for c in candidates:
        if c and Path(c).exists():
            try:
                res = subprocess.run([c, "--version"], capture_output=True)
                if res.returncode == 0:
                    return str(c)
            except Exception:
                continue
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
    if not FLUXC_EXE.exists():
        print(f"Error: Native compiler binary not found at {FLUXC_EXE}", file=sys.stderr)
        return 1

    clang_exe = _find_clang()
    if not clang_exe:
        print("Error: Clang not found (checked PATH, C:\\Program Files\\LLVM\\bin\\clang.exe)", file=sys.stderr)
        return 1

    if not RUNTIME_C.exists():
        print(f"Error: Runtime C file not found at {RUNTIME_C}", file=sys.stderr)
        return 1

    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print("Usage: python flux_lv.py <source.flux> [-o <output_base>] [--no-run] [args...]", file=sys.stderr)
        print("Compiles FLUX to native binary via LLVM IR and Clang, and executes it.", file=sys.stderr)
        return 0 if args else 1

    input_file, output_base, no_run, extra_args = _parse_args(args)
    if not input_file:
        print("Error: No input .flux file specified.", file=sys.stderr)
        return 1

    in_path = Path(input_file)
    if not in_path.exists():
        print(f"Error: File not found: {in_path}", file=sys.stderr)
        return 1

    if not output_base:
        output_base = str(in_path.with_suffix(""))

    # 1. Emit LLVM IR
    cmd_ir = [str(FLUXC_EXE), "--target", "llvm", "-o", output_base, str(in_path)]
    res_ir = subprocess.run(cmd_ir, capture_output=True, text=True)
    if res_ir.returncode != 0:
        if res_ir.stdout:
            print(res_ir.stdout, file=sys.stdout)
        if res_ir.stderr:
            print(res_ir.stderr, file=sys.stderr)
        return res_ir.returncode

    ll_path = Path(output_base if output_base.endswith(".ll") else output_base + ".ll")
    if not ll_path.exists():
        # Fallback check
        alt = ROOT / "intermediates" / "llvm" / f"{in_path.stem}.ll"
        if alt.exists():
            ll_path = alt
        else:
            print(f"Error: LLVM IR file not found at {ll_path}", file=sys.stderr)
            return 1

    # Unescape literal \n if present in the LLVM IR
    try:
        content = ll_path.read_text(encoding="utf-8", errors="replace")
        if "\\n" in content and not ("\n" in content and len(content.splitlines()) > 5):
            ll_path.write_text(content.replace("\\n", "\n").replace('\\"', '"'), encoding="utf-8")
    except Exception:
        pass

    # 2. Compile to native executable via Clang
    exe_path = Path(output_base if output_base.endswith(".exe") else output_base + ".exe")
    clang_cmd = [
        clang_exe,
        "-O2",
        "-Wno-deprecated-declarations",
        "-o",
        str(exe_path),
        str(ll_path),
        str(RUNTIME_C),
    ]
    res_clang = subprocess.run(clang_cmd, capture_output=True, text=True)
    if res_clang.returncode != 0:
        print(f"Error: Clang compilation failed:\n{res_clang.stderr}", file=sys.stderr)
        return res_clang.returncode

    print(f"[+] Native executable built: {exe_path}")

    # 3. Execute native binary unless --no-run was specified
    if no_run:
        return 0

    run_cmd = [str(exe_path.resolve())] + extra_args
    res_run = subprocess.run(run_cmd)
    return res_run.returncode


if __name__ == "__main__":
    sys.exit(main())
