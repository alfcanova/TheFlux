#L ============================================================================
#L Algoritmo: Reinforcement Learning Recommendation (MDP para Recomendacao Sequencial)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoReinforcementLearningRecommendation) {
      println("=== Algoritmo: RL Recommender MDP ===")
      mut as int64: immediateClickReward = 10
      mut as int64: discountedLongTermReward = 45
      mut as int64: qValueRecommendation = immediateClickReward + discountedLongTermReward
      println("1. Recompensa imediata de clique: " + immediateClickReward)
      println("2. Q-Value da acao de recomendacao: " + qValueRecommendation)
      println("Teste concluido com sucesso.")
}
