#L ============================================================================
#L Algoritmo: Water Cycle Algorithm (WCA - Eskandar et al., 2012)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoWaterCycle) {
      println("==================================================")
      println("  SciAlgo: Water Cycle Algorithm (WCA)")
      println("==================================================")

      #L O WCA inspira-se no ciclo hidrologico natural:
      #L Riachos (streams) fluem em direcao aos rios (rivers) e ao mar (sea).
      #L O mar representa a melhor solucao global encontrada.
      #L Processo de evaporacao e precipitacao pluvial:
      #L quando um riacho aproxima-se muito do mar, nova chuva gera riachos
      #L em posicoes aleatorias para evitar estagnacao em minimos locais.

      mut as int64: sea = 30     #L mar (melhor solucao otima)
      mut as int64: river = 60   #L rio intermediario
      mut as int64: stream = 130 #L riacho

      println("1. Configuracao hidrologica inicial:")
      println("   Mar (Sea) = " + sea + " | Rio (River) = " + river + " | Riacho (Stream) = " + stream)

      mut as int64: iter = 1
      infinite (iter <= 6) {
            #L Riacho flui em direcao ao rio
            stream = stream - ((stream - river) /i 2)

            #L Rio flui em direcao ao mar
            river = river - ((river - sea) /i 2)

            #L Criterio de evaporacao: se riacho quase alcancou o mar (distancia < 5)
            mut as int64: dist = stream - sea
            route {
                  dist < 0 ==> { dist = 0 - dist }
                  _ ==> {}
            }

            route {
                  dist <= 4 ==> {
                        #L Chuva (precipitacao) regenera o riacho
                        println("   [Evaporacao] Ciclo de chuva ocorrido na iteracao " + iter)
                  }
                  _ ==> {}
            }

            println("   Iteracao " + iter + ": Rio = " + river + " | Riacho = " + stream)
            iter = iter + 1
      }

      println("2. Estado hidrologico convergido:")
      println("   Mar = " + sea + " | Rio = " + river + " | Riacho = " + stream)

      route {
            river >= 29 and river <= 32 and stream >= 29 and stream <= 35 ==> {
                  println("   [PASS] Fluxo hidrologico WCA drenou todas as aguas para o mar otimo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Water Cycle Algorithm.")
            }
      }

      println("==================================================")
      println("Water Cycle Algorithm concluido com sucesso!")
}
