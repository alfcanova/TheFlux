#L ============================================================================
#L Algoritmo: PPO (Proximal Policy Optimization com Funcao Objetivo Clipped)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningPPO) {
      println("=== Algoritmo: PPO Clipped Objective ===")
      mut as int64: probRatio = 125
      mut as int64: clipMin = 80
      mut as int64: clipMax = 120
      mut as int64: advantage = 40
      mut as int64: clippedRatio = probRatio
      route {
            probRatio > clipMax ==> { clippedRatio = clipMax }
            probRatio < clipMin ==> { clippedRatio = clipMin }
            _ ==> {}
      }
      mut as int64: ppoLoss = (clippedRatio * advantage) /i 100
      println("1. Razao de probabilidades original: " + probRatio)
      println("2. Razao truncada (Clipped): " + clippedRatio)
      println("3. Objetivo PPO substituto: " + ppoLoss)
      println("Teste concluido com sucesso.")
}
