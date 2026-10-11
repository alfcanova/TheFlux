#L ============================================================================
#L Algoritmo: Policy Iteration (Avaliacao e Melhoria de Politica)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningPolicyIteration) {
      println("=== Algoritmo: Policy Iteration ===")
      mut as int64: currentAction = 1
      mut as int64: qA1 = 60
      mut as int64: qA2 = 75
      mut as int64: greedyAction = 1
      route {
            qA2 > qA1 ==> { greedyAction = 2 }
            _ ==> {}
      }
      mut as int64: policyStable = 0
      route {
            greedyAction == currentAction ==> { policyStable = 1 }
            _ ==> {}
      }
      println("1. Acao gulosa selecionada: " + greedyAction)
      println("2. Estabilidade da politica: " + policyStable)
      println("Teste concluido com sucesso.")
}
