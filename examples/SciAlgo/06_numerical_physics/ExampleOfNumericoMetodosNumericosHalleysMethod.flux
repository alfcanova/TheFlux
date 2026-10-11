#L ============================================================================
#L Algoritmo: Halley's Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosHalleysMethod) {
      println("==================================================")
      println("  SciAlgo: Halley's Method")
      println("==================================================")

      mut as int64: a = 27
      mut as int64: x = a /i 3 + 1
      mut as int64: iter = 0
      infinite (iter < 10) {
            mut as int64: x3 = x * x * x
            mut as int64: denom = 2 * x3 + a
            route {
                  denom != 0 ==> {
                        mut as int64: next_x = (x * (x3 + 2 * a)) /i denom
                        route { next_x == x ==> { iter = 20 } _ ==> { x = next_x } }
                  }
                  _ ==> { iter = 20 }
            }
            iter = iter + 1
      }

      println("1. Raiz cubica com convergencia cubica de Halley: " + x)
      println("2. Halley's Method concluido com sucesso.")
}
