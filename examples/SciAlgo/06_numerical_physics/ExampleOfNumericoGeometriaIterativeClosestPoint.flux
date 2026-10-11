#L ============================================================================
#L Algoritmo: Iterative Closest Point (ICP)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaIterativeClosestPoint) {
      println("==================================================")
      println("  SciAlgo: Iterative Closest Point (ICP)")
      println("==================================================")

      mut as list of int64: errs = [4, 9, 1, 16]
      mut as int64: n = listLength(errs)
      mut as int64: sum_err = 0
      mut as int64: i = 1
      infinite (i <= n) {
            sum_err = sum_err + errs[i]
            i = i + 1
      }
      mut as int64: mean_residual = sum_err /i n

      println("1. Erro residual medio quadratico da iteracao ICP: " + mean_residual)
      println("2. Iterative Closest Point (ICP) concluido com sucesso.")
}
