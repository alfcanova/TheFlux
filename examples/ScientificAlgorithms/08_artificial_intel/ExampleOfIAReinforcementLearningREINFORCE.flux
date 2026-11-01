#L ============================================================================
#L Algoritmo: REINFORCE (Monte Carlo Policy Gradient de Williams com Linha de Base)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningREINFORCE) {
      println("=== Algoritmo: REINFORCE com Baseline ===")
      mut as int64: retG = 65
      mut as int64: baselineB = 50
      mut as int64: advantage = retG - baselineB
      mut as int64: scoreFunction = 3
      mut as int64: updateDelta = advantage * scoreFunction
      println("1. Vantagem centrada com baseline: " + advantage)
      println("2. Atualizacao dos parametros da politica: " + updateDelta)
      println("Teste concluido com sucesso.")
}
