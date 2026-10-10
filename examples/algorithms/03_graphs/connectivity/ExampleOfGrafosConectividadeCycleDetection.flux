#L ============================================================================
#L Algoritmo: Cycle Detection (Deteccao de Ciclos em Grafos Direcionados)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeCycleDetection) {
      println("==================================================")
      println("  SciAlgo: Cycle Detection (3-Color DFS)          ")
      println("==================================================")

      mut as int64: num_v = 4

      #L Grafo contendo um ciclo: 1->2, 2->3, 3->4, 4->2 (ciclo 2-3-4-2)
      mut as list of int64: adj = [
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
            0, 1, 0, 0
      ]

      println("1. Grafo com 4 Vertices:")
      println("   Arestas: 1->2, 2->3, 3->4, 4->2")

      #L Cores: 0 = Branco (nao visitado), 1 = Cinza (em processamento), 2 = Preto (finalizado)
      mut as list of int64: color = [0, 0, 0, 0]
      mut as list of int64: parent = [0, 0, 0, 0]

      mut as bool: cycle_found = false
      mut as int64: cycle_start = 0
      mut as int64: cycle_end = 0

      #L Pilha DFS
      mut as list of int64: cs = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: ce = [1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 0

      mut as int64: start_v = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: i = 1

      infinite (start_v <= num_v and not cycle_found) {
            route {
                  color[start_v] == 0 ==> {
                        cs_top = 1
                        cs[cs_top] = start_v
                        ce[cs_top] = 1
                        color[start_v] = 1 #L Cinza

                        infinite (cs_top > 0 and not cycle_found) {
                              u = cs[cs_top]
                              mut as int64: edge_k = ce[cs_top]
                              mut as bool: advanced = false

                              infinite (edge_k <= num_v and not advanced and not cycle_found) {
                                    route {
                                          adj[(u - 1) * num_v + edge_k] == 1 ==> {
                                                v = edge_k
                                                route {
                                                      color[v] == 1 ==> {
                                                            #L Aresta de retorno (Back-edge): CICLO DETECTADO!
                                                            cycle_found = true
                                                            cycle_start = v
                                                            cycle_end = u
                                                      }
                                                      color[v] == 0 ==> {
                                                            parent[v] = u
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
                                    not advanced and not cycle_found ==> {
                                          color[u] = 2 #L Preto
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
            cycle_found ==> {
                  println("2. Status: CICLO DETECTADO no grafo!")
                  println("   Aresta de fechamento: " + cycle_end + " -> " + cycle_start)
                  println("   Vertices do ciclo: " + cycle_start + " -> " + parent[cycle_end] + " -> " + cycle_end + " -> " + cycle_start)
            }
            _ ==> {
                  println("2. Status: Nenhum ciclo detectado (Grafo e Aciclico).")
            }
      }

      println("Cycle Detection concluido com sucesso.")
}
