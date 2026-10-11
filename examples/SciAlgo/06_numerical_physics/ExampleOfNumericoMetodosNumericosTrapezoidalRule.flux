#L ============================================================================
#L Algoritmo: Trapezoidal Rule
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosTrapezoidalRule) {
      println("==================================================")
      println("  SciAlgo: Trapezoidal Rule")
      println("==================================================")

      mut as list of int64: y_vals = [0, 10, 20, 30, 40]
      mut as int64: n = listLength(y_vals)
      mut as int64: sum_trap = y_vals[1] + y_vals[n]
      mut as int64: i = 2
      infinite (i < n) {
            sum_trap = sum_trap + 2 * y_vals[i]
            i = i + 1
      }
      mut as int64: integral_trap = sum_trap /i 2

      println("1. Integral aproximada pela regra dos Trapezios: " + integral_trap)
      println("2. Trapezoidal Rule concluido com sucesso.")
}
