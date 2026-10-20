"""TheFlux Backend Driver: WAT (WebAssembly Text & Assembler).

Compiles a .flux source file to WebAssembly Text format (.wat) using the self-hosted native compiler,
and optionally compiles to WebAssembly binary (.wasm) using wat2wasm if available.
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
WABT_DIR = ROOT.parent / "wabt-1.0.41" / "bin"


def _find_wat2wasm() -> str | None:
    p = shutil.which("wat2wasm")
    if p:
        return p
    c = WABT_DIR / "wat2wasm.exe"
    if c.exists():
        return str(c)
    return None


def _parse_args(args: list[str]) -> tuple[str | None, str | None, bool, list[str]]:
    input_file = None
    output_base = None
    wat_only = False
    pass_through = []
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--wat-only":
            wat_only = True
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
    return input_file, output_base, wat_only, pass_through


def main() -> int:
    if not FLUXC_EXE.exists():
        print(f"Error: Native compiler binary not found at {FLUXC_EXE}", file=sys.stderr)
        return 1

    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print("Usage: python flux_wat.py <source.flux> [-o <output_base>] [--wat-only] [options...]", file=sys.stderr)
        print("Compiles FLUX source file to WebAssembly Text (.wat) and binary (.wasm).", file=sys.stderr)
        return 0 if args else 1

    input_file, output_base, wat_only, extra_args = _parse_args(args)
    if not input_file:
        print("Error: No input .flux file specified.", file=sys.stderr)
        return 1

    in_path = Path(input_file)
    if not in_path.exists():
        print(f"Error: File not found: {in_path}", file=sys.stderr)
        return 1

    if not output_base:
        output_base = str(in_path.with_suffix(""))

    # 1. Compile to WAT via fluxc
    cmd = [str(FLUXC_EXE), "--target", "wat", "-o", output_base, str(in_path)] + extra_args
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        if res.stdout:
            print(res.stdout, file=sys.stdout)
        if res.stderr:
            print(res.stderr, file=sys.stderr)
        return res.returncode

    wat_path = Path(output_base if output_base.endswith(".wat") else output_base + ".wat")
    if not wat_path.exists():
        print(f"Error: WAT file not found at {wat_path}", file=sys.stderr)
        return 1

    # Unescape literal \n if present in the WAT file
    try:
        content = wat_path.read_text(encoding="utf-8", errors="replace")
        if "\\n" in content and not ("\n" in content and len(content.splitlines()) > 5):
            wat_path.write_text(content.replace("\\n", "\n").replace('\\"', '"'), encoding="utf-8")
    except Exception:
        pass

    print(f"[+] WAT file generated: {wat_path}")

    # 2. Assemble to WASM if wat2wasm is available and not disabled
    if not wat_only:
        w2w = _find_wat2wasm()
        if w2w:
            wasm_path = Path(output_base if output_base.endswith(".wasm") else output_base + ".wasm")
            w_res = subprocess.run([w2w, str(wat_path), "-o", str(wasm_path)], capture_output=True, text=True)
            if w_res.returncode == 0 and wasm_path.exists():
                print(f"[+] WASM binary assembled: {wasm_path}")
            else:
                print(f"Warning: wat2wasm failed:\n{w_res.stderr}", file=sys.stderr)

    return 0


if __name__ == "__main__":
    sys.exit(main())
