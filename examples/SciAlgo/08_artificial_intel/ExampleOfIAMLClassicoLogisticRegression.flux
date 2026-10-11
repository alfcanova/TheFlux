#L ============================================================================
#L Algoritmo: Logistic Regression (Classificacao Binaria com Sigmoide)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoLogisticRegression) {
      println("=== Algoritmo: Regressao Logistica ===")
      mut as int64: z = 15
      mut as int64: approxSigmoid = 50 + (z * 10) /i 4
      route {
            approxSigmoid > 100 ==> { approxSigmoid = 100 }
            approxSigmoid < 0 ==> { approxSigmoid = 0 }
            _ ==> {}
      }
      mut as int64: predClass = 0
      route {
            approxSigmoid >= 50 ==> { predClass = 1 }
            _ ==> {}
      }
      println("1. Probabilidade sigmoide aproximada: " + approxSigmoid)
      println("2. Classe binaria predita: " + predClass)
      println("Teste concluido com sucesso.")
}
