import argparse
import sys
import os
import json

from flux_proto.token import TokenType
from flux_proto.lexer.lexer import lex, LexicalError
from flux_proto.parser.token_stream import ParseError
from flux_proto.parser.ast import FluxProgram


def main(argv: list[str] | None = None) -> int:
    for stream in (sys.stdout, sys.stderr):
        if stream is not None:
            try:
                stream.reconfigure(encoding="utf-8")
            except (AttributeError, ValueError):
                pass
    parser = argparse.ArgumentParser(description="TheFlux Compiler")
    parser.add_argument("--version", "-v", action="version", version="0.9.9")
    parser.add_argument("INPUT", nargs="?", default=None, help="Path to source file (.flux or .fdsl)")
    parser.add_argument("--explain", default=None, help="Explain an error code or mnemonic (e.g. TYP401, EXPECT_INT_GOT_FLOAT)")
    parser.add_argument("--target", default="run", choices=["run", "vmbc", "wat", "wasm", "llvm"])
    parser.add_argument("--output", "-o", default=None, help="Output path")
    parser.add_argument("--emit-ast", action="store_true")
    parser.add_argument("--emit-llvm", action="store_true")
    parser.add_argument("--emit-wat", action="store_true")
    parser.add_argument("--emit-lexer", action="store_true")
    raw_argv = argv if argv is not None else sys.argv[1:]
    args, extra_args = parser.parse_known_args(argv)
    if "--" in raw_argv:
        idx = raw_argv.index("--")
        sys.argv = [args.INPUT or ""] + raw_argv[idx + 1:]
    elif extra_args:
        if extra_args[0] == "--":
            extra_args = extra_args[1:]
        sys.argv = [args.INPUT or ""] + extra_args


    if args.explain:
        from flux_proto.diagnostics.catalog import get_diagnostic_def
        defn = get_diagnostic_def(args.explain)
        if not defn:
            print(f"Erro ou mnemônico '{args.explain}' não encontrado no catálogo.", file=sys.stderr)
            return 1
        print("=" * 70)
        print(f"CÓDIGO:     {defn.code}")
        print(f"MNEMÔNICO:  {defn.mnemonic}")
        print(f"SEVERIDADE: {defn.severity}")
        print(f"ARQUIVO:    {defn.yaml_file}")
        print("-" * 70)
        print(f"GATILHO:\n  {defn.trigger}\n")
        print(f"MENSAGEM:\n  {defn.message}\n")
        if defn.hint:
            print(f"DICA DE CORREÇÃO:\n  💡 {defn.hint}\n")
        if defn.example_bad:
            print(f"EXEMPLO INCORRETO:\n{defn.example_bad}\n")
        if defn.example_good:
            print(f"EXEMPLO CORRETO:\n{defn.example_good}\n")
        print("=" * 70)
        return 0

    if not args.INPUT:
        parser.print_help(sys.stderr)
        return 1

    if os.path.isdir(args.INPUT):
        base_dir_name = os.path.basename(os.path.normpath(args.INPUT))
        master_candidate = os.path.join(args.INPUT, f"{base_dir_name}.fdsl")
        if os.path.isfile(master_candidate):
            args.INPUT = master_candidate
        else:
            print(f"Error: modular library directory '{args.INPUT}' missing master file '{base_dir_name}.fdsl'", file=sys.stderr)
            return 1

    if not os.path.exists(args.INPUT):
        print(f"Error: input file not found: {args.INPUT}", file=sys.stderr)
        return 1

    with open(args.INPUT, 'rb') as f:
        raw = f.read()
    source = raw.decode('utf-8', errors='replace')

    try:
        token_list = list(lex(source))
        token_gen = iter(token_list)
    except LexicalError as e:
        from flux_proto.diagnostics.catalog import get_diagnostic_def
        defn = get_diagnostic_def(e.code)
        mnem = f" - {defn.mnemonic}" if defn else ""
        print(f"{args.INPUT}:{e.line},{e.column} -> [{e.code}{mnem}]: {e.message} (linha {e.line}, coluna {e.column})", file=sys.stderr)
        if defn and defn.hint:
            print(f"  💡 Dica: {defn.hint}", file=sys.stderr)
        return 1

    base = os.path.splitext(args.INPUT)[0]
    base_name = os.path.basename(base)

    if args.emit_lexer:
        os.makedirs("intermediates/lexer", exist_ok=True)
        with open(f"intermediates/lexer/{base_name}.json", "w") as f:
            json.dump([{"type": t.type.name, "lexeme": t.lexeme, "line": t.line, "col": t.column} for t in token_list], f, indent=2)
        if not any([args.emit_ast, args.emit_wat, args.emit_llvm]) and args.target == "run":
            return 0

    try:
        from flux_proto.parser.parser import parse
    except ImportError:
        print("Warning: parser not available yet — skipping parse phase", file=sys.stderr)
        return 0

    try:
        result = parse(token_gen, args.INPUT)
    except ParseError as e:
        from flux_proto.diagnostics.catalog import get_diagnostic_def
        code = "SYN100" if e.code in ("PAR001", "SYN100") else e.code
        defn = get_diagnostic_def(code)
        mnem = f" - {defn.mnemonic}" if defn else ""
        print(f"{args.INPUT}:{e.line},{e.column} -> [{code}{mnem}]: {e.message} (linha {e.line}, coluna {e.column})", file=sys.stderr)
        if defn and defn.hint:
            print(f"  💡 Dica: {defn.hint}", file=sys.stderr)
        return 1

    if isinstance(result, tuple):
        program, report = result
        if report.errors:
            for err in report.errors:
                print(f"  {err.message}", file=sys.stderr)
    else:
        program = result

    from flux_proto.parser.ast import FluxProgram, FdslFile
    if isinstance(program, FdslFile):
        from flux_proto.parser.import_resolver import _load_modular_dir
        input_dir = os.path.dirname(os.path.abspath(args.INPUT))
        input_base = os.path.basename(args.INPUT)
        parent_base = os.path.basename(input_dir)
        if input_base == f"{parent_base}.fdsl":
            try:
                program = _load_modular_dir(input_dir, os.path.abspath(args.INPUT), parent_base)
            except Exception as e:
                print(f"{args.INPUT}: error: {e}", file=sys.stderr)
                return 1
    elif isinstance(program, FluxProgram):
        from flux_proto.parser.import_resolver import resolve_imports, ImportError as FdslImportError
        try:
            program.imports = resolve_imports(program, args.INPUT)
        except FdslImportError as e:
            from flux_proto.diagnostics.catalog import get_diagnostic_def
            code = getattr(e, "code", "IMP201")
            defn = get_diagnostic_def(code)
            mnem = f" - {defn.mnemonic}" if defn else ""
            print(f"{args.INPUT}:0,0 -> [{code}{mnem}]: {e}", file=sys.stderr)
            if defn and defn.hint:
                print(f"  💡 Dica: {defn.hint}", file=sys.stderr)
            return 1

    if args.emit_ast:
        from flux_proto.parser.ast import ast_to_dict
        os.makedirs("intermediates/ast", exist_ok=True)
        with open(f"intermediates/ast/{base_name}.json", "w") as f:
            json.dump(ast_to_dict(program), f, indent=2)

    from flux_proto.semantic.analyzer import analyze
    from flux_proto.semantic.diagnostic import Severity
    try:
        sem = analyze(program, args.INPUT)
    except Exception as e:
        print(f"{args.INPUT}: error: semantic analysis failed: {e}", file=sys.stderr)
        return 1
    if sem is not None:
        from flux_proto.semantic.diagnostic import DiagnosticFormatter
        for d in sem.diagnostics:
            if d.severity == Severity.ERROR:
                print(DiagnosticFormatter.format(d, args.INPUT), file=sys.stderr)
        if any(d.severity == Severity.ERROR for d in sem.diagnostics):
            return 1

    output_path = args.output
    if not output_path:
        output_path = base

    target = args.target
    if target == "run":
        from flux_proto.interpreter.interpreter import interpret
        interpret(program)
    elif target == "vmbc":
        from flux_proto.vm.compiler import compile_to_bytecode
        from flux_proto.vm.runtime import _DT, _Chr, TensorVal
        bc = compile_to_bytecode(program)

        def _bc_default(o: object) -> object:
            if isinstance(o, _DT):
                return ["#dt", o.nanos]
            if isinstance(o, _Chr):
                return ["#chr", o.cp]
            if isinstance(o, complex):
                return ["#c", o.real, o.imag]
            if isinstance(o, TensorVal):
                return ["#tensor", o.dims, o.data, o.offset, o.strides()]
            raise TypeError(f"Object of type {type(o).__name__} is not JSON serializable")

        fvmbc_path = output_path + ".fvmbc"
        with open(fvmbc_path, "w", encoding="utf-8") as f:
            json.dump(bc, f, indent=2, default=_bc_default, ensure_ascii=False)
        print(f"Bytecode written to {fvmbc_path}", file=sys.stderr)
    elif target == "wat":
        from flux_proto.wat.codegen import generate_wat
        wat_path = output_path + ".wat"
        generate_wat(program, wat_path)
        print(f"WAT written to {wat_path}", file=sys.stderr)
    elif target == "wasm":
        from flux_proto.wasm.codegen import generate_wasm
        wasm_path = output_path + ".wasm"
        generate_wasm(program, wasm_path)
        print(f"WASM written to {wasm_path}", file=sys.stderr)
    elif target == "llvm":
        from flux_proto.llvm.codegen import generate_llvm
        generate_llvm(program, output_path)
        print(f"LLVM output generated", file=sys.stderr)

    if args.emit_wat:
        from flux_proto.wat.codegen import generate_wat
        os.makedirs("intermediates/wat", exist_ok=True)
        generate_wat(program, f"intermediates/wat/{base_name}.wat")

    if args.emit_llvm:
        from flux_proto.llvm.codegen import generate_llvm
        os.makedirs("intermediates/llvm", exist_ok=True)
        generate_llvm(program, f"intermediates/llvm/{base_name}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
