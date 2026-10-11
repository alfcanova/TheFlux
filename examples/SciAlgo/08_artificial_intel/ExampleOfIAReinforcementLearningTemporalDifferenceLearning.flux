#L ============================================================================
#L Algoritmo: Temporal Difference Learning (TD(0) Bootstrapping)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningTemporalDifferenceLearning) {
      println("=== Algoritmo: Temporal Difference TD(0) ===")
      mut as int64: vS = 50
      mut as int64: reward = 5
      mut as int64: gammaDisc = 90
      mut as int64: vNext = 60
      mut as int64: tdTarget = reward + (gammaDisc * vNext) /i 100
      mut as int64: tdError = tdTarget - vS
      mut as int64: alphaLr = 10
      mut as int64: vUpdated = vS + (alphaLr * tdError) /i 100
      println("1. TD Target: " + tdTarget)
      println("2. TD Error (delta): " + tdError)
      println("3. V(s) atualizado: " + vUpdated)
      println("Teste concluido com sucesso.")
}
