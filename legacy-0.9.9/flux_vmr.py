"""Shortcut: load and execute VM bytecode (.fvmbc) or compile+run a .flux file."""
from __future__ import annotations
import sys
import json
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python flux_run_vm.py <file.fvmbc|file.flux>", file=sys.stderr)
        sys.exit(1)

    path = Path(sys.argv[1])
    if not path.exists():
        print(f"Error: file not found: {path}", file=sys.stderr)
        sys.exit(1)

    if path.suffix == ".fvmbc":
        with open(path) as f:
            bc = json.load(f)
        from flux_proto.vm.runtime import execute_bytecode
        execute_bytecode(bc)
    elif path.suffix == ".flux":
        from flux_proto.lexer.lexer import lex
        from flux_proto.parser.parser import parse
        from flux_proto.parser.import_resolver import resolve_imports
        from flux_proto.vm.compiler import compile_to_bytecode
        from flux_proto.vm.runtime import execute_bytecode

        with open(path, 'rb') as f:
            raw = f.read()
        source = raw.decode('latin-1')

        tokens = lex(source)
        program = parse(tokens, str(path))
        if hasattr(program, "use_decls"):
            program.imports = resolve_imports(program, str(path))
        bc = compile_to_bytecode(program)
        execute_bytecode(bc)
    else:
        print(f"Error: unsupported file extension: {path.suffix} (expected .fvmbc or .flux)", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
