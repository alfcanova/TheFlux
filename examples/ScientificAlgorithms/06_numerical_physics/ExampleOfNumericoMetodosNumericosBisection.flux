#L ============================================================================
#L Algoritmo: Bisection Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosBisection) {
      println("==================================================")
      println("  SciAlgo: Bisection Method")
      println("==================================================")

      mut as int64: low = 0
      mut as int64: high = 10
      mut as int64: root = 0
      mut as int64: iter = 0
      infinite (iter < 20 and low <= high) {
            mut as int64: mid = (low + high) /i 2
            mut as int64: fm = mid * mid - 25
            route {
                  fm == 0 ==> {
                        root = mid
                        low = high + 1
                  }
                  fm < 0 ==> {
                        low = mid + 1
                        root = mid
                  }
                  _ ==> {
                        high = mid - 1
                        root = mid
                  }
            }
            iter = iter + 1
      }

      println("1. Raiz encontrada por Bisseccao: " + root)
      println("2. Bisection Method concluido com sucesso.")
}
