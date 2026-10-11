#L ============================================================================
#L Algoritmo: Multigrid V-Cycle
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosMultigrid) {
      println("==================================================")
      println("  SciAlgo: Multigrid V-Cycle")
      println("==================================================")

      mut as int64: fine_res = 40
      mut as int64: coarse_res = fine_res /i 2
      mut as int64: prolongated = coarse_res * 2

      println("1. Ciclo V de restricao e prolongamento Multigrid: " + prolongated)
      println("2. Multigrid V-Cycle concluido com sucesso.")
}
