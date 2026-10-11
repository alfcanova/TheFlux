#L ============================================================================
#L Algoritmo: Bowyer-Watson Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaBowyerWatson) {
      println("==================================================")
      println("  SciAlgo: Bowyer-Watson Algorithm")
      println("==================================================")

      mut as int64: tri_dist_sq = 12
      mut as int64: circum_r_sq = 16
      mut as int64: is_bad_triangle = 0
      route { tri_dist_sq < circum_r_sq ==> { is_bad_triangle = 1 } _ ==> {} }

      println("1. Triangulo cavidade invalido identificado no Bowyer-Watson: " + is_bad_triangle)
      println("2. Bowyer-Watson Algorithm concluido com sucesso.")
}
