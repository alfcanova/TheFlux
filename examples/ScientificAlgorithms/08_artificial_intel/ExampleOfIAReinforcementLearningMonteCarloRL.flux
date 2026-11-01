#L ============================================================================
#L Algoritmo: Monte Carlo RL (Every-Visit / First-Visit MC Retornos)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningMonteCarloRL) {
      println("=== Algoritmo: Monte Carlo RL ===")
      mut as list of int64: returns = [10, 20, 15, 25]
      mut as int64: sumRet = returns[1] + returns[2] + returns[3] + returns[4]
      mut as int64: vEstimate = sumRet /i 4
      println("1. Retorno medio acumulado da trajetoria: " + vEstimate)
      println("Teste concluido com sucesso.")
}
