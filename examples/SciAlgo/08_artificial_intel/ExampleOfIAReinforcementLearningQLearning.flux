#L ============================================================================
#L Algoritmo: Q-Learning (Controle TD Off-Policy de Watkins)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningQLearning) {
      println("=== Algoritmo: Q-Learning Off-Policy ===")
      mut as int64: qSA = 30
      mut as int64: reward = 10
      mut as int64: gammaDiscount = 90
      mut as int64: maxQNext = 50
      mut as int64: alphaLr = 20
      mut as int64: qTarget = reward + (gammaDiscount * maxQNext) /i 100
      mut as int64: qNew = qSA + (alphaLr * (qTarget - qSA)) /i 100
      println("1. Q-Target off-policy: " + qTarget)
      println("2. Valor Q(s, a) atualizado: " + qNew)
      println("Teste concluido com sucesso.")
}
