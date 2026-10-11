#L ============================================================================
#L Algoritmo: CNN (Convolutional Neural Network com Convolucao 2D e Max Pooling)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisConvolutionalNeuralNetwork) {
      println("=== Algoritmo: CNN Convolution & Pooling ===")
      mut as int64: p11 = 2
      mut as int64: p12 = 4
      mut as int64: p21 = 8
      mut as int64: p22 = 6
      mut as int64: k11 = 1
      mut as int64: k12 = 0
      mut as int64: k21 = 0
      mut as int64: k22 = 1
      mut as int64: convVal = p11 * k11 + p12 * k12 + p21 * k21 + p22 * k22
      mut as int64: maxPoolVal = p11
      route {
            p12 > maxPoolVal ==> { maxPoolVal = p12 }
            _ ==> {}
      }
      route {
            p21 > maxPoolVal ==> { maxPoolVal = p21 }
            _ ==> {}
      }
      route {
            p22 > maxPoolVal ==> { maxPoolVal = p22 }
            _ ==> {}
      }
      println("1. Saida da convolucao 2D: " + convVal)
      println("2. Saida do Max Pooling 2x2: " + maxPoolVal)
      println("Teste concluido com sucesso.")
}
