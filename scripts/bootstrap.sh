#!/usr/bin/env bash
set -e

echo "=============================================================================="
echo "[TheFlux] Pipeline de Bootstrapping 100% Nativo (Marco M5)"
echo "=============================================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

if ! command -v clang &> /dev/null; then
    echo "[ERRO] clang nao encontrado no PATH."
    exit 1
fi

if ! command -v llvm-ar &> /dev/null; then
    echo "[ERRO] llvm-ar nao encontrado no PATH."
    exit 1
fi

# 1. Boot-0: Runtime
echo "[+] [Boot-0] Compilando Runtime Modular C..."
bash scripts/build_runtime.sh

# 2. Boot-0.5: Compiler Library
echo "[+] [Boot-0.5] Empacotando libfluxcompiler.a..."
mkdir -p build/intermediates bin
if [ -f "build/intermediates/stage1_compiler.ll" ]; then
    clang -O2 -Wno-deprecated-declarations -Wno-override-module -c build/intermediates/stage1_compiler.ll -o build/intermediates/stage1_compiler.o
fi

rm -f bin/libfluxcompiler.a bin/fluxcompiler.lib
llvm-ar rc bin/libfluxcompiler.a build/intermediates/stage1_compiler.o
cp -f bin/libfluxcompiler.a bin/fluxcompiler.lib 2>/dev/null || true

if [ ! -f "bin/fluxc" ] && [ ! -f "bin/fluxc.exe" ]; then
    echo "[+] [Boot-0.8] Linkando bin/fluxc a partir de stage1.ll..."
    clang -O2 -Wno-deprecated-declarations -Wno-override-module -o bin/fluxc.exe build/intermediates/stage1.ll -Lbin -lfluxcompiler -lfluxrt -lm
fi

FLUXC_BIN="./bin/fluxc.exe"
[ -f "./bin/fluxc" ] && FLUXC_BIN="./bin/fluxc"

# 3. Boot-1: Autonomia
echo "[+] [Boot-1] Verificando autonomia de ${FLUXC_BIN}..."
${FLUXC_BIN} --version > /dev/null
${FLUXC_BIN} -v > /dev/null
${FLUXC_BIN} --explain E0001 > /dev/null
echo "[OK] Portao Boot-1 Aprovado."

# 4. Boot-2: Fixpoint
echo "[+] [Boot-2] Iniciando Certificacao de Fixpoint..."
${FLUXC_BIN} --no-run --target llvm -o build/intermediates/stage2 src/main.flux

STAGE2_BIN="./build/intermediates/stage2.exe"
[ -f "./build/intermediates/stage2" ] && STAGE2_BIN="./build/intermediates/stage2"

${STAGE2_BIN} --no-run --target llvm -o build/intermediates/stage3 src/main.flux

if cmp -s build/intermediates/stage2.ll build/intermediates/stage3.ll; then
    echo "=============================================================================="
    echo "[SUCESSO] FIXPOINT DETERMINISTICO ATINGIDO COM ZERO BYTES DE DIVERGENCIA!"
    echo "=============================================================================="
    cp -f "${STAGE2_BIN}" "${FLUXC_BIN}"
else
    echo "[ERRO] DIVERGENCIA DETECTADA entre stage2.ll e stage3.ll."
    exit 1
fi

# 5. FluxVM
echo "[+] Compilando bin/fluxvm..."
clang -O3 -Wno-deprecated-declarations -Iruntime -Iruntime/fvm \
    runtime/fvm/fvm_arena.c runtime/fvm/fvm_parser.c runtime/fvm/fvm_core.c runtime/fvm/fvm_main.c runtime/flux_service.c \
    -o bin/fluxvm.exe

echo "=============================================================================="
echo "[TheFlux] BOOTSTRAPPING CONCLUIDO COM EXITO 100% NATIVO (MARCO M5)!"
echo "=============================================================================="
