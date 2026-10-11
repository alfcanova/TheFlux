#L ============================================================================
#L Algoritmo: Perceptron (Classificador Linear com Atualizacao de Rosenblatt)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoPerceptron) {
      println("=== Algoritmo: Perceptron de Rosenblatt ===")
      mut as int64: w1 = 0
      mut as int64: w2 = 0
      mut as int64: biasVal = 0
      mut as int64: x1 = 1
      mut as int64: x2 = 1
      mut as int64: target = 1
      mut as int64: activation = w1 * x1 + w2 * x2 + biasVal
      mut as int64: yHat = 0
      route {
            activation >= 0 ==> { yHat = 1 }
            _ ==> {}
      }
      route {
            yHat != target ==> {
                  w1 = w1 + target * x1
                  w2 = w2 + target * x2
                  biasVal = biasVal + target
            }
            _ ==> {}
      }
      println("1. Pesos aprendidos: w1=" + w1 + ", w2=" + w2)
      println("2. Bias: " + biasVal)
      println("Teste concluido com sucesso.")
}
