#L ============================================================================
#L Algoritmo: Topological Sort (Ordenacao Topologica via DFS / Pos-Ordem Reversa)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTopologicalSort) {
      println("==================================================")
      println("  SciAlgo: Topological Sort (DFS Post-Order)      ")
      println("==================================================")

      mut as int64: num_v = 6

      #L DAG com 6 vertices:
      #L 1->2, 1->3, 2->4, 3->4, 4->5, 5->6
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            0, 0, 0, 1, 0, 0,
            0, 0, 0, 1, 0, 0,
            0, 0, 0, 0, 1, 0,
            0, 0, 0, 0, 0, 1,
            0, 0, 0, 0, 0, 0
      ]

      println("1. Grafo Aciclico Direcionado (DAG) com 6 Vertices")

      #L Estado das cores: 0: Branco (nao visitado), 1: Cinza (na pilha), 2: Preto (finalizado)
      mut as list of int64: color = [0, 0, 0, 0, 0, 0]
      mut as list of int64: topo_list = [0, 0, 0, 0, 0, 0]
      mut as int64: topo_count = 0
      mut as bool: has_cycle = false

      #L Pilha para DFS iterativo
      mut as list of int64: cs = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: ce = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 0

      mut as int64: start_v = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: i = 1

      infinite (start_v <= num_v and not has_cycle) {
            route {
                  color[start_v] == 0 ==> {
                        cs_top = 1
                        cs[cs_top] = start_v
                        ce[cs_top] = 1
                        color[start_v] = 1 #L Cinza

                        infinite (cs_top > 0 and not has_cycle) {
                              u = cs[cs_top]
                              mut as int64: edge_k = ce[cs_top]
                              mut as bool: advanced = false

                              infinite (edge_k <= num_v and not advanced and not has_cycle) {
                                    route {
                                          adj[(u - 1) * num_v + edge_k] == 1 ==> {
                                                v = edge_k
                                                route {
                                                      color[v] == 1 ==> {
                                                            #L Ciclo detectado (aresta de retorno para no cinza)
                                                            has_cycle = true
                                                      }
                                                      color[v] == 0 ==> {
                                                            ce[cs_top] = edge_k + 1
                                                            cs_top = cs_top + 1
                                                            cs[cs_top] = v
                                                            ce[cs_top] = 1
                                                            color[v] = 1
                                                            advanced = true
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    edge_k = edge_k + 1
                              }

                              route {
                                    not advanced and not has_cycle ==> {
                                          color[u] = 2 #L Preto (finalizado)
                                          topo_count = topo_count + 1
                                          topo_list[topo_count] = u
                                          cs_top = cs_top - 1
                                    }
                                    _ ==> {}
                              }
                        }
                  }
                  _ ==> {}
            }
            start_v = start_v + 1
      }

      route {
            has_cycle ==> {
                  println("2. Erro: O grafo contem ciclo, ordenacao topologica impossivel!")
            }
            _ ==> {
                  println("2. Ordenacao Topologica Obtida (Reverso da Finalizacao):")
                  #L A ordem topologica valida e o reverso da lista de finalizacao
                  i = topo_count
                  infinite (i >= 1) {
                        println("   -> Vertice " + topo_list[i])
                        i = i - 1
                  }
            }
      }

      println("Topological Sort concluido com sucesso.")
}
