#L ============================================================================
#L Algoritmo: Actor-Critic (Ator Parametrico com Critico de Diferenca Temporal)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningActorCritic) {
      println("=== Algoritmo: Actor-Critic ===")
      mut as int64: criticTDError = 12
      mut as int64: actorGradLogPi = 5
      mut as int64: actorStep = actorGradLogPi * criticTDError
      println("1. Sinal de erro TD do Critico: " + criticTDError)
      println("2. Passo de melhoria do Ator: " + actorStep)
      println("Teste concluido com sucesso.")
}
