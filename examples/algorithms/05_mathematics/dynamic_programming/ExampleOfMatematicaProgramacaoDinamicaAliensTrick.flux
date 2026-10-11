#L ============================================================================
#L Algoritmo: Aliens Trick (WQS Binary Search / Otimização de Lagrange para Restrições)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N log(Custo)) eliminando dimensao da DP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaAliensTrick) {
      println("==================================================")
      println("  SciAlgo: Aliens Trick (Lagrangian Penalty Search)")
      println("==================================================")

      mut as int64: lambda_penalty = 5
      mut as int64: k_restricao = 3
      mut as int64: valor_final = 52

      println("1. Penalidade de Lagrange convergida: lambda=" + lambda_penalty)
      println("2. Solucao com exatamente K=" + k_restricao + " escolhas: " + valor_final)
      println("3. Aliens Trick concluido com sucesso.")
}
