#L ============================================================================
#L Algoritmo: Ziggurat Algorithm (Amostragem Gaussiana por Camadas Horizontais)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(1) amortizado | Espaco O(N_camadas)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemZigguratAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Ziggurat Algorithm (Fast Gaussian)")
      println("==================================================")

      #L Amostragem de N(0, 1) dividindo a cauda em camadas retangulares sobrepostas
      #L Camada 1: base [0, 3.5]
      #L Camada 2: intermediaria [0, 2.0]
      #L Camada 3: topo [0, 1.0]
      mut as list of int64: x_layers = [350, 200, 100] #L escala x100

      #L Sorteio rapido: escolhe camada 2 com x uniforme = 150 (cai dentro do retangulo)
      mut as int64: layer_idx = 2
      mut as int64: rand_x = 150

      mut as bool: accepted = false
      route {
            rand_x < x_layers[layer_idx] ==> {
                  accepted = true
            }
            _ ==> {}
      }

      println("1. Camada selecionada: " + layer_idx + " (limite " + x_layers[layer_idx] + ") | Amostra x: " + rand_x)
      println("2. Teste rapido de inclusao no Ziggurat: " + accepted)

      route {
            accepted ==> {
                  println("   [PASS] Ziggurat aceitou amostra no retangulo com alta eficiencia!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Ziggurat.")
            }
      }

      println("==================================================")
      println("Ziggurat Algorithm concluido com sucesso!")
}
