#L ============================================================================
#L Algoritmo: Dueling DQN (Decomposicao de Estado V(s) e Vantagem A(s, a))
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningDuelingDQN) {
      println("=== Algoritmo: Dueling DQN ===")
      mut as int64: stateValueV = 70
      mut as int64: advantageA = 15
      mut as int64: meanAdvantage = 5
      mut as int64: duelingQ = stateValueV + (advantageA - meanAdvantage)
      println("1. Stream de Valor V(s): " + stateValueV)
      println("2. Stream de Vantagem A(s, a): " + advantageA)
      println("3. Q(s, a) Dueling sintetizado: " + duelingQ)
      println("Teste concluido com sucesso.")
}
