#L ============================================================================
#L Algoritmo: Decision Tree (Arvore de Decisao com Divisao Binaria)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoDecisionTree) {
      println("=== Algoritmo: Decision Tree ===")
      mut as int64: featureVal = 42
      mut as int64: splitThreshold = 30
      mut as int64: predictedClass = 0
      route {
            featureVal > splitThreshold ==> { predictedClass = 1 }
            _ ==> { predictedClass = 0 }
      }
      println("1. Divisao no no raiz: x > " + splitThreshold)
      println("2. Predicao da folha: " + predictedClass)
      println("Teste concluido com sucesso.")
}
