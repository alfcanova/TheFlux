#L ============================================================================
#L Algoritmo: Secant Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosSecantMethod) {
      println("==================================================")
      println("  SciAlgo: Secant Method")
      println("==================================================")

      mut as int64: p0 = 5
      mut as int64: p1 = 15
      mut as int64: iter = 0
      infinite (iter < 10) {
            mut as int64: f0 = p0 * p0 - 81
            mut as int64: f1 = p1 * p1 - 81
            mut as int64: df = f1 - f0
            route {
                  df != 0 ==> {
                        mut as int64: p2 = p1 - (f1 * (p1 - p0)) /i df
                        p0 = p1
                        p1 = p2
                  }
                  _ ==> { iter = 20 }
            }
            iter = iter + 1
      }

      println("1. Raiz aproximada pelo metodo da Secante: " + p1)
      println("2. Secant Method concluido com sucesso.")
}
