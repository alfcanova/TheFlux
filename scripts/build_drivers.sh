#!/usr/bin/env bash
set -e

echo "=============================================================================="
echo "[TheFlux] Recompilacao Nativa de Drivers (flux_*) e Suites (examples_*)"
echo "=============================================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

# 1. Verificacao de Pre-requisitos
FLUXC_BIN="./bin/fluxc.exe"
if [ -f "./bin/fluxc" ]; then
    FLUXC_BIN="./bin/fluxc"
fi

if [ ! -f "${FLUXC_BIN}" ]; then
    echo "[ERRO] bin/fluxc nao encontrado. Execute scripts/bootstrap.sh primeiro."
    exit 1
fi

if ! command -v clang &> /dev/null; then
    echo "[ERRO] clang nao encontrado no PATH. Instale o LLVM 18+ para continuar."
    exit 1
fi

mkdir -p bin
shopt -s nullglob

TOTAL_DRIVERS=0
TOTAL_EXAMPLES=0

# 2. Recompilacao de ./flux_*.flux -> bin/flux_*
echo "[+] [1/2] Recompilando drivers da raiz (./flux_*.flux)..."
for f in flux_*.flux; do
    base="$(basename "${f}" .flux)"
    echo "    [*] Compilando ${f} -> bin/${base}..."
    rm -f "bin/${base}" "bin/${base}.exe" "bin/${base}.ll"
    "${FLUXC_BIN}" --no-run --target llvm -o "bin/${base}" "${f}"
    if [ ! -f "bin/${base}.exe" ] && [ ! -f "bin/${base}" ]; then
        echo "[ERRO] Binario bin/${base} nao foi gerado."
        exit 1
    fi
    rm -f "bin/${base}.ll"
    TOTAL_DRIVERS=$((TOTAL_DRIVERS + 1))
done
echo "[OK] ${TOTAL_DRIVERS} drivers flux_* gerados com exito."

# 3. Recompilacao de examples/examples_*.flux -> bin/examples_*
echo "[+] [2/2] Recompilando executores de exemplos (examples/examples_*.flux)..."
for f in examples/examples_*.flux; do
    base="$(basename "${f}" .flux)"
    echo "    [*] Compilando ${f} -> bin/${base}..."
    rm -f "bin/${base}" "bin/${base}.exe" "bin/${base}.ll"
    "${FLUXC_BIN}" --no-run --target llvm -o "bin/${base}" "${f}"
    if [ ! -f "bin/${base}.exe" ] && [ ! -f "bin/${base}" ]; then
        echo "[ERRO] Binario bin/${base} nao foi gerado."
        exit 1
    fi
    TOTAL_EXAMPLES=$((TOTAL_EXAMPLES + 1))
done
echo "[OK] ${TOTAL_EXAMPLES} executores examples_* gerados com exito."

echo "=============================================================================="
echo "[SUCESSO] Recompilacao concluida (${TOTAL_DRIVERS} drivers + ${TOTAL_EXAMPLES} suites)."
echo "=============================================================================="
