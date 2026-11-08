#!/usr/bin/env bash
set -e

echo "=============================================================================="
echo "[TheFlux] Compilacao Nativa de Ferramentas (src/tools/*)"
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

if [ ! -d "src/tools" ]; then
    echo "[ERRO] Diretorio src/tools nao encontrado."
    exit 1
fi

mkdir -p bin
shopt -s nullglob

TOTAL_TOOLS=0

compile_tool() {
    local src_file="$1"
    local out_name="$2"
    echo "    [*] Compilando ${src_file} -> bin/${out_name}..."
    rm -f "bin/${out_name}" "bin/${out_name}.exe" "bin/${out_name}.ll"
    "${FLUXC_BIN}" --no-run --emit-llvm --target llvm -o "bin/${out_name}" "${src_file}"
    if [ -f "scripts/patch_tool_ll.py" ]; then
        python3 scripts/patch_tool_ll.py "bin/${out_name}.ll" 2>/dev/null || python scripts/patch_tool_ll.py "bin/${out_name}.ll" 2>/dev/null || true
        clang -O2 -Wno-deprecated-declarations -Wno-override-module -o "bin/${out_name}" "bin/${out_name}.ll" -Llib -lfluxcompiler -lfluxrt -lm -lpthread 2>/dev/null || true
    fi
    if [ ! -f "bin/${out_name}.exe" ] && [ ! -f "bin/${out_name}" ]; then
        echo "[ERRO] Binario bin/${out_name} nao foi gerado."
        exit 1
    fi
    rm -f "bin/${out_name}.ll"
    TOTAL_TOOLS=$((TOTAL_TOOLS + 1))
}

# 2. Compilacao de arquivos diretos em src/tools/*.flux
for f in src/tools/*.flux; do
    base="$(basename "${f}" .flux)"
    compile_tool "${f}" "${base}"
done

# 3. Compilacao de ferramentas organizadas em subpastas src/tools/<nome>/
for d in src/tools/*/; do
    [ -d "${d}" ] || continue
    tool_name="$(basename "${d}")"
    if [ -f "src/tools/${tool_name}/${tool_name}.flux" ]; then
        compile_tool "src/tools/${tool_name}/${tool_name}.flux" "${tool_name}"
    elif [ -f "src/tools/${tool_name}/main.flux" ]; then
        compile_tool "src/tools/${tool_name}/main.flux" "${tool_name}"
    else
        for f in "src/tools/${tool_name}"/*.flux; do
            base="$(basename "${f}" .flux)"
            compile_tool "${f}" "${base}"
        done
    fi
done

if [ "${TOTAL_TOOLS}" -eq 0 ]; then
    echo "[AVISO] Nenhuma ferramenta .flux encontrada em src/tools/."
else
    echo "[OK] ${TOTAL_TOOLS} ferramenta(s) compilada(s) com exito em bin/."
fi

echo "=============================================================================="
echo "[SUCESSO] Compilacao de src/tools concluida (${TOTAL_TOOLS} ferramenta(s))."
echo "=============================================================================="
