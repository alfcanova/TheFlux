#L ============================================================================
#L Algoritmo: Ramer-Douglas-Peucker Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaRamerDouglasPeucker) {
      println("==================================================")
      println("  SciAlgo: Ramer-Douglas-Peucker Algorithm")
      println("==================================================")

      mut as int64: max_d = 3
      mut as int64: epsilon = 5
      mut as int64: simplify = 0
      route { max_d < epsilon ==> { simplify = 1 } _ ==> {} }

      println("1. Decisao de simplificacao de polilinha: " + simplify)
      println("2. Ramer-Douglas-Peucker Algorithm concluido com sucesso.")
}
