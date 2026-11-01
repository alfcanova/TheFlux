#L ============================================================================
#L Algoritmo: Double Q-Learning (Desacoplamento de Maximizacao contra Superestimacao)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningDoubleQLearning) {
      println("=== Algoritmo: Double Q-Learning ===")
      mut as int64: bestActionQA = 2
      mut as int64: valQBAtBestAction = 42
      mut as int64: reward = 5
      mut as int64: gammaVal = 90
      mut as int64: doubleTarget = reward + (gammaVal * valQBAtBestAction) /i 100
      println("1. Acao selecionada por Q_A: " + bestActionQA)
      println("2. Valor avaliado por Q_B: " + valQBAtBestAction)
      println("3. Target Double Q-Learning: " + doubleTarget)
      println("Teste concluido com sucesso.")
}
