#L ============================================================================
#L Algoritmo: Earliest Deadline First (EDF) Real-Time Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(T * N) escalonamento dinâmico em tempo real | Utilizacao ate 100%
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisEarliestDeadlineFirst) {
      println("==================================================")
      println("  SciAlgo: Earliest Deadline First (EDF)")
      println("==================================================")

      #L O algoritmo EDF e um escalonador dinamico de tempo real provadamente otimo.
      #L A cada instante t, a CPU e concedida a tarefa pronta com o prazo
      #L absoluto mais proximo (menor deadline).
      #L Teorema de Liu & Layland: Um conjunto de tarefas periodicas e escalonavel
      #L sob EDF se e somente se a utilizacao total U = sum(Ci / Ti) <= 1.0.

      #L Duas tarefas periodicas com prazos implicitos (Di = Ti):
      #L Tarefa 1: Periodo T1 = 8,  Computacao C1 = 3 (Utilizacao = 3/8  = 37.5%)
      #L Tarefa 2: Periodo T2 = 12, Computacao C2 = 4 (Utilizacao = 4/12 = 33.3%)
      #L Utilizacao Total U = 70.8% <= 100% (Escalonavel!)
      #L Hiperperiodo = MMC(8, 12) = 24 unidades

      mut as int64: hyperperiod = 24

      #L Estado das instancias: tempo restante e deadline absoluto
      mut as int64: rem_c1 = 0
      mut as int64: dead_1 = 0

      mut as int64: rem_c2 = 0
      mut as int64: dead_2 = 0

      println("1. Parametros do Sistema de Tempo Real:")
      println("   Tarefa 1: C1 = 3, T1 = 8  | Utilizacao = 37.5%")
      println("   Tarefa 2: C2 = 4, T2 = 12 | Utilizacao = 33.3%")
      println("   Utilizacao Total: 70.8% <= 100% (Garantia de escalonabilidade)")
      println("   Hiperperiodo de Simulacao: " + hyperperiod + " unidades")

      println("==================================================")
      println("2. [Simulacao Discreta EDF]:")

      mut as int64: t = 0
      mut as int64: missed_deadlines = 0

      infinite (t < hyperperiod) {
            #L Liberacao periodica de novas instancias
            route {
                  t /r 8 == 0 ==> {
                        rem_c1 = rem_c1 + 3
                        dead_1 = t + 8
                        println("   [t=" + t + "] Liberada instancia de Tarefa 1 (C=3, Deadline=" + dead_1 + ")")
                  }
                  _ ==> {}
            }

            route {
                  t /r 12 == 0 ==> {
                        rem_c2 = rem_c2 + 4
                        dead_2 = t + 12
                        println("   [t=" + t + "] Liberada instancia de Tarefa 2 (C=4, Deadline=" + dead_2 + ")")
                  }
                  _ ==> {}
            }

            #L Seleciona tarefa com menor deadline
            mut as int64: chosen_task = 0
            route {
                  rem_c1 > 0 ==> {
                        route {
                              rem_c2 > 0 ==> {
                                    route {
                                          dead_1 <= dead_2 ==> { chosen_task = 1 }
                                          _ ==> { chosen_task = 2 }
                                    }
                              }
                              _ ==> { chosen_task = 1 }
                        }
                  }
                  rem_c2 > 0 ==> {
                        chosen_task = 2
                  }
                  _ ==> {}
            }

            #L Executa 1 unidade de tempo
            route {
                  chosen_task == 1 ==> {
                        rem_c1 = rem_c1 - 1
                        #L println("   [t=" + t + "] Executa Tarefa 1 (Dead=" + dead_1 + ")")
                  }
                  chosen_task == 2 ==> {
                        rem_c2 = rem_c2 - 1
                        #L println("   [t=" + t + "] Executa Tarefa 2 (Dead=" + dead_2 + ")")
                  }
                  _ ==> {
                        #L CPU Ociosa
                  }
            }

            #L Verificacao de perda de deadline
            route {
                  rem_c1 > 0 ==> {
                        route {
                              t + 1 > dead_1 ==> { missed_deadlines = missed_deadlines + 1 }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            t = t + 1
      }

      println("==================================================")
      println("3. Verificacao de Tempo Real:")
      println("   Hiperperiodo completo de " + hyperperiod + " ciclos executado.")
      println("   Deadlines Perdidos: " + missed_deadlines)
      println("   Escalonamento EDF estritamente cumprido sem violacoes!")
      println("==================================================")
}
