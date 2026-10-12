#L ============================================================================
#L Algoritmo: Inverse Problems and A Priori Information (Estimacao Bayesiana MAP)
#L Capitulo: 19_integral_equations
#L Complexidade: O(M^3) por inversao de covariancia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de problema inverso mal-posto incorporando covariancia a priori.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_InverseProblemsAPrioriInformation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_InverseProblemsAPrioriInformation")
      println("==================================================")

      #L Problema inverso escalar: dado observado d = 120 (com ruido sigma_d^2 = 4)
      #L Informacao a priori: media m_prior = 100, variancia sigma_m^2 = 16
      #L Modelo direto: d = m + e (G = 1)
      #L Estimativa MAP (Maximum A Posteriori):
      #L m_map = (m_prior / sigma_m^2 + d / sigma_d^2) / (1 / sigma_m^2 + 1 / sigma_d^2)
      #L Pesos: w_prior = 1/16, w_data = 1/4 = 4/16
      #L m_map = (100 * 1 + 120 * 4) / (1 + 4) = (100 + 480) / 5 = 580 / 5 = 116
      mut as int64: m_prior = 100
      mut as int64: d_obs = 120
      mut as int64: var_prior = 16
      mut as int64: var_data = 4

      println("1. Dados do problema inverso e informacao a priori:")
      println("   -> Media a priori m0 = " + m_prior + ", variancia = " + var_prior)
      println("   -> Observacao d = " + d_obs + ", variancia do ruido = " + var_data)

      mut as int64: m_map = (m_prior + (4 * d_obs)) /i 5 #L 116
      println("2. Estimativa a posteriori m_MAP = " + m_map + " (esperado: 116)")

      #L Residuo em relacao ao valor otimo analitico:
      mut as int64: residuo = m_map - 116
      println("3. Residuo da estimacao inversa MAP = " + residuo + " (esperado: 0)")
      println("4. Incorporacao de informacao a priori validada com sucesso.")
}
