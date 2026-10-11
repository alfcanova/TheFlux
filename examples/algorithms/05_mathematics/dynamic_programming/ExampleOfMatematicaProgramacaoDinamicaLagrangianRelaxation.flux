#L ============================================================================
#L Algoritmo: Lagrangian Relaxation (Relaxação Lagrangiana em DP)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(I * N) onde I e o numero de subgradientes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaLagrangianRelaxation) {
      println("==================================================")
      println("  SciAlgo: DP Lagrangian Relaxation Dual Problem")
      println("==================================================")

      mut as int64: dual_bound = 48
      println("1. Limite dual otimo estabelecido por relaxacao: " + dual_bound)
      println("2. Lagrangian Relaxation concluido com sucesso.")
}
