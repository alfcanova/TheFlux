#L ============================================================================
#L Algoritmo: Firefly Algorithm (Atracao e Brilho entre Vaga-lumes)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N^2 * D) | Espaco O(N * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoFireflyAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Firefly Algorithm (Luminescence)")
      println("==================================================")

      #L Vaga-lume 1 na posicao x1 = 40 (brilho I1 = 60)
      #L Vaga-lume 2 na posicao x2 = 10 (brilho I2 = 90)
      #L Vaga-lume menos brilhante (1) eh atraido em direcao ao mais brilhante (2)
      mut as int64: x1 = 40
      mut as int64: x2 = 10

      #L Deslocamento: x1 = x1 + beta * (x2 - x1) com beta = 0.5
      x1 = x1 + ((x2 - x1) /i 2) #L 40 - 15 = 25

      println("1. Nova posicao do vaga-lume atraido: x1 = " + x1)
      route {
            x1 == 25 ==> {
                  println("   [PASS] Firefly Algorithm moveu o vaga-lume pela atracao luminosa!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Firefly Algorithm.")
            }
      }

      println("==================================================")
      println("Firefly Algorithm concluido com sucesso!")
}
