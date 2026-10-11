#L ============================================================================
#L Algoritmo: Decremental Algorithm (Algoritmo Decremental)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(V + E) por delecao | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasDecrementalAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Decremental Algorithm (Conectividade)")
      println("==================================================")

      #L Grafo com 5 vertices e 6 arestas
      #L Arestas: 1:(1,2), 2:(2,3), 3:(3,4), 4:(4,5), 5:(2,4), 6:(1,5)
      mut as list of int64: eu = [1, 2, 3, 4, 2, 1]
      mut as list of int64: ev = [2, 3, 4, 5, 4, 5]
      mut as list of int64: active_e = [1, 1, 1, 1, 1, 1]
      mut as int64: n_v = 5
      mut as int64: n_e = listLength(eu)

      println("1. Grafo inicial com " + n_v + " vertices e " + n_e + " arestas ativas")

      #L Ordem de delecoes decrementais sucessivas: remove aresta 6, depois 5, depois 3, depois 1
      mut as list of int64: deletions = [6, 5, 3, 1]
      mut as int64: num_del = listLength(deletions)

      mut as int64: step = 1
      infinite (step <= num_del) {
            mut as int64: del_idx = deletions[step]
            active_e[del_idx] = 0
            println("2. Delecao " + step + ": desativando aresta (" + eu[del_idx] + ", " + ev[del_idx] + ")")

            #L Conta componentes conexas via BFS/visitas com arestas ativas
            mut as list of int64: visited = [0, 0, 0, 0, 0]
            mut as int64: comp_count = 0
            mut as int64: vi = 1

            infinite (vi <= n_v) {
                  route {
                        visited[vi] == 0 ==> {
                              comp_count = comp_count + 1
                              #L BFS a partir de vi
                              mut as list of int64: queue = [vi]
                              visited[vi] = 1

                              infinite (listLength(queue) > 0) {
                                    mut as int64: curr = queue[1]
                                    #L Remove frente da fila
                                    mut as list of int64: nq = []
                                    mut as int64: qk = 2
                                    mut as int64: qlen = listLength(queue)
                                    infinite (qk <= qlen) {
                                          nq = listPushBack(nq, queue[qk])
                                          qk = qk + 1
                                    }
                                    queue = nq

                                    #L Explora arestas incidentes ativas
                                    mut as int64: ei = 1
                                    infinite (ei <= n_e) {
                                          route {
                                                active_e[ei] == 1 ==> {
                                                      mut as int64: u = eu[ei]
                                                      mut as int64: v = ev[ei]
                                                      mut as int64: neighbor = 0
                                                      route {
                                                            u == curr ==> {
                                                                  neighbor = v
                                                            }
                                                            v == curr ==> {
                                                                  neighbor = u
                                                            }
                                                            _ ==> {
                                                            }
                                                      }

                                                      route {
                                                            neighbor > 0 ==> {
                                                                  route {
                                                                        visited[neighbor] == 0 ==> {
                                                                              visited[neighbor] = 1
                                                                              queue = listPushBack(queue, neighbor)
                                                                        }
                                                                        _ ==> {
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                }
                                          }
                                          ei = ei + 1
                                    }
                              }
                        }
                        _ ==> {
                        }
                  }
                  vi = vi + 1
            }

            println("   -> Componentes conexas restantes: " + comp_count)
            step = step + 1
      }

      println("3. Processamento decremental finalizado com sucesso")
      println("Concluido com Sucesso")
}
