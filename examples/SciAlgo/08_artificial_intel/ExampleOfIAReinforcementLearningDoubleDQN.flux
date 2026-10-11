#L ============================================================================
#L Algoritmo: Double DQN (DDQN com Selecao Online e Avaliacao Alvo)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningDoubleDQN) {
      println("=== Algoritmo: Double DQN ===")
      mut as int64: onlineArgMaxAction = 1
      mut as int64: targetNetValueAtAction = 58
      mut as int64: reward = 10
      mut as int64: ddqnTarget = reward + (90 * targetNetValueAtAction) /i 100
      println("1. Acao escolhida pela rede online: " + onlineArgMaxAction)
      println("2. Target DDQN desacoplado: " + ddqnTarget)
      println("Teste concluido com sucesso.")
}
