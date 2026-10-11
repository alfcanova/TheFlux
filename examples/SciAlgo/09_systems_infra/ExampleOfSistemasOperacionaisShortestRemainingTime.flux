#L ============================================================================
#L Algoritmo: Shortest Remaining Time First (SRTF) CPU Scheduling (Preemptive)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(T * N) simulacao discreta com preempcao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisShortestRemainingTime) {
      println("==================================================")
      println("  SciAlgo: Shortest Remaining Time First (SRTF)")
      println("==================================================")

      #L O SRTF e a versao preemptiva do Shortest Job First.
      #L A cada unidade de tempo, a CPU pode ser preemptada se um processo
      #L com tempo restante estritamente menor estiver pronto.

      mut as int64: n = 4
      mut as list of int64: at = [0, 1, 2, 3]
      mut as list of int64: bt = [8, 4, 2, 1]
      mut as list of int64: rem_bt = [8, 4, 2, 1]

      mut as list of int64: ct = [0, 0, 0, 0]
      mut as list of int64: tat = [0, 0, 0, 0]
      mut as list of int64: wt = [0, 0, 0, 0]

      println("1. Tabela de Processos:")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": Chegada = " + at[p] + " | Burst = " + bt[p])
            p = p + 1
      }

      println("==================================================")
      println("2. [Simulacao de Escalonamento Preemptivo]:")

      mut as int64: current_time = 0
      mut as int64: completed_count = 0
      mut as int64: prev_proc = 0

      infinite (completed_count < n) {
            #L Encontra processo elegivel com menor tempo restante
            mut as int64: best_idx = 0
            mut as int64: min_rem = 999999

            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        rem_bt[i] > 0 ==> {
                              route {
                                    at[i] <= current_time ==> {
                                          route {
                                                rem_bt[i] < min_rem ==> {
                                                      min_rem = rem_bt[i]
                                                      best_idx = i
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  best_idx == 0 ==> {
                        current_time = current_time + 1
                  }
                  _ ==> {
                        route {
                              best_idx != prev_proc ==> {
                                    println("   [t = " + current_time + "] CPU chaveada para P" + best_idx + " (Restante: " + rem_bt[best_idx] + ")")
                                    prev_proc = best_idx
                              }
                              _ ==> {}
                        }

                        rem_bt[best_idx] = rem_bt[best_idx] - 1
                        current_time = current_time + 1

                        route {
                              rem_bt[best_idx] == 0 ==> {
                                    completed_count = completed_count + 1
                                    ct[best_idx] = current_time
                                    tat[best_idx] = ct[best_idx] - at[best_idx]
                                    wt[best_idx] = tat[best_idx] - bt[best_idx]
                                    println("   [t = " + current_time + "] Processo P" + best_idx + " CONCLUIDO! (CT=" + ct[best_idx] + ", TAT=" + tat[best_idx] + ", WT=" + wt[best_idx] + ")")
                              }
                              _ ==> {}
                        }
                  }
            }
      }

      println("==================================================")
      println("3. Metricas Finais do SRTF:")
      mut as int64: sum_tat = 0
      mut as int64: sum_wt = 0
      mut as int64: k = 1
      infinite (k <= n) {
            sum_tat = sum_tat + tat[k]
            sum_wt = sum_wt + wt[k]
            k = k + 1
      }
      mut as int64: avg_tat = sum_tat * 10 /i n
      mut as int64: avg_wt = sum_wt * 10 /i n
      println("   Tempo Medio de Retorno (Average TAT): " + (avg_tat /i 10) + "." + (avg_tat /r 10))
      println("   Tempo Medio de Espera  (Average WT):  " + (avg_wt /i 10) + "." + (avg_wt /r 10))
      println("==================================================")
}
