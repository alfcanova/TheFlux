#L ============================================================================
#L Algoritmo: DQN (Deep Q-Network com Replay Buffer e Rede Alvo)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningDQN) {
      println("=== Algoritmo: Deep Q-Network ===")
      mut as int64: reward = 15
      mut as int64: targetNetMaxQ = 65
      mut as int64: gammaDiscount = 95
      mut as int64: dqnTarget = reward + (gammaDiscount * targetNetMaxQ) /i 100
      mut as int64: onlineNetQ = 60
      mut as int64: bellmanLoss = (dqnTarget - onlineNetQ) * (dqnTarget - onlineNetQ)
      println("1. DQN Target via Target Network: " + dqnTarget)
      println("2. Perda de Bellman (Loss MSE): " + bellmanLoss)
      println("Teste concluido com sucesso.")
}
