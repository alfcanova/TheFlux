#L ============================================================================
#L Algoritmo: Shortest Job First (SJF) CPU Scheduling (Non-Preemptive)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N^2) selecao gulosa | Otimo para tempo medio de espera
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisShortestJobFirst) {
      println("==================================================")
      println("  SciAlgo: Shortest Job First (SJF) Scheduling")
      println("==================================================")

      #L O algoritmo SJF (nao-preemptivo) seleciona, dentre os processos ja
      #L chegados na fila de prontos, aquele com o menor tempo de execucao (burst).
      #L E provadamente otimo na minimizacao do tempo medio de espera.

      mut as int64: n = 4
      mut as list of int64: at = [0, 1, 2, 3]
      mut as list of int64: bt = [7, 4, 1, 4]
      mut as list of int64: completed = [0, 0, 0, 0]

      mut as list of int64: ct = [0, 0, 0, 0]
      mut as list of int64: tat = [0, 0, 0, 0]
      mut as list of int64: wt = [0, 0, 0, 0]

      println("1. Processos Disponíveis:")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": Chegada (AT) = " + at[p] + " | Burst (BT) = " + bt[p])
            p = p + 1
      }

      println("==================================================")
      println("2. [Simulacao de Escalonamento SJF]:")

      mut as int64: current_time = 0
      mut as int64: completed_count = 0
      mut as int64: sum_tat = 0
      mut as int64: sum_wt = 0

      infinite (completed_count < n) {
            #L Encontra processo elegivel com menor BT
            mut as int64: best_idx = 0
            mut as int64: min_bt = 999999

            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        completed[i] == 0 ==> {
                              route {
                                    at[i] <= current_time ==> {
                                          route {
                                                bt[i] < min_bt ==> {
                                                      min_bt = bt[i]
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
                        #L CPU ociosa: avanca tempo
                        current_time = current_time + 1
                  }
                  _ ==> {
                        #L Executa processo escolhido
                        mut as int64: start_t = current_time
                        current_time = current_time + bt[best_idx]
                        ct[best_idx] = current_time
                        tat[best_idx] = ct[best_idx] - at[best_idx]
                        wt[best_idx] = tat[best_idx] - bt[best_idx]
                        completed[best_idx] = 1
                        completed_count = completed_count + 1

                        sum_tat = sum_tat + tat[best_idx]
                        sum_wt = sum_wt + wt[best_idx]

                        println("   [" + start_t + " -> " + current_time + "] Executa P" + best_idx + " (BT=" + bt[best_idx] + ") | CT=" + ct[best_idx] + " | TAT=" + tat[best_idx] + " | WT=" + wt[best_idx])
                  }
            }
      }

      println("==================================================")
      println("3. Metricas Globais do SJF:")
      mut as int64: avg_tat = sum_tat * 10 /i n
      mut as int64: avg_wt = sum_wt * 10 /i n
      println("   Tempo Medio de Retorno (Average TAT): " + (avg_tat /i 10) + "." + (avg_tat /r 10))
      println("   Tempo Medio de Espera  (Average WT):  " + (avg_wt /i 10) + "." + (avg_wt /r 10))
      println("==================================================")
}
