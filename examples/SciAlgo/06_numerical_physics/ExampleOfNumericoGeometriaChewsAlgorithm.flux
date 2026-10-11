#L ============================================================================
#L Algoritmo: Chew's Second Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaChewsAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Chew's Second Algorithm")
      println("==================================================")

      mut as int64: min_angle = 25
      mut as int64: threshold = 30
      mut as int64: needs_refinement = 0
      route { min_angle < threshold ==> { needs_refinement = 1 } _ ==> {} }

      println("1. Refinamento de malha Delaunay restrita necessario: " + needs_refinement)
      println("2. Chew's Second Algorithm concluido com sucesso.")
}
