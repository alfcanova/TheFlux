#L ============================================================================
#L Algoritmo: Critical Path Method (Metodo do Caminho Critico / CPM)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosCriticalPathMethod) {
      println("==================================================")
      println("  SciAlgo: Critical Path Method (CPM Scheduling)  ")
      println("==================================================")

      mut as int64: num_tasks = 5

      #L Duracao de cada atividade
      #L Tarefa 1 (Planejamento): 3 dias
      #L Tarefa 2 (Design): 4 dias
      #L Tarefa 3 (Aquisicao): 2 dias
      #L Tarefa 4 (Construcao): 5 dias
      #L Tarefa 5 (Testes): 3 dias
      mut as list of int64: duration = [3, 4, 2, 5, 3]

      #L Grafo de precedencias (5x5): 1 se i precede j
      #L 1 precede 2 e 3
      #L 2 precede 4
      #L 3 precede 5
      #L 4 precede 5
      mut as list of int64: adj = [
            0, 1, 1, 0, 0,
            0, 0, 0, 1, 0,
            0, 0, 0, 0, 1,
            0, 0, 0, 0, 1,
            0, 0, 0, 0, 0
      ]

      println("1. Atividades do Projeto:")
      println("   T1 (dur 3), T2 (dur 4, pos T1), T3 (dur 2, pos T1)")
      println("   T4 (dur 5, pos T2), T5 (dur 3, pos T3 e T4)")

      #L FASE 1: Passe para Frente (Forward Pass)
      #L Calcula Early Start (ES) e Early Finish (EF = ES + duration)
      mut as list of int64: es = [0, 0, 0, 0, 0]
      mut as list of int64: ef = [0, 0, 0, 0, 0]

      mut as int64: j = 1
      mut as int64: i = 1

      infinite (j <= num_tasks) {
            mut as int64: max_prev_ef = 0
            i = 1
            infinite (i <= num_tasks) {
                  route {
                        adj[(i - 1) * num_tasks + j] == 1 ==> {
                              route {
                                    ef[i] > max_prev_ef ==> {
                                          max_prev_ef = ef[i]
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            es[j] = max_prev_ef
            ef[j] = es[j] + duration[j]
            j = j + 1
      }

      #L Duracao total do projeto
      mut as int64: project_duration = 0
      i = 1
      infinite (i <= num_tasks) {
            route {
                  ef[i] > project_duration ==> {
                        project_duration = ef[i]
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("2. Duracao Minima Total do Projeto: " + project_duration + " dias.")

      #L FASE 2: Passe para Tras (Backward Pass)
      #L Calcula Late Finish (LF) e Late Start (LS = LF - duration)
      mut as list of int64: lf = [0, 0, 0, 0, 0]
      mut as list of int64: ls = [0, 0, 0, 0, 0]

      j = num_tasks
      infinite (j >= 1) {
            mut as int64: min_next_ls = 999999
            mut as bool: has_successor = false

            i = 1
            infinite (i <= num_tasks) {
                  route {
                        adj[(j - 1) * num_tasks + i] == 1 ==> {
                              has_successor = true
                              route {
                                    ls[i] < min_next_ls ==> {
                                          min_next_ls = ls[i]
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  has_successor ==> {
                        lf[j] = min_next_ls
                  }
                  _ ==> {
                        lf[j] = project_duration
                  }
            }

            ls[j] = lf[j] - duration[j]
            j = j - 1
      }

      #L FASE 3: Folga (Slack/Float = LS - ES) e Identificacao do Caminho Critico
      println("3. Cronograma e Analise de Folgas:")
      mut as list of int64: slack = [0, 0, 0, 0, 0]
      mut as list of bool: is_critical = [false, false, false, false, false]

      i = 1
      infinite (i <= num_tasks) {
            slack[i] = ls[i] - es[i]
            route {
                  slack[i] == 0 ==> {
                        is_critical[i] = true
                        println("   Tarefa " + i + ": ES=" + es[i] + ", EF=" + ef[i] + ", LS=" + ls[i] + ", LF=" + lf[i] + ", Folga=0 -> [CRITICA]")
                  }
                  _ ==> {
                        println("   Tarefa " + i + ": ES=" + es[i] + ", EF=" + ef[i] + ", LS=" + ls[i] + ", LF=" + lf[i] + ", Folga=" + slack[i])
                  }
            }
            i = i + 1
      }

      println("4. Caminho Critico Identificado:")
      i = 1
      infinite (i <= num_tasks) {
            route {
                  is_critical[i] ==> {
                        println("   -> Tarefa " + i + " (duracao " + duration[i] + ")")
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("Critical Path Method concluido com sucesso.")
}
