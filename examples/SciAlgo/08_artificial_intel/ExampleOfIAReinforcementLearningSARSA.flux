#L ============================================================================
#L Algoritmo: SARSA (State-Action-Reward-State-Action On-Policy TD Control)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningSARSA) {
      println("=== Algoritmo: SARSA On-Policy ===")
      mut as int64: qSA = 25
      mut as int64: reward = 8
      mut as int64: gammaDiscount = 90
      mut as int64: qNextActualAction = 40
      mut as int64: alphaLr = 20
      mut as int64: sarsaTarget = reward + (gammaDiscount * qNextActualAction) /i 100
      mut as int64: qNew = qSA + (alphaLr * (sarsaTarget - qSA)) /i 100
      println("1. SARSA Target on-policy: " + sarsaTarget)
      println("2. Novo Q(s, a): " + qNew)
      println("Teste concluido com sucesso.")
}
