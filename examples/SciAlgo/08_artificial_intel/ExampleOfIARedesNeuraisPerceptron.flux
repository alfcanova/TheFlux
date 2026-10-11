#L ============================================================================
#L Algoritmo: Perceptron (Neuronio Artificial com Funcao Degrau)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisPerceptron) {
      println("=== Algoritmo: Perceptron Artificial ===")
      mut as int64: x1 = 1
      mut as int64: x2 = 0
      mut as int64: w1 = 5
      mut as int64: w2 = 5
      mut as int64: thetaThreshold = 3
      mut as int64: netSum = x1 * w1 + x2 * w2
      mut as int64: outActivation = 0
      route {
            netSum >= thetaThreshold ==> { outActivation = 1 }
            _ ==> {}
      }
      println("1. Soma ponderada dos estimulos: " + netSum)
      println("2. Ativacao do neuronio: " + outActivation)
      println("Teste concluido com sucesso.")
}
