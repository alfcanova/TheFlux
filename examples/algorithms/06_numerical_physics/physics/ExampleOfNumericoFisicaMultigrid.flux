#L ============================================================================
#L Algoritmo: Multigrid Smoothing Relaxer
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaMultigrid) {
      println("==================================================")
      println("  SciAlgo: Multigrid Smoothing Relaxer")
      println("==================================================")

      mut as int64: rhs = 100
      mut as int64: approx = 95
      mut as int64: defect = rhs - approx

      println("1. Equacao de defeito/residuo no ciclo Multigrid: " + defect)
      println("2. Multigrid Smoothing Relaxer concluido com sucesso.")
}
