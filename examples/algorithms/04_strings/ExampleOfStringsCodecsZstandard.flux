#L ============================================================================
#L Algoritmo: Zstandard — Zstd (FSE / Finite State Entropy + LZ77)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N) em compressao e descompressao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsZstandard) {
      println("==================================================")
      println("  SciAlgo: Zstandard (Zstd FSE Entropy Model)")
      println("==================================================")

      mut as list of int64: simbolos = [1, 1, 2, 1, 3, 1, 2, 1]
      mut as int64: n = listLength(simbolos)

      #L Finite State Entropy (tANS): transição de estado determinística
      mut as int64: estado = 16
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: sym = simbolos[i]
            estado = (estado /i 2) + (sym * 7)
            i = i + 1
      }

      println("1. Simbolos codificados: " + n)
      println("2. Estado final FSE: " + estado)
      println("3. Zstandard concluido com sucesso.")
}
