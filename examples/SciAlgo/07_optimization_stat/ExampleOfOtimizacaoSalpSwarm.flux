#L ============================================================================
#L Algoritmo: Salp Swarm Algorithm (SSA - Mirjalili et al., 2017)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSalpSwarm) {
      println("==================================================")
      println("  SciAlgo: Salp Swarm Algorithm (SSA)")
      println("==================================================")

      #L O SSA simula o enxame e a cadeia de salpas no oceano:
      #L A salpa lider guia a cadeia em direcao a fonte de alimento F.
      #L As salpas seguidoras ajustam suas posicoes pela dinamica de Newton:
      #L x_i(t+1) = (x_i(t) + x_{i-1}(t)) / 2

      mut as int64: food_source = 30 #L posicao da fonte de alimento F
      #L Cadeia de 3 salpas: lider x1, seguidora x2, seguidora x3
      mut as int64: x1 = 120 #L lider
      mut as int64: x2 = 140 #L seguidora 1
      mut as int64: x3 = 160 #L seguidora 2

      println("1. Cadeia inicial de salpas:")
      println("   Lider x1 = " + x1 + " | x2 = " + x2 + " | x3 = " + x3)
      println("   Fonte de alimento F = " + food_source)

      mut as int64: iter = 1
      infinite (iter <= 6) {
            #L Lider move-se em direcao ao alimento F
            x1 = food_source + ((x1 - food_source) /i 3)

            #L Seguidoras propagam a cadeia
            x2 = (x2 + x1) /i 2
            x3 = (x3 + x2) /i 2

            println("   Iteracao " + iter + ": Lider x1 = " + x1 + " | Cauda x3 = " + x3)
            iter = iter + 1
      }

      println("2. Posicao final da cadeia de salpas:")
      println("   Lider x1 = " + x1 + " | x2 = " + x2 + " | x3 = " + x3)

      route {
            x1 >= 29 and x1 <= 32 and x3 >= 29 and x3 <= 38 ==> {
                  println("   [PASS] Cadeia de salpas SSA alcancou a fonte de alimento!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Salp Swarm Algorithm.")
            }
      }

      println("==================================================")
      println("Salp Swarm Algorithm concluido com sucesso!")
}
