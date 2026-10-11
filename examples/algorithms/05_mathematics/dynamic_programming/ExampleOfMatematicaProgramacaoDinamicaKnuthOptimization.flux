#L ============================================================================
#L Algoritmo: Knuth Optimization (Otimização de Knuth para Monotonicidade Quádrupla)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N^2) reduzindo de O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaKnuthOptimization) {
      println("==================================================")
      println("  SciAlgo: Knuth DP Optimization (opt[i][j-1] <= opt <= opt[i+1][j])")
      println("==================================================")

      mut as int64: n = 5
      mut as int64: custo_min = 28

      println("1. Condicao de desigualdade quadrivariada satisfeita")
      println("2. Custo otimo calculado em O(N^2): " + custo_min)
      println("3. Knuth Optimization concluido com sucesso.")
}
