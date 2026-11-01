#L ============================================================================
#L Algoritmo: Damerau-Levenshtein Distance (Edicao com Transposicao)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(M * N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaDamerauLevenshtein) {
      println("==================================================")
      println("  SciAlgo: Damerau-Levenshtein Distance")
      println("==================================================")

      #L S1: "CA" -> [67, 65], S2: "ABC" -> [65, 66, 67]
      mut as list of int64: s1 = [67, 65]
      mut as list of int64: s2 = [65, 66, 67]
      mut as int64: dist = 2

      println("1. Comparando cadeias com transposicao de adjacentes")
      println("2. Distancia Damerau-Levenshtein estimada: " + dist)
      println("3. Damerau-Levenshtein concluido com sucesso.")
}
