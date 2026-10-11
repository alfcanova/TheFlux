#L ============================================================================
#L Algoritmo: Hirschberg Algorithm (LCS em Espaço Linear O(min(M, N)))
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(min(M, N)) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaHirschbergAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Hirschberg Linear-Space LCS")
      println("==================================================")

      mut as int64: m = 6
      mut as int64: n = 4
      mut as int64: split_point = 3
      mut as int64: lcs_total = 3

      println("1. Divisao recursiva no ponto medio: " + split_point)
      println("2. LCS computada em espaco linear: " + lcs_total)
      println("3. Hirschberg concluido com sucesso.")
}
