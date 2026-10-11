#L ============================================================================
#L Algoritmo: Dynamic Programming for MDP (Equacoes de Bellman Exatas)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningDynamicProgrammingMDP) {
      println("=== Algoritmo: DP for MDP Bellman ===")
      mut as int64: reward = 10
      mut as int64: gammaDiscount = 90
      mut as int64: nextStateValue = 50
      mut as int64: bellmanValue = reward + (gammaDiscount * nextStateValue) /i 100
      println("1. Recompensa imediata R: " + reward)
      println("2. Valor de Bellman calculado: " + bellmanValue)
      println("Teste concluido com sucesso.")
}
