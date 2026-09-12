# Research: Project Directory Structure

## Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| PowerShell native (`New-Item`) | User confirmed native Windows tools; PowerShell is built-in, no dependencies | Python script (rejected — user wants native Windows) |
| Idempotent scaffold (`-Force` flag) | Safe to re-run; no error on existing dirs | Check-then-create (rejected — `-Force` is idiomatic) |
| `.gitkeep` files for empty dirs | Git does not track empty directories | `.gitignore` with `!.gitkeep` (equivalent) |
| Flat target dirs (`t_llvm/`, `t_wasm-*`) | Each target is self-contained per FR-004 | Nested under `targets/` (rejected — spec defines flat layout) |

## Resolved Clarifications

- **Tool**: PowerShell 7+ native cmdlets (not Python)
- **File format**: `.ps1` script at project root as `scaffold.ps1`
