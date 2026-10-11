#L ============================================================================
#L Algoritmo: Backward Euler Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosBackwardEuler) {
      println("==================================================")
      println("  SciAlgo: Backward Euler Method")
      println("==================================================")

      mut as int64: y = 1000
      mut as int64: rate_pct = 10
      mut as int64: i = 1
      infinite (i <= 3) {
            y = (y * 100) /i (100 + rate_pct)
            i = i + 1
      }

      println("1. Solucao estavel pelo metodo Backward Euler: " + y)
      println("2. Backward Euler Method concluido com sucesso.")
}
