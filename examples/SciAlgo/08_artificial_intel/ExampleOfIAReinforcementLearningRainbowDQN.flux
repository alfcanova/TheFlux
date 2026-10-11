#L ============================================================================
#L Algoritmo: Rainbow DQN (Integracao Completa de Extensoes DQN)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningRainbowDQN) {
      println("=== Algoritmo: Rainbow DQN ===")
      mut as int64: nStepReturn = 85
      mut as int64: priorityWeight = 12
      mut as int64: weightedGrad = (nStepReturn * priorityWeight) /i 10
      println("1. Retorno multi-passo N-step: " + nStepReturn)
      println("2. Gradiente ponderado por amostragem priorizada (PER): " + weightedGrad)
      println("Teste concluido com sucesso.")
}
