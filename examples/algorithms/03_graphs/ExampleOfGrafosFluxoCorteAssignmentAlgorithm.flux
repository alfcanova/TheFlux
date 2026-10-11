#L ============================================================================
#L Algoritmo: Assignment Algorithm (Problema de Atribuicao Linear / LAP)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(N^3) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteAssignmentAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Linear Sum Assignment Algorithm (LAP)  ")
      println("==================================================")

      mut as int64: n = 3

      #L Matriz de custos 3x3 (Trabalhadores x Tarefas)
      #L Trabalhador 1: [10, 5, 12]
      #L Trabalhador 2: [8, 15, 6]
      #L Trabalhador 3: [7, 9, 14]
      mut as list of int64: cost = [
            10, 5, 12,
            8, 15, 6,
            7, 9, 14
      ]

      println("1. Matriz de Custos da Atribuicao (3x3):")
      println("   Trabalhador 1: [10, 5, 12]")
      println("   Trabalhador 2: [8, 15, 6]")
      println("   Trabalhador 3: [7, 9, 14]")

      #L Potenciais duais dos trabalhadores (u) e tarefas (v)
      mut as list of int64: u_pot = [0, 0, 0]
      mut as list of int64: v_pot = [0, 0, 0]

      #L Atribuicao atual: task_assigned_to[j] indica qual trabalhador realiza a tarefa j
      mut as list of int64: task_owner = [0, 0, 0]
      mut as list of int64: worker_task = [0, 0, 0]

      #L Atribuicao sucessiva por caminhos aumentantes mais curtos (Shortest Augmenting Path)
      mut as int64: w_idx = 1
      infinite (w_idx <= n) {
            #L Busca em arvore alternante de menor custo reduzido a partir do trabalhador
            mut as list of int64: min_slack = [999999, 999999, 999999]
            mut as list of int64: from_task = [0, 0, 0]
            mut as list of bool: task_visited = [false, false, false]
            mut as list of bool: worker_visited = [false, false, false]

            mut as int64: curr_worker = w_idx
            mut as int64: unassigned_task = 0

            infinite (unassigned_task == 0) {
                  worker_visited[curr_worker] = true

                  #L Atualiza folgas para tarefas nao visitadas
                  mut as int64: j = 1
                  infinite (j <= n) {
                        route {
                              not task_visited[j] ==> {
                                    mut as int64: red_c = cost[(curr_worker - 1) * n + j] - u_pot[curr_worker] - v_pot[j]
                                    route {
                                          red_c < min_slack[j] ==> {
                                                min_slack[j] = red_c
                                                from_task[j] = curr_worker
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }

                  #L Encontra a tarefa com menor folga
                  mut as int64: best_task = 0
                  mut as int64: delta = 999999
                  j = 1
                  infinite (j <= n) {
                        route {
                              (not task_visited[j]) and (min_slack[j] < delta) ==> {
                                    delta = min_slack[j]
                                    best_task = j
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }

                  #L Atualiza potenciais com delta
                  mut as int64: k = 1
                  infinite (k <= n) {
                        route {
                              worker_visited[k] ==> {
                                    u_pot[k] = u_pot[k] + delta
                              }
                              _ ==> {}
                        }
                        route {
                              task_visited[k] ==> {
                                    v_pot[k] = v_pot[k] - delta
                              }
                              _ ==> {
                                    min_slack[k] = min_slack[k] - delta
                              }
                        }
                        k = k + 1
                  }

                  task_visited[best_task] = true

                  route {
                        task_owner[best_task] == 0 ==> {
                              unassigned_task = best_task
                        }
                        _ ==> {
                              curr_worker = task_owner[best_task]
                        }
                  }
            }

            #L Augmenta o caminho da tarefa livre ate o trabalhador inicial
            mut as int64: cur_t = unassigned_task
            infinite (cur_t != 0) {
                  mut as int64: prev_w = from_task[cur_t]
                  mut as int64: next_t = worker_task[prev_w]

                  task_owner[cur_t] = prev_w
                  worker_task[prev_w] = cur_t

                  cur_t = next_t
            }

            w_idx = w_idx + 1
      }

      mut as int64: total_cost = 0
      println("2. Designacao Otima de Custo Minimo:")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: assigned_t = worker_task[i]
            mut as int64: cst = cost[(i - 1) * n + assigned_t]
            total_cost = total_cost + cst
            println("   Trabalhador " + i + " -> Tarefa " + assigned_t + " (custo " + cst + ")")
            i = i + 1
      }

      println("3. Custo Minimo Total da Atribuicao: " + total_cost)
      println("Assignment Algorithm concluido com sucesso.")
}
