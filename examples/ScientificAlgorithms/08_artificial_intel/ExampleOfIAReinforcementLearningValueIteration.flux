#L ============================================================================
#L Algoritmo: Value Iteration (Iteracao de Valor para Politica Otima)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningValueIteration) {
      println("=== Algoritmo: Value Iteration ===")
      mut as int64: vOld = 40
      mut as int64: qAction1 = 48
      mut as int64: qAction2 = 55
      mut as int64: vNew = qAction1
      route {
            qAction2 > qAction1 ==> { vNew = qAction2 }
            _ ==> {}
      }
      mut as int64: delta = vNew - vOld
      println("1. Novo valor otimo V*(s): " + vNew)
      println("2. Variacao residual delta: " + delta)
      println("Teste concluido com sucesso.")
}
