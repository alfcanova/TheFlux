#L ============================================================================
#L Algoritmo: Boosting Geral (Ensemble Sequencial Ponderado)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleBoosting) {
      println("=== Algoritmo: Boosting Geral ===")
      mut as int64: weight1 = 20
      mut as int64: isErr = 1
      mut as int64: factor = 2
      route {
            isErr == 1 ==> { weight1 = weight1 * factor }
            _ ==> {}
      }
      println("1. Peso da amostra mal-classificada atualizado: " + weight1)
      println("Teste concluido com sucesso.")
}
