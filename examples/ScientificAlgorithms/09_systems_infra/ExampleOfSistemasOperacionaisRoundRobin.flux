#L ============================================================================
#L Algoritmo: Round Robin (RR) CPU Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N) por rodada | Time-sharing com Quantum Q
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisRoundRobin) {
      println("==================================================")
      println("  SciAlgo: Round Robin (RR) Scheduling")
      println("==================================================")

      #L O Round Robin e o algoritmo basico para sistemas de tempo compartilhado.
      #L Cada processo recebe uma fatia fixa de tempo de CPU (Quantum Q).
      #L Se o processo nao terminar dentro do quantum, e preemptado e colocado
      #L no final da fila circular.

      mut as int64: n = 4
      mut as int64: quantum = 2

      mut as list of int64: bt = [5, 4, 2, 1]
      mut as list of int64: rem_bt = [5, 4, 2, 1]

      mut as list of int64: ct = [0, 0, 0, 0]
      mut as list of int64: tat = [0, 0, 0, 0]
      mut as list of int64: wt = [0, 0, 0, 0]

      println("1. Parametros do Escalonador RR:")
      println("   Numero de Processos: " + n + " | Quantum: " + quantum + " unidades")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": Burst Time = " + bt[p])
            p = p + 1
      }

      println("==================================================")
      println("2. [Simulacao Circular do Round Robin]:")

      mut as int64: current_time = 0
      mut as int64: completed_count = 0

      infinite (completed_count < n) {
            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        rem_bt[i] > 0 ==> {
                              mut as int64: time_slice = quantum
                              route {
                                    rem_bt[i] < quantum ==> {
                                          time_slice = rem_bt[i]
                                    }
                                    _ ==> {}
                              }

                              mut as int64: start_t = current_time
                              current_time = current_time + time_slice
                              rem_bt[i] = rem_bt[i] - time_slice

                              println("   [" + start_t + " -> " + current_time + "] Executando fatia de P" + i + " (executou " + time_slice + ", restante " + rem_bt[i] + ")")

                              route {
                                    rem_bt[i] == 0 ==> {
                                          completed_count = completed_count + 1
                                          ct[i] = current_time
                                          tat[i] = ct[i]
                                          wt[i] = tat[i] - bt[i]
                                          println("      -> P" + i + " CONCLUIDO! (CT=" + ct[i] + ", TAT=" + tat[i] + ", WT=" + wt[i] + ")")
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }
      }

      println("==================================================")
      println("3. Metricas Globais do Round Robin:")
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
      println("   Escalonamento justo sem inanicao (starvation)!")
      println("==================================================")
}
