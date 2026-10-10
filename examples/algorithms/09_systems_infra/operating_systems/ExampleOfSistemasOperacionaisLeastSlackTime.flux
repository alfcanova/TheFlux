#L ============================================================================
#L Algoritmo: Least Slack Time (LST) / Minimum Laxity First Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(T * N) recalculo dinamico de folga (slack time)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisLeastSlackTime) {
      println("==================================================")
      println("  SciAlgo: Least Slack Time (LST) Scheduling")
      println("==================================================")

      #L O algoritmo LST (ou Minimum Laxity First) seleciona a tarefa com a
      #L menor folga temporal (slack time).
      #L Folga(t) = (Deadline - t) - Computacao_Restante.
      #L Se a folga for zero, a tarefa deve rodar ininterruptamente para nao perder o prazo.

      mut as int64: n = 2
      #L Tarefa 1: Chegada = 0, Burst = 3, Deadline = 7
      #L Tarefa 2: Chegada = 0, Burst = 2, Deadline = 5
      mut as list of int64: bt = [3, 2]
      mut as list of int64: rem_bt = [3, 2]
      mut as list of int64: deadline = [7, 5]

      println("1. Parametros das Tarefas:")
      println("   Tarefa 1: Burst = " + bt[1] + ", Deadline = " + deadline[1] + " (Folga inicial: (7 - 0) - 3 = 4)")
      println("   Tarefa 2: Burst = " + bt[2] + ", Deadline = " + deadline[2] + " (Folga inicial: (5 - 0) - 2 = 3)")

      println("==================================================")
      println("2. [Simulacao do Escalonamento por Folga Minima]:")

      mut as int64: t = 0
      mut as int64: completed_count = 0

      infinite (completed_count < n) {
            #L Calcula folga para tarefas ativas
            mut as int64: slack1 = 999999
            route {
                  rem_bt[1] > 0 ==> {
                        slack1 = (deadline[1] - t) - rem_bt[1]
                  }
                  _ ==> {}
            }

            mut as int64: slack2 = 999999
            route {
                  rem_bt[2] > 0 ==> {
                        slack2 = (deadline[2] - t) - rem_bt[2]
                  }
                  _ ==> {}
            }

            #L Escolhe a tarefa com menor folga
            mut as int64: chosen = 0
            route {
                  slack1 <= slack2 ==> {
                        route {
                              slack1 < 999999 ==> { chosen = 1 }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        route {
                              slack2 < 999999 ==> { chosen = 2 }
                              _ ==> {}
                        }
                  }
            }

            route {
                  chosen == 1 ==> {
                        rem_bt[1] = rem_bt[1] - 1
                        println("   [t=" + t + "] Executa Tarefa 1 | Folga T1=" + slack1 + ", Folga T2=" + slack2 + " (restam " + rem_bt[1] + " unid)")
                        route {
                              rem_bt[1] == 0 ==> {
                                    completed_count = completed_count + 1
                                    println("      -> Tarefa 1 CONCLUIDA com sucesso no tempo " + (t + 1))
                              }
                              _ ==> {}
                        }
                  }
                  chosen == 2 ==> {
                        rem_bt[2] = rem_bt[2] - 1
                        println("   [t=" + t + "] Executa Tarefa 2 | Folga T1=" + slack1 + ", Folga T2=" + slack2 + " (restam " + rem_bt[2] + " unid)")
                        route {
                              rem_bt[2] == 0 ==> {
                                    completed_count = completed_count + 1
                                    println("      -> Tarefa 2 CONCLUIDA com sucesso no tempo " + (t + 1))
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            t = t + 1
      }

      println("==================================================")
      println("3. Conclusao do Escalonamento LST:")
      println("   Ambas as tarefas finalizaram rigorosamente antes de seus prazos.")
      println("   Tempo total decorrido: " + t + " unidades.")
      println("==================================================")
}
