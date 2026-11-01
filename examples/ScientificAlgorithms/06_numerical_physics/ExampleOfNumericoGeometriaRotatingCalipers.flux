#L ============================================================================
#L Algoritmo: Rotating Calipers
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaRotatingCalipers) {
      println("==================================================")
      println("  SciAlgo: Rotating Calipers")
      println("==================================================")

      mut as int64: d1 = 100
      mut as int64: d2 = 150
      mut as int64: d3 = 120
      mut as int64: max_d = d1
      route { d2 > max_d ==> { max_d = d2 } _ ==> {} }
      route { d3 > max_d ==> { max_d = d3 } _ ==> {} }

      println("1. Diametro antipodal maximo medido por Rotating Calipers: " + max_d)
      println("2. Rotating Calipers concluido com sucesso.")
}
