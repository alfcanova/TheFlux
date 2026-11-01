#L ============================================================================
#L Algoritmo: Space-Saving Algorithm (Metwally et al. 2005 - Heavy Hitters)
#L Dominio: 02_data_structures / Categoria: 3. Algoritmos de selecao e streaming (Adicoes Prioritarias)
#L Complexidade: O(1) espaco O(K) | O(K) atualizacao por evento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingSpaceSaving) {
      println("==================================================")
      println("  SciAlgo: Space-Saving (Streaming Heavy Hitters)")
      println("==================================================")

      #L Capacidade k = 3 contadores para encontrar os itens mais frequentes (Top-K)
      mut as int64: k = 3
      println("1. Inicializando Space-Saving com k = " + k + " contadores...")

      mut as list of int64: monitored_item = [0, 0, 0]
      mut as list of int64: monitored_count = [0, 0, 0]
      mut as list of int64: monitored_error = [0, 0, 0]
      mut as int64: cur_size = 0

      #L Stream de 17 eventos:
      #L Item 10: 8 ocorrencias (heavy hitter dominante)
      #L Item 20: 5 ocorrencias
      #L Itens esparsos: 30 (2x), 40 (1x), 50 (1x)
      mut as list of int64: stream = [
            10, 20, 10, 30, 10, 20, 10, 40,
            10, 20, 10, 50, 10, 20, 10, 20, 30
      ]
      mut as int64: n_events = listLength(stream)
      println("2. Processando stream de " + n_events + " elementos...")

      mut as int64: idx = 1
      infinite (idx <= n_events) {
            mut as int64: x = stream[idx]

            #L 1. Verifica se x ja esta nos contadores monitorados
            mut as int64: found_idx = 0
            mut as int64: j = 1
            infinite (j <= cur_size) {
                  route {
                        monitored_item[j] == x ==> {
                              found_idx = j
                              break
                        }
                  }
                  j = j + 1
            }

            route {
                  found_idx != 0 ==> {
                        #L Ja existe: apenas incrementa contador
                        monitored_count[found_idx] = monitored_count[found_idx] + 1
                  }
                  _ ==> {
                        route {
                              cur_size < k ==> {
                                    #L Ha espaco livre no vetor de contadores
                                    cur_size = cur_size + 1
                                    monitored_item[cur_size] = x
                                    monitored_count[cur_size] = 1
                                    monitored_error[cur_size] = 0
                              }
                              _ ==> {
                                    #L Tabela cheia: encontra vitima com menor contagem
                                    mut as int64: min_idx = 1
                                    mut as int64: min_c = monitored_count[1]
                                    mut as int64: m = 2
                                    infinite (m <= k) {
                                          route {
                                                monitored_count[m] < min_c ==> {
                                                      min_c = monitored_count[m]
                                                      min_idx = m
                                                }
                                          }
                                          m = m + 1
                                    }

                                    #L Substitui vitima: novo item herda min_c como cota de erro
                                    monitored_item[min_idx] = x
                                    monitored_error[min_idx] = min_c
                                    monitored_count[min_idx] = min_c + 1
                              }
                        }
                  }
            }

            idx = idx + 1
      }
      println("   Stream processado com sucesso.")

      #L 3. Exibicao e Validacao dos Heavy Hitters Top-K
      println("3. Resultados do Space-Saving:")
      mut as int64: i = 1
      infinite (i <= cur_size) {
            mut as int64: it = monitored_item[i]
            mut as int64: cnt = monitored_count[i]
            mut as int64: err = monitored_error[i]
            println("   Item " + it + " -> count = " + cnt + " (cota de erro = " + err + ")")
            i = i + 1
      }

      #L Localiza contadores dos itens 10 e 20
      mut as int64: c10 = 0
      mut as int64: e10 = 0
      mut as int64: c20 = 0
      mut as int64: e20 = 0

      i = 1
      infinite (i <= cur_size) {
            route {
                  monitored_item[i] == 10 ==> {
                        c10 = monitored_count[i]
                        e10 = monitored_error[i]
                  }
                  monitored_item[i] == 20 ==> {
                        c20 = monitored_count[i]
                        e20 = monitored_error[i]
                  }
            }
            i = i + 1
      }

      #L Garantias teoricas do algoritmo Space-Saving:
      #L count[x] - error[x] <= true_freq(x) <= count[x]
      #L Frequencias reais: item 10 = 8 | item 20 = 5
      mut as bool: g10_ok = ((c10 - e10) <= 8) and (8 <= c10)
      mut as bool: g20_ok = ((c20 - e20) <= 5) and (5 <= c20)
      println("4. Garantias teoricas satisfeitas para item 10: " + g10_ok)
      println("   Garantias teoricas satisfeitas para item 20: " + g20_ok)

      mut as bool: ok = g10_ok and g20_ok and (c10 >= 8) and (c20 >= 5)
      println("5. Verificacao geral do Space-Saving Algorithm: " + ok)
      println("Concluido com Sucesso")
}
