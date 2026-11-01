#L ============================================================================
#L Algoritmo: Monte Carlo Tree Search (MCTS com Formula UCT)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningMonteCarloTreeSearch) {
      println("=== Algoritmo: Monte Carlo Tree Search UCT ===")
      mut as int64: winRateQ = 60
      mut as int64: parentVisitsN = 100
      mut as int64: childVisitsNi = 20
      mut as int64: cExploration = 14
      mut as int64: uctScore = winRateQ + (cExploration * parentVisitsN) /i (childVisitsNi * 10)
      println("1. Taxa de vitoria Q/N: " + winRateQ)
      println("2. Pontuacao UCT para selecao de no: " + uctScore)
      println("Teste concluido com sucesso.")
}
