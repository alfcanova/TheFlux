#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=============================================================================="
echo "[TheFlux] Compilando Runtime Modular C para bin/libfluxrt.a (Marco M1)"
echo "=============================================================================="

mkdir -p "$ROOT_DIR/build/runtime"
mkdir -p "$ROOT_DIR/bin"

CFLAGS="-O2 -Wno-deprecated-declarations -Wno-override-module -Wno-incompatible-pointer-types -I$ROOT_DIR/runtime/include"

cd "$ROOT_DIR/build/runtime"
rm -f *.o

clang $CFLAGS -c $ROOT_DIR/runtime/src/core/*.c
clang $CFLAGS -c $ROOT_DIR/runtime/src/memory/*.c
clang $CFLAGS -c $ROOT_DIR/runtime/src/strings/*.c
clang $CFLAGS -c $ROOT_DIR/runtime/src/collections/*.c
clang $CFLAGS -c $ROOT_DIR/runtime/src/io/*.c
clang $CFLAGS -c $ROOT_DIR/runtime/src/sys/*.c
clang $CFLAGS -c $ROOT_DIR/runtime/src/intrinsics/*.c

llvm-ar rcs "$ROOT_DIR/bin/libfluxrt.a" *.o
echo "[OK] bin/libfluxrt.a gerado com sucesso."
