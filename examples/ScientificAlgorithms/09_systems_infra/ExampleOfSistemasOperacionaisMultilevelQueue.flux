#L ============================================================================
#L Algoritmo: Multilevel Queue (MLQ) CPU Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N) particionamento em filas com politicas heterogeneas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisMultilevelQueue) {
      println("==================================================")
      println("  SciAlgo: Multilevel Queue (MLQ) Scheduling")
      println("==================================================")

      #L O escalonamento por Filas Multiniveis divide os processos em filas
      #L separadas de acordo com seu perfil de carga:
      #L - Fila 1 (Alta Prioridade - Foreground / Interativo): Politica Round Robin (Q = 2)
      #L - Fila 2 (Baixa Prioridade - Background / Batch): Politica FCFS
      #L Fila 1 possui prioridade absoluta sobre Fila 2 (Fixed Priority Scheduling).

      #L Fila 1 (Interativos): P1 e P2
      mut as list of int64: q1_bt = [3, 2]
      mut as list of int64: q1_rem = [3, 2]

      #L Fila 2 (Batch): P3 e P4
      mut as list of int64: q2_bt = [4, 3]

      println("1. Estrutura das Filas Multiniveis:")
      println("   Fila 1 [Foreground / RR Q=2]: P1 (BT=" + q1_bt[1] + "), P2 (BT=" + q1_bt[2] + ")")
      println("   Fila 2 [Background / FCFS]:   P3 (BT=" + q2_bt[1] + "), P4 (BT=" + q2_bt[2] + ")")

      println("==================================================")
      println("2. [Fase 1: Esvaziando Fila 1 com Round Robin (Quantum = 2)]:")

      mut as int64: current_time = 0
      mut as int64: q1_done = 0
      mut as int64: quantum = 2

      infinite (q1_done < 2) {
            mut as int64: i = 1
            infinite (i <= 2) {
                  route {
                        q1_rem[i] > 0 ==> {
                              mut as int64: slice = quantum
                              route {
                                    q1_rem[i] < quantum ==> { slice = q1_rem[i] }
                                    _ ==> {}
                              }
                              mut as int64: st = current_time
                              current_time = current_time + slice
                              q1_rem[i] = q1_rem[i] - slice
                              println("   [" + st + " -> " + current_time + "] Fila 1 (RR): P" + i + " executou " + slice + " (restante " + q1_rem[i] + ")")

                              route {
                                    q1_rem[i] == 0 ==> {
                                          q1_done = q1_done + 1
                                          println("      -> P" + i + " Interativo CONCLUIDO no tempo " + current_time)
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
      println("3. [Fase 2: Fila 1 Vazia -> Executando Fila 2 com FCFS]:")

      mut as int64: j = 1
      infinite (j <= 2) {
            mut as int64: proc_num = j + 2
            mut as int64: start_b = current_time
            current_time = current_time + q2_bt[j]
            println("   [" + start_b + " -> " + current_time + "] Fila 2 (FCFS): P" + proc_num + " executou burst total " + q2_bt[j] + " -> CONCLUIDO!")
            j = j + 1
      }

      println("==================================================")
      println("4. Resumo do Escalonador MLQ:")
      println("   Tempo total de execucao: " + current_time + " unidades")
      println("   Processos interativos priorizados com baixa latencia.")
      println("   Escalonamento Multinivel Concluido com Exito!")
      println("==================================================")
}
