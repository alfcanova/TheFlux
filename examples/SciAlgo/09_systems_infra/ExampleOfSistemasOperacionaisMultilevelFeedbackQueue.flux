#L ============================================================================
#L Algoritmo: Multilevel Feedback Queue (MLFQ) CPU Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N * Q) adaptativo baseado no comportamento de CPU dos processos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisMultilevelFeedbackQueue) {
      println("==================================================")
      println("  SciAlgo: Multilevel Feedback Queue (MLFQ)")
      println("==================================================")

      #L O MLFQ ajusta dinamicamente a prioridade dos processos:
      #L - Fila 0 (Topo): RR com Quantum Q0 = 1 (alta prioridade para I/O-bound).
      #L - Fila 1 (Meio): RR com Quantum Q1 = 2.
      #L - Fila 2 (Base): FCFS (processos longos CPU-bound).
      #L Se um processo esgota seu quantum sem terminar, e rebaixado (demoted).

      mut as int64: n = 3
      #L P1: Curto (BT = 1), P2: Medio (BT = 3), P3: Longo (BT = 5)
      mut as list of int64: bt = [1, 3, 5]
      mut as list of int64: rem_bt = [1, 3, 5]
      #L Nivel da fila atual de cada processo: 0, 1 ou 2
      mut as list of int64: queue_level = [0, 0, 0]

      println("1. Processos Iniciais (Todos entram na Fila 0):")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": Burst Total = " + bt[p] + " | Fila Inicial = Q0")
            p = p + 1
      }

      println("==================================================")
      println("2. [Simulacao Dinamica do MLFQ]:")

      mut as int64: current_time = 0
      mut as int64: completed_count = 0

      #L ======================================================================
      #L Nivel 0: Quantum = 1
      #L ======================================================================
      println("--- Executando Fila 0 (Quantum Q0 = 1) ---")
      mut as int64: i0 = 1
      infinite (i0 <= n) {
            route {
                  rem_bt[i0] > 0 ==> {
                        mut as int64: slice0 = 1
                        current_time = current_time + slice0
                        rem_bt[i0] = rem_bt[i0] - slice0
                        println("   [t=" + current_time + "] Q0: P" + i0 + " executou 1 unid (restante: " + rem_bt[i0] + ")")

                        route {
                              rem_bt[i0] == 0 ==> {
                                    completed_count = completed_count + 1
                                    println("      -> P" + i0 + " CONCLUIDO em Q0 (I/O-friendly, tempo=" + current_time + ")")
                              }
                              _ ==> {
                                    queue_level[i0] = 1 #L Rebaixado para Q1
                                    println("      -> P" + i0 + " esgotou quantum Q0 -> REBAIXADO para Fila 1!")
                              }
                        }
                  }
                  _ ==> {}
            }
            i0 = i0 + 1
      }

      #L ======================================================================
      #L Nivel 1: Quantum = 2
      #L ======================================================================
      println("--- Executando Fila 1 (Quantum Q1 = 2) ---")
      mut as int64: i1 = 1
      infinite (i1 <= n) {
            route {
                  queue_level[i1] == 1 ==> {
                        route {
                              rem_bt[i1] > 0 ==> {
                                    mut as int64: slice1 = 2
                                    route {
                                          rem_bt[i1] < 2 ==> { slice1 = rem_bt[i1] }
                                          _ ==> {}
                                    }
                                    current_time = current_time + slice1
                                    rem_bt[i1] = rem_bt[i1] - slice1
                                    println("   [t=" + current_time + "] Q1: P" + i1 + " executou " + slice1 + " unid (restante: " + rem_bt[i1] + ")")

                                    route {
                                          rem_bt[i1] == 0 ==> {
                                                completed_count = completed_count + 1
                                                println("      -> P" + i1 + " CONCLUIDO em Q1 (tempo=" + current_time + ")")
                                          }
                                          _ ==> {
                                                queue_level[i1] = 2 #L Rebaixado para Q2
                                                println("      -> P" + i1 + " esgotou quantum Q1 -> REBAIXADO para Fila 2!")
                                          }
                                    }
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            i1 = i1 + 1
      }

      #L ======================================================================
      #L Nivel 2: FCFS (Processos CPU-bound)
      #L ======================================================================
      println("--- Executando Fila 2 (FCFS / CPU-Bound) ---")
      mut as int64: i2 = 1
      infinite (i2 <= n) {
            route {
                  queue_level[i2] == 2 ==> {
                        route {
                              rem_bt[i2] > 0 ==> {
                                    mut as int64: slice2 = rem_bt[i2]
                                    current_time = current_time + slice2
                                    rem_bt[i2] = 0
                                    completed_count = completed_count + 1
                                    println("   [t=" + current_time + "] Q2: P" + i2 + " executou burst restante (" + slice2 + " unid) -> CONCLUIDO!")
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            i2 = i2 + 1
      }

      println("==================================================")
      println("3. Resumo da Execucao MLFQ:")
      println("   Tempo total: " + current_time + " unidades")
      println("   P1 (interativo) terminou rapidamente na Fila 0.")
      println("   P3 (CPU-bound) foi rebaixado ate a Fila 2 sem prejudicar a interatividade.")
      println("==================================================")
}
