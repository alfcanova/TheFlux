"""TheFlux Backend Driver: VMR (Bytecode Loader & VM Runner via .\\src)."""
from __future__ import annotations
import json
import sys
import tempfile
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))


def main() -> int:
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        print("Usage: python flux_vmr.py <file.fvmbc|file.flux>", file=sys.stderr)
        return 0 if len(sys.argv) >= 2 else 1

    path = Path(sys.argv[1])
    if not path.exists():
        print(f"Error: file not found: {path}", file=sys.stderr)
        return 1

    if path.suffix == ".fvmbc":
        with open(path, encoding="utf-8") as f:
            bc = json.load(f)
        from flux_proto.vm.runtime import execute_bytecode
        execute_bytecode(bc)
        return 0
    elif path.suffix == ".flux":
        from flux_proto.cli import main as cli_main
        from flux_proto.vm.runtime import execute_bytecode

        with tempfile.TemporaryDirectory() as tmpdir:
            out_base = Path(tmpdir) / path.stem
            rc = cli_main([str(path), "--target", "vmbc", "--output", str(out_base)])
            if rc != 0:
                return rc
            fvmbc_path = out_base.with_suffix(".fvmbc")
            with open(fvmbc_path, encoding="utf-8") as f:
                bc = json.load(f)
            execute_bytecode(bc)
        return 0
    else:
        print(f"Error: unsupported file extension: {path.suffix} (expected .fvmbc or .flux)", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
