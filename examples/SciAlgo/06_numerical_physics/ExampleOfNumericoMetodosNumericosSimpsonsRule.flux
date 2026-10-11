#L ============================================================================
#L Algoritmo: Simpson's Rule
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosSimpsonsRule) {
      println("==================================================")
      println("  SciAlgo: Simpson's Rule")
      println("==================================================")

      mut as list of int64: y_simp = [0, 4, 16, 36, 64]
      mut as int64: n = listLength(y_simp)
      mut as int64: sum_s = y_simp[1] + y_simp[n]
      mut as int64: i = 2
      infinite (i < n) {
            route {
                  i /r 2 == 0 ==> { sum_s = sum_s + 4 * y_simp[i] }
                  _ ==> { sum_s = sum_s + 2 * y_simp[i] }
            }
            i = i + 1
      }
      mut as int64: integral_simp = sum_s /i 3

      println("1. Integral aproximada pela regra de Simpson 1/3: " + integral_simp)
      println("2. Simpson's Rule concluido com sucesso.")
}
