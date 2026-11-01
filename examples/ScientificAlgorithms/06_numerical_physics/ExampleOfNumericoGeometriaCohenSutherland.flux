#L ============================================================================
#L Algoritmo: Cohen-Sutherland Line Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaCohenSutherland) {
      println("==================================================")
      println("  SciAlgo: Cohen-Sutherland Line Clipping")
      println("==================================================")

      mut as int64: x = 15
      mut as int64: y = -2
      mut as int64: x_min = 0
      mut as int64: x_max = 10
      mut as int64: y_min = 0
      mut as int64: y_max = 10
      mut as int64: outcode = 0
      route { x < x_min ==> { outcode = outcode + 1 } _ ==> {} }
      route { x > x_max ==> { outcode = outcode + 2 } _ ==> {} }
      route { y < y_min ==> { outcode = outcode + 4 } _ ==> {} }
      route { y > y_max ==> { outcode = outcode + 8 } _ ==> {} }

      println("1. Outcode de 4 bits calculado no Cohen-Sutherland: " + outcode)
      println("2. Cohen-Sutherland Line Clipping concluido com sucesso.")
}
