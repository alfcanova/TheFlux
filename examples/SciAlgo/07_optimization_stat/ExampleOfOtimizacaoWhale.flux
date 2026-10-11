#L ============================================================================
#L Algoritmo: Whale Optimization Algorithm (WOA - Mirjalili & Lewis, 2016)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoWhale) {
      println("==================================================")
      println("  SciAlgo: Whale Optimization Algorithm (WOA)")
      println("==================================================")

      #L O WOA simula a caca de baleias-jubarte com rede de bolhas (bubble-net):
      #L 1. Cerco da presa (encircling): X(t+1) = X*(t) - A * D
      #L 2. Ataque em espiral (spiral bubble-net): X(t+1) = D' * e^{bl} * cos(2pi l) + X*(t)
      #L 3. Busca de presas (exploracao): escolha aleatoria de baleia de referencia quando |A| >= 1

      mut as int64: x_best = 40  #L posicao da melhor presa
      mut as int64: x_whale = 160 #L baleia em busca

      println("1. Posicao inicial:")
      println("   Baleia = " + x_whale + " | Presa alvo X* = " + x_best)

      mut as int64: iter = 1
      infinite (iter <= 7) {
            #L Distancia ate a melhor presa
            mut as int64: dist = x_whale - x_best
            route {
                  dist < 0 ==> { dist = 0 - dist }
                  _ ==> {}
            }

            #L Alternancia entre espiral (50%) e encolhimento de cerco (50%)
            mut as int64: rem2 = iter /r 2
            route {
                  rem2 == 1 ==> {
                        #L Movimento espiral (aproximacao proporcional suave)
                        x_whale = x_best + (dist /i 3)
                  }
                  _ ==> {
                        #L Cerco direto
                        x_whale = x_whale - (dist /i 2)
                  }
            }

            println("   Iteracao " + iter + ": posicao da baleia = " + x_whale)
            iter = iter + 1
      }

      println("2. Posicao final alcancada pela baleia: " + x_whale)

      route {
            x_whale >= 39 and x_whale <= 45 ==> {
                  println("   [PASS] WOA convergiu na captura em rede de bolhas!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Whale Optimization Algorithm.")
            }
      }

      println("==================================================")
      println("Whale Optimization concluido com sucesso!")
}
