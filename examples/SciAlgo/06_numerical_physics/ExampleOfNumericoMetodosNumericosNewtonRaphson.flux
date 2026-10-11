#L ============================================================================
#L Algoritmo: Newton-Raphson Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosNewtonRaphson) {
      println("==================================================")
      println("  SciAlgo: Newton-Raphson Method")
      println("==================================================")

      mut as int64: n = 144
      mut as int64: x = n /i 2 + 1
      mut as int64: iter = 0
      infinite (iter < 20) {
            mut as int64: next_x = (x + n /i x) /i 2
            route {
                  next_x >= x ==> { iter = 30 }
                  _ ==> { x = next_x }
            }
            iter = iter + 1
      }

      println("1. Raiz quadrada calculada por Newton-Raphson: " + x)
      println("2. Newton-Raphson Method concluido com sucesso.")
}
