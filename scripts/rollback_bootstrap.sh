#!/usr/bin/env bash
set -e

echo "=============================================================================="
echo "[TheFlux] Script de Rollback Transacional do Compilador"
echo "=============================================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

TARGET_TIER="$1"

if [ -z "${TARGET_TIER}" ]; then
    echo "Uso: bash scripts/rollback_bootstrap.sh [--prev | --last-good | --golden]"
    echo "  --prev      : Restaura a versao de bin/ imediatamente anterior ao ultimo build"
    echo "  --last-good : Restaura o ultimo compilador aprovado em fixpoint stage2/stage3"
    echo "  --golden    : Restaura a semente base imutavel de bootstrap/seed/"
    exit 1
fi

FLUXC_NAME="fluxc"
[ -f "bin/fluxc.exe" ] && FLUXC_NAME="fluxc.exe"
FLUXVM_NAME="fluxvm"
[ -f "bin/fluxvm.exe" ] && FLUXVM_NAME="fluxvm.exe"

if [ "${TARGET_TIER}" == "--prev" ]; then
    echo "[*] Executando Rollback para --prev (build/lkg/prev/)..."
    if [ ! -f "build/lkg/prev/${FLUXC_NAME}" ]; then
        echo "[ERRO] Snapshot build/lkg/prev/${FLUXC_NAME} nao encontrado!"
        exit 1
    fi
    cp -f "build/lkg/prev/${FLUXC_NAME}" "bin/${FLUXC_NAME}"
    [ -f "build/lkg/prev/${FLUXVM_NAME}" ] && cp -f "build/lkg/prev/${FLUXVM_NAME}" "bin/${FLUXVM_NAME}"
    echo "[OK] Rollback para --prev concluido com sucesso!"
    "./bin/${FLUXC_NAME}" --version
    exit 0
fi

if [ "${TARGET_TIER}" == "--last-good" ]; then
    echo "[*] Executando Rollback para --last-good (build/lkg/last-good/)..."
    if [ ! -f "build/lkg/last-good/${FLUXC_NAME}" ]; then
        echo "[ERRO] Snapshot build/lkg/last-good/${FLUXC_NAME} nao encontrado!"
        exit 1
    fi
    cp -f "build/lkg/last-good/${FLUXC_NAME}" "bin/${FLUXC_NAME}"
    [ -f "build/lkg/last-good/${FLUXVM_NAME}" ] && cp -f "build/lkg/last-good/${FLUXVM_NAME}" "bin/${FLUXVM_NAME}"
    echo "[OK] Rollback para --last-good concluido com sucesso!"
    "./bin/${FLUXC_NAME}" --version
    exit 0
fi

if [ "${TARGET_TIER}" == "--golden" ]; then
    echo "[*] Executando Rollback para --golden (bootstrap/seed/)..."
    mkdir -p bin lib
    cp -f "bootstrap/seed/bin/${FLUXC_NAME}" "bin/${FLUXC_NAME}"
    [ -f "bootstrap/seed/bin/${FLUXVM_NAME}" ] && cp -f "bootstrap/seed/bin/${FLUXVM_NAME}" "bin/${FLUXVM_NAME}"
    [ -f "bootstrap/seed/lib/libfluxrt.a" ] && cp -f "bootstrap/seed/lib/libfluxrt.a" "lib/libfluxrt.a"
    [ -f "bootstrap/seed/lib/fluxrt.lib" ] && cp -f "bootstrap/seed/lib/fluxrt.lib" "lib/fluxrt.lib"
    echo "[OK] Rollback para --golden concluido com sucesso!"
    "./bin/${FLUXC_NAME}" --version
    exit 0
fi

echo "[ERRO] Parametro desconhecido: ${TARGET_TIER}"
echo "Uso: bash scripts/rollback_bootstrap.sh [--prev | --last-good | --golden]"
exit 1
