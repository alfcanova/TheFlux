# Data Model: Project Directory Structure

The scaffold operates entirely on the file system. There are no application-level
entities. The "data model" is the directory tree itself.

## Directory Entity

| Attribute | Type | Description |
|-----------|------|-------------|
| `path` | string (relative) | Path from project root |
| `purpose` | string | What the directory stores |
| `parent` | string | Parent directory path |
| `children` | list of string | Subdirectory paths |

## Directory Index

| Path | Parent | Purpose |
|------|--------|---------|
| `docs/` | `.` | Documentation (white paper, grammar, keywords, HTML help) |
| `fdsl/` | `.` | Source files (.fdsl) for program libraries |
| `flux/` | `.` | Source files (.flux) for programs |
| `intermediates/` | `.` | Intermediate analysis and compiler debug files |
| `intermediates/ast/` | `intermediates/` | Abstract Syntax Tree (--emit-ast) |
| `intermediates/ddg/` | `intermediates/` | Data Dependency Graph (--emit-ddg) |
| `intermediates/lexer/` | `intermediates/` | Token stream (--emit-lexer) |
| `intermediates/llvm/` | `intermediates/` | LLVM IR (--emit-llvm) |
| `intermediates/parser/` | `intermediates/` | CST (--emit-parser) |
| `intermediates/semantic/` | `intermediates/` | Symbol table and type checking (--emit-semantic) |
| `intermediates/wat/` | `intermediates/` | WASM symbol table (--emit-wat) |
| `runtime/` | `.` | Runtime libraries (if needed) |
| `temp/` | `.` | Temporary script artifacts |
| `src/` | `.` | Root for compilation and test suites |
| `src/flux_proto/` | `src/` | CLI and all language development modules |
| `src/flux_proto/ast/` | `src/flux_proto/` | AST generator |
| `src/flux_proto/ddg/` | `src/flux_proto/` | Graph generator |
| `src/flux_proto/lexer/` | `src/flux_proto/` | Lexer generator |
| `src/flux_proto/llvm/` | `src/flux_proto/` | LLVM .ll object generator |
| `src/flux_proto/parser/` | `src/flux_proto/` | Parser generator |
| `src/flux_proto/semantic/` | `src/flux_proto/` | Semantic analyzer |
| `src/flux_proto/vm/` | `src/flux_proto/` | Bytecode VM |
| `src/flux_proto/wasm/` | `src/flux_proto/` | WASM backend |
| `src/flux_proto/wat/` | `src/flux_proto/` | WAT symbol table (--emit-wat) |
| `src/flux_tests/` | `src/` | Test CLI — covers all test categories |
| `stdlib/` | `.` | Standard library source files (.fdsl) |
| `t_llvm/` | `.` | LLVM native target |
| `t_wasm-1.0/` | `.` | WASM 1.0 target |
| `t_wasm-2.0/` | `.` | WASM 2.0 target |
| `t_wasm-3.0/` | `.` | WASM 3.0 target |
| `t_benchmarks/` | `.` | Benchmark metrics |
| `t_general/` | `.` | QA validation suites |
| `t_general/matrices/` | `t_general/` | Quality control matrices (rtm.csv, coverage.csv, defects.csv, test_cases.csv) |
| `t_general/metrics/` | `t_general/` | Performance tracking (metrics.json) |
| `t_general/negative/` | `t_general/` | Negative tests |
| `t_general/negative_false/` | `t_general/` | False negative tests |
| `t_general/positive/` | `t_general/` | Positive tests |
| `t_general/positive_false/` | `t_general/` | False positive tests |
| `t_general/regression/` | `t_general/` | Regression scenarios |

## Validation Rules

- All paths MUST be relative to project root
- Directory names MUST follow lowercase-with-hyphens convention
- `src/flux_proto/*` module directories MUST be valid Python package names
- Target directories (`t_*`) MUST follow the pattern `t_<backend>[-<version>]`
- Empty directories MUST contain a `.gitkeep` file for version tracking
