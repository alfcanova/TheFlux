#L ============================================================================
#L Algoritmo: Dijkstra's Banker's Algorithm (Deadlock Avoidance)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N^2 * M) verificacao de estado seguro (Safety Algorithm)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisBankersAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Banker's Algorithm (Deadlock Avoidance)")
      println("==================================================")

      #L O Algoritmo do Banqueiro (Dijkstra 1965) evita impasses (deadlocks)
      #L em sistemas com multiplos tipos de recursos.
      #L Testa preventivamente se a concessao de um recurso mantem o sistema
      #L em um Estado Seguro (Safe State) atraves de uma sequencia de execucao segura.

      mut as int64: num_procs = 3 #L P1, P2, P3
      mut as int64: num_res = 3   #L R1, R2, R3

      #L Recursos Disponíveis no momento: Available = [3, 3, 2]
      mut as list of int64: avail = [3, 3, 2]

      #L Matriz Allocation (3 x 3 achatada):
      #L P1: [0, 1, 0] | P2: [2, 0, 0] | P3: [3, 0, 2]
      mut as list of int64: alloc = [0, 1, 0,  2, 0, 0,  3, 0, 2]

      #L Matriz Max (3 x 3 achatada):
      #L P1: [7, 5, 3] | P2: [3, 2, 2] | P3: [9, 0, 2]
      mut as list of int64: max_m = [7, 5, 3,  3, 2, 2,  9, 0, 2]

      #L Matriz Need = Max - Allocation (3 x 3 achatada):
      #L P1: [7, 2, 3] | P2: [1, 2, 2] | P3: [4, 0, 0]
      mut as list of int64: need = [7, 2, 3,  1, 2, 2,  4, 0, 0]

      mut as list of int64: finish = [0, 0, 0]
      mut as list of int64: safe_seq = [0, 0, 0]

      println("1. Estado Inicial do Sistema:")
      println("   Vetor Available: [" + avail[1] + ", " + avail[2] + ", " + avail[3] + "]")
      mut as int64: p = 1
      infinite (p <= num_procs) {
            mut as int64: base = (p - 1) * 3
            println("   P" + p + ": Alloc=[" + alloc[base + 1] + "," + alloc[base + 2] + "," + alloc[base + 3] + "] | Need=[" + need[base + 1] + "," + need[base + 2] + "," + need[base + 3] + "]")
            p = p + 1
      }

      println("==================================================")
      println("2. [Execucao do Algoritmo de Seguranca (Safety)]: ")

      mut as int64: count_done = 0
      mut as int64: step = 1

      infinite (step <= num_procs) {
            mut as int64: found_candidate = 0

            mut as int64: i = 1
            infinite (i <= num_procs) {
                  route {
                        finish[i] == 0 ==> {
                              #L Verifica se Need[i] <= Available para todos os recursos
                              mut as int64: b = (i - 1) * 3
                              mut as int64: can_allocate = 1
                              route {
                                    need[b + 1] > avail[1] ==> { can_allocate = 0 }
                                    need[b + 2] > avail[2] ==> { can_allocate = 0 }
                                    need[b + 3] > avail[3] ==> { can_allocate = 0 }
                                    _ ==> {}
                              }

                              route {
                                    can_allocate == 1 ==> {
                                          route {
                                                found_candidate == 0 ==> {
                                                      found_candidate = i
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
                  found_candidate > 0 ==> {
                        mut as int64: cand = found_candidate
                        mut as int64: cb = (cand - 1) * 3
                        #L Simula conclusao: devolve alocacao ao Available
                        avail[1] = avail[1] + alloc[cb + 1]
                        avail[2] = avail[2] + alloc[cb + 2]
                        avail[3] = avail[3] + alloc[cb + 3]
                        finish[cand] = 1
                        count_done = count_done + 1
                        safe_seq[count_done] = cand

                        println("   [Passo " + count_done + "] Processo P" + cand + " pode concluir!")
                        println("      Liberando recursos -> Novo Available: [" + avail[1] + ", " + avail[2] + ", " + avail[3] + "]")
                  }
                  _ ==> {}
            }
            step = step + 1
      }

      println("==================================================")
      println("3. Conclusao da Seguranca do Sistema:")
      route {
            count_done == num_procs ==> {
                  println("   SISTEMA EM ESTADO SEGURO (SAFE STATE)!")
                  println("   Sequencia Segura Encontrada: < P" + safe_seq[1] + ", P" + safe_seq[2] + ", P" + safe_seq[3] + " >")
                  println("   Garantia Matematica contra Deadlock comprovada.")
            }
            _ ==> {
                  println("   SISTEMA EM ESTADO INSEGURO (DEADLOCK POTENCIAL)!")
            }
      }
      println("==================================================")
}
