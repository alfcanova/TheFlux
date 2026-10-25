"""TheFlux Backend Driver: LV (LLVM IR + Clang Native Execution via .\\src)."""
from __future__ import annotations
import os
import shutil
import subprocess
import sys
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.cli import main as cli_main


def _find_input(argv: list[str]) -> str | None:
    i = 1
    while i < len(argv):
        a = argv[i]
        if a in ("--target", "-o", "--output") and i + 1 < len(argv):
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
            return raw[:-3] if raw.endswith(".ll") else raw
    return None


if __name__ == "__main__":
    no_run = "--no-run" in sys.argv
    cli_args = [a for a in sys.argv[1:] if a != "--no-run"]
    input_file = _find_input(sys.argv)
    if input_file is None:
        sys.exit(1)

    t_llvm = ROOT / "t_llvm"
    t_llvm.mkdir(parents=True, exist_ok=True)
    out_base = _find_output_base(sys.argv) or str(t_llvm / Path(input_file).stem)

    if "-o" not in cli_args and "--output" not in cli_args:
        cli_args = ["-o", out_base] + cli_args

    if "--target" in cli_args:
        idx = cli_args.index("--target")
        cli_args[idx + 1] = "llvm"
    else:
        cli_args = ["--target", "llvm"] + cli_args

    rc = cli_main(cli_args)
    if rc != 0:
        sys.exit(rc)

    ll_path = out_base + ".ll"
    if not os.path.exists(ll_path):
        alt = ROOT / "intermediates" / "llvm" / (Path(input_file).stem + ".ll")
        if alt.exists():
            ll_path = str(alt)
        else:
            print(f"Error: {ll_path} not found", file=sys.stderr)
            sys.exit(1)

    exe_path = out_base + ".exe"
    clang_exe = (
        shutil.which("clang")
        or (r"C:\Program Files\LLVM\bin\clang.exe" if Path(r"C:\Program Files\LLVM\bin\clang.exe").exists() else None)
    )
    if clang_exe is None:
        print("Error: clang not found", file=sys.stderr)
        sys.exit(1)

    runtime_c = SRC / "flux_proto" / "llvm" / "runtime" / "flux_input.c"
    res = subprocess.run([clang_exe, "-o", exe_path, ll_path, str(runtime_c)], capture_output=True, text=True)
    if res.returncode != 0:
        print(f"clang failed:\n{res.stderr}", file=sys.stderr)
        sys.exit(1)

    print(f"Executable: {exe_path}", file=sys.stderr)
    if not no_run:
        run_res = subprocess.run([exe_path])
        sys.exit(run_res.returncode)
