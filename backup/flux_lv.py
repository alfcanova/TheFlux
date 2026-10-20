"""Shortcut: compile a FLUX source file to LLVM IR, then to native executable.

Uses clang for native compilation.

Prerequisites:
  - clang available on PATH for native linking
"""
from __future__ import annotations
import os
import subprocess
import sys
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from flux_proto.cli import main


def _find_input(argv: list[str]) -> str | None:
    i = 1
    while i < len(argv):
        a = argv[i]
        if a == "--target" and i + 1 < len(argv):
            i += 2
            continue
        if a in ("-o", "--output") and i + 1 < len(argv):
            i += 2
            continue
        if a.startswith("-"):
            i += 1
            continue
        return a
    return None


def _find_output_base(argv: list[str]) -> str | None:
    for i, a in enumerate(argv):
        if a in ("-o", "--output") and i + 1 < len(argv):
            raw = argv[i + 1]
            return raw if raw.endswith(".ll") else raw + ".ll"
    return None


if __name__ == "__main__":
    try:
        idx = sys.argv.index("--target")
        sys.argv[idx + 1] = "llvm"
    except ValueError:
        sys.argv.insert(1, "--target")
        sys.argv.insert(2, "llvm")

    main()

    input_file = _find_input(sys.argv)
    if input_file is None:
        sys.exit(1)

    ll_path = _find_output_base(sys.argv) or os.path.splitext(input_file)[0] + ".ll"

    if not os.path.exists(ll_path):
        print(f"Error: {ll_path} not found", file=sys.stderr)
        sys.exit(1)

    exe_dir = os.path.dirname(os.path.abspath(input_file))
    exe_name = os.path.splitext(os.path.basename(input_file))[0] + ".exe"
    exe_path = os.path.join(exe_dir, exe_name)

    clang_candidates = [
        "clang",
        str(ROOT / "llvm" / "bin" / "clang"),
        "C:\\Program Files\\LLVM\\bin\\clang.exe",
    ]
    clang_exe = None
    for c in clang_candidates:
        try:
            subprocess.run([c, "--version"], check=True, capture_output=True)
            clang_exe = c
            break
        except (FileNotFoundError, subprocess.CalledProcessError):
            continue
    if clang_exe is None:
        print("Error: clang not found (checked PATH, ./llvm/bin/, C:\\Program Files\\LLVM\\bin\\)", file=sys.stderr)
        sys.exit(1)

    try:
        runtime_c = ROOT / "src" / "flux_proto" / "llvm" / "runtime" / "flux_input.c"
        subprocess.run(
            [clang_exe, "-o", exe_path, ll_path, str(runtime_c)],
            check=True,
            capture_output=True,
            text=True,
        )
        print(f"Executable: {exe_path}", file=sys.stderr)
    except subprocess.CalledProcessError as e:
        print(f"clang failed:\n{e.stderr}", file=sys.stderr)
        sys.exit(1)
