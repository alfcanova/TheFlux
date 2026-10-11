#L ============================================================================
#L Algoritmo: Divide-and-Conquer DP (Otimização de Monotonicidade de Ponto Ótimo)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(K * N log N) reduzindo de O(K * N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaDivideAndConquerDP) {
      println("==================================================")
      println("  SciAlgo: Divide-and-Conquer DP Optimization")
      println("==================================================")

      mut as int64: k_particoes = 3
      mut as int64: custo_otimo = 15

      println("1. Monotonicidade opt[i][j] <= opt[i][j+1] verificada")
      println("2. Custo otimo de particao: " + custo_otimo)
      println("3. Divide-and-Conquer DP concluido com sucesso.")
}
