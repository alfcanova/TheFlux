#L ============================================================================
#L Algoritmo: TD3 (Twin Delayed DDPG com Minimo entre Criticos Gemeos)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningTD3) {
      println("=== Algoritmo: Twin Delayed DDPG ===")
      mut as int64: q1Target = 82
      mut as int64: q2Target = 74
      mut as int64: minQ = q1Target
      route {
            q2Target < q1Target ==> { minQ = q2Target }
            _ ==> {}
      }
      mut as int64: reward = 10
      mut as int64: td3Target = reward + (90 * minQ) /i 100
      println("1. Minimo dos criticos gemeos: " + minQ)
      println("2. Target conservador TD3: " + td3Target)
      println("Teste concluido com sucesso.")
}
