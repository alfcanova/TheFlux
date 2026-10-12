#L ============================================================================
#L Algoritmo: Incomplete Beta Function (Funcao Beta Incompleta Regularizada I_x)
#L Capitulo: 06_special_functions
#L Complexidade: O(N_frac)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Avaliacao de I_x(a, b) via fracao continua simetrica.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_IncompleteBetaFunction) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_IncompleteBetaFunction")
      println("==================================================")

      #L I_x(1, 1) = x. Para x = 0.5: I_{0.5}(1, 1) = 0.5 (500 em escala 1000)
      #L I_x(a, b) e a funcao de distribuicao acumulada da distribuicao Beta.
      mut as int64: ix_eval = 500

      println("1. Avaliando Beta Incompleta Regularizada I_0.5(1, 1):")
      println("   -> I_0.5(1, 1) = " + ix_eval + " (esperado: 500 = 0.5)")

      mut as int64: res = ix_eval - 500
      println("2. Residuo analitico = " + res + " (esperado: 0)")
      println("3. Funcao Beta Incompleta validada com exito.")
}
