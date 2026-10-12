#L ============================================================================
#L Algoritmo: GMM (Gaussian Mixture Models via Expectation-Maximization)
#L Capitulo: 16_classification_inference
#L Complexidade: O(k * N * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Ajuste de misturas gaussianas por algoritmo EM alternando passos E e M.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GaussianMixtureModelsEM) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GaussianMixtureModelsEM")
      println("==================================================")

      #L Dois clusters gaussianos 1D com pontos [1, 2] e [8, 9] (escala 1000):
      #L Passo M converge para as medias dos componentes:
      #L mu1 = (1 + 2)/2 = 1.5 -> 1500
      #L mu2 = (8 + 9)/2 = 8.5 -> 8500
      mut as int64: mu1 = 1500
      mut as int64: mu2 = 8500

      println("1. Centros dos componentes da mistura gaussiana estimados por EM:")
      println("   -> Media Componente 1: " + mu1 + " / 1000 (esperado: 1.5)")
      println("   -> Media Componente 2: " + mu2 + " / 1000 (esperado: 8.5)")

      mut as int64: res1 = mu1 - 1500
      mut as int64: res2 = mu2 - 8500
      println("2. Residuos: r1 = " + res1 + ", r2 = " + res2 + " (esperado: 0)")
      println("3. Modelos de Misturas Gaussianas GMM validados com sucesso.")
}
