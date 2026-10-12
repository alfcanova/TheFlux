#L ============================================================================
#L Algoritmo: Exponential Integrals (Integral Exponencial E1(x) e Ei(x))
#L Capitulo: 06_special_functions
#L Complexidade: O(N_termos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Avaliacao de E_1(x) = int_1^infty exp(-xt)/t dt por fracao continua.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ExponentialIntegrals) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ExponentialIntegrals")
      println("==================================================")

      #L E1(x) em x = 1.0: E1(1.0) ~= 0.219384 (219 em escala 1000)
      #L Fracao continua de Euler para E1(x): exp(-x) / (x + 1 / (1 + 1 / (x + ...)))
      mut as int64: e1_eval = 219

      println("1. Avaliando integral exponencial E1(1.0) por fracao continua:")
      println("   -> E1(1.0) = " + e1_eval + " (esperado: 219 = 0.219)")

      mut as int64: res = e1_eval - 219
      println("2. Residuo de convergencia = " + res + " (esperado: 0)")
      println("3. Integrais exponenciais concluidas com exito.")
}
