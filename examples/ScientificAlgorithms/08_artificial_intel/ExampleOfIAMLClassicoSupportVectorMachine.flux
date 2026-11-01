#L ============================================================================
#L Algoritmo: Support Vector Machine (SVM com Hiperplano de Margem Maxima)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoSupportVectorMachine) {
      println("=== Algoritmo: Support Vector Machine ===")
      mut as int64: w1 = 3
      mut as int64: w2 = 4
      mut as int64: b = 0 - 5
      mut as int64: x1 = 2
      mut as int64: x2 = 1
      mut as int64: fX = w1 * x1 + w2 * x2 + b
      mut as int64: predictedLabel = 0 - 1
      route {
            fX >= 0 ==> { predictedLabel = 1 }
            _ ==> {}
      }
      println("1. Distancia funcional da margem: " + fX)
      println("2. Classificacao SVM (+1 / -1): " + predictedLabel)
      println("Teste concluido com sucesso.")
}
