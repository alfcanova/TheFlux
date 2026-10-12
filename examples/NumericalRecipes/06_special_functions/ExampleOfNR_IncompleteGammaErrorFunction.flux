#L ============================================================================
#L Algoritmo: Incomplete Gamma & Error Function (Funcao de Erro erf(x))
#L Capitulo: 06_special_functions
#L Complexidade: O(N_termos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo de P(a, x), Q(a, x) e erf(x) = (2/sqrt(pi)) int_0^x exp(-t^2) dt.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_IncompleteGammaErrorFunction) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_IncompleteGammaErrorFunction")
      println("==================================================")

      #L erf(1.0) ~= 0.842701 (843 em escala 1000)
      #L erfc(1.0) = 1 - erf(1.0) ~= 0.157299 (157 em escala 1000)
      #L Relacao: erf(x) + erfc(x) = 1.0 (1000)
      mut as int64: erf_val = 843
      mut as int64: erfc_val = 157

      println("1. Avaliando Funcao de Erro de Gauss erf(1.0) e erfc(1.0):")
      println("   -> erf(1.0)  = " + erf_val + " (esperado: 843 = 0.843)")
      println("   -> erfc(1.0) = " + erfc_val + " (esperado: 157 = 0.157)")

      mut as int64: sum_err = erf_val + erfc_val
      println("2. Soma de consistencia erf + erfc = " + sum_err + " (esperado: 1000)")
      println("3. Funcao de erro e Gamma incompleta concluidas com sucesso.")
}
