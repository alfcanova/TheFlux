#L ============================================================================
#L Algoritmo: Gaussian Mixture Model (GMM via Algoritmo Expectation-Maximization)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoGaussianMixtureModel) {
      println("=== Algoritmo: GMM Expectation-Maximization ===")
      mut as int64: prior1 = 50
      mut as int64: pXGiven1 = 70
      mut as int64: prior2 = 50
      mut as int64: pXGiven2 = 30
      mut as int64: totalLikelihood = (prior1 * pXGiven1 + prior2 * pXGiven2) /i 100
      mut as int64: responsibility1 = (prior1 * pXGiven1) /i totalLikelihood
      println("1. Responsabilidade do componente 1 (E-step): " + responsibility1)
      println("Teste concluido com sucesso.")
}
