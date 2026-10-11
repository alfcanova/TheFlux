#L ============================================================================
#L Algoritmo: Kahan Summation Algorithm
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosKahanSummation) {
      println("==================================================")
      println("  SciAlgo: Kahan Summation Algorithm")
      println("==================================================")

      mut as list of int64: vals = [10000, 1, 2, 3, 4]
      mut as int64: n = listLength(vals)
      mut as int64: sum_k = 0
      mut as int64: c = 0
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: y = vals[i] - c
            mut as int64: t = sum_k + y
            c = (t - sum_k) - y
            sum_k = t
            i = i + 1
      }

      println("1. Soma compensada de alta precisao Kahan: " + sum_k)
      println("2. Kahan Summation Algorithm concluido com sucesso.")
}
