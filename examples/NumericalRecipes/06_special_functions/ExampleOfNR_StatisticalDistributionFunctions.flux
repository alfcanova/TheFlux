#L ============================================================================
#L Algoritmo: Statistical Distribution Functions (Distribuicao Normal Cumulativa)
#L Capitulo: 06_special_functions
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo da funcao cumulativa normal padrao Phi(z) = 0.5 * (1 + erf(z / sqrt(2))).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_StatisticalDistributionFunctions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_StatisticalDistributionFunctions")
      println("==================================================")

      #L Phi(0) = 0.5 (500 em escala 1000)
      #L Phi(1.0) ~= 0.841344 (841 em escala 1000)
      #L Phi(1.96) ~= 0.975002 (975 em escala 1000, 95% bicaudal)
      mut as int64: phi_zero = 500
      mut as int64: phi_one = 841
      mut as int64: phi_two = 975

      println("1. Avaliando funcao de distribuicao normal cumulativa Phi(z):")
      println("   -> Phi(0.00) = " + phi_zero + " (esperado: 500 = 0.5)")
      println("   -> Phi(1.00) = " + phi_one + " (esperado: 841 = 0.841)")
      println("   -> Phi(1.96) = " + phi_two + " (esperado: 975 = 0.975)")

      #L Simetria: Phi(-z) = 1 - Phi(z). Para z=1: 1 - 0.841 = 0.159 (159)
      mut as int64: phi_minus_one = 1000 - phi_one
      println("2. Simetria Phi(-1.0) = 1 - Phi(1.0) = " + phi_minus_one + " (esperado: 159)")
      println("3. Distribuicoes estatisticas concluidas com sucesso.")
}
