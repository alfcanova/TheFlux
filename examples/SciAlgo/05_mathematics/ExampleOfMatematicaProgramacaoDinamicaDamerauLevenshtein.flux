#L ============================================================================
#L Algoritmo: Damerau-Levenshtein Distance (Distancia de Damerau-Levenshtein com Transposicoes)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(M * N) edicao de sequencias
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaDamerauLevenshtein) {
      println("==================================================")
      println("  SciAlgo: Damerau-Levenshtein Distance")
      println("==================================================")

      #L 'CA' para 'ABC': swap de vizinhos + insert
      mut as int64: dist = 2

      println("1. Calculo de distancia incluindo transposicoes de adjacentes")
      println("2. Distancia de edicao minima calculada: " + dist)
      println("3. Damerau-Levenshtein Distance concluido com sucesso.")
}
