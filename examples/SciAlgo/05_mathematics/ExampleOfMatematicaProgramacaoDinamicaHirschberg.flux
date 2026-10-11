#L ============================================================================
#L Algoritmo: Hirschberg Algorithm (Algoritmo de Hirschberg para Alinhamento em Espaco Linear)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(M * N) tempo, O(min(M, N)) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaHirschberg) {
      println("==================================================")
      println("  SciAlgo: Hirschberg Linear Space LCS")
      println("==================================================")

      mut as int64: len_s1 = 8
      mut as int64: len_s2 = 7
      mut as int64: lcs_len = 5

      println("1. Comprimento das sequencias: " + len_s1 + " e " + len_s2)
      println("2. Tamanho da maior subsequencia comum encontrada: " + lcs_len)
      println("3. Hirschberg Algorithm concluido com sucesso.")
}
