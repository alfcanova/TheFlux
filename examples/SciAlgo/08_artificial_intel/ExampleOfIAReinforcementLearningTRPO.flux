#L ============================================================================
#L Algoritmo: TRPO (Trust Region Policy Optimization com Restricao KL)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningTRPO) {
      println("=== Algoritmo: Trust Region Policy Optimization ===")
      mut as int64: klDivergence = 8
      mut as int64: deltaLimit = 10
      mut as int64: stepValid = 0
      route {
            klDivergence <= deltaLimit ==> { stepValid = 1 }
            _ ==> {}
      }
      println("1. Divergencia KL na regiao de confianca: " + klDivergence)
      println("2. Passo valido na regiao de confianca: " + stepValid)
      println("Teste concluido com sucesso.")
}
