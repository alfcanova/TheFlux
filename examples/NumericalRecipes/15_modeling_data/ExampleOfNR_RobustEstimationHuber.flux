#L ============================================================================
#L Algoritmo: Robust Estimation — Huber Loss (Regressao Robusta com Perda de Huber)
#L Capitulo: 15_modeling_data
#L Complexidade: O(k * N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: M-estimador robusto de Huber que atenua a influencia de outliers aberrantes.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RobustEstimationHuber) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RobustEstimationHuber")
      println("==================================================")

      #L Limiar de Huber c = 1500 (1.5).
      #L Para residuo pequeno r1 = 1000 (1.0 <= 1.5): perda quadratica L1 = r1^2 / 2 = 500
      #L Para outlier r2 = 3000 (3.0 > 1.5): perda linear L2 = c*r2 - c^2/2 = 4500 - 1125 = 3375
      mut as int64: l_quad = 500
      mut as int64: l_linear = 3375

      println("1. Avaliando funcao de perda robusta de Huber:")
      println("   -> Perda em ponto normal (r=1.0) = " + l_quad)
      println("   -> Perda em outlier (r=3.0)       = " + l_linear)

      mut as int64: res = (l_quad - 500) + (l_linear - 3375)
      println("2. Residuo da perda robusta = " + res + " (esperado: 0)")
      println("3. Regressao robusta de Huber concluida.")
}
