#L ============================================================================
#L Algoritmo: Shortest Seek Time First (SSTF) Disk Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N^2) selecao gulosa pelo cilindro mais proximo do cabecote
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisShortestSeekTimeFirst) {
      println("==================================================")
      println("  SciAlgo: Shortest Seek Time First (SSTF)")
      println("==================================================")

      #L O algoritmo SSTF atende sempre a requisicao pendente mais proxima
      #L da posicao atual do cabecote (menor distancia absoluta |cilindro - cabecote|).
      #L Minimiza localmente o tempo de busca, mas pode provocar inanicao (starvation)
      #L de requisicoes perifericas distantes.

      mut as int64: head_start = 50
      mut as int64: num_reqs = 7
      mut as list of int64: reqs = [82, 170, 43, 140, 24, 16, 190]
      mut as list of int64: serviced = [0, 0, 0, 0, 0, 0, 0]

      println("1. Parametros do Agendador SSTF:")
      println("   Posicao Inicial do Cabecote: " + head_start)
      println("   Fila de Requisicoes: [82, 170, 43, 140, 24, 16, 190]")

      println("==================================================")
      println("2. [Simulacao Gulosa de Atendimento]:")

      mut as int64: current_pos = head_start
      mut as int64: total_seek = 0
      mut as int64: serviced_count = 0

      infinite (serviced_count < num_reqs) {
            mut as int64: best_idx = 0
            mut as int64: min_dist = 999999

            mut as int64: i = 1
            infinite (i <= num_reqs) {
                  route {
                        serviced[i] == 0 ==> {
                              mut as int64: diff = reqs[i] - current_pos
                              route {
                                    diff < 0 ==> { diff = 0 - diff }
                                    _ ==> {}
                              }

                              route {
                                    diff < min_dist ==> {
                                          min_dist = diff
                                          best_idx = i
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            serviced[best_idx] = 1
            serviced_count = serviced_count + 1
            mut as int64: target_cyl = reqs[best_idx]
            total_seek = total_seek + min_dist

            println("   [Passo " + serviced_count + "] Move de " + current_pos + " -> " + target_cyl + " (Seek = " + min_dist + ")")
            current_pos = target_cyl
      }

      println("==================================================")
      println("3. Metricas Finais do SSTF:")
      println("   Posicao Final do Cabecote: " + current_pos)
      println("   Deslocamento Total de Cilindros: " + total_seek)
      println("   Otimizacao gulosa concluida com sucesso!")
      println("==================================================")
}
