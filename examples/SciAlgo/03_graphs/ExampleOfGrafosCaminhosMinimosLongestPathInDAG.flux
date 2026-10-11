#L ============================================================================
#L Algoritmo: Longest Path in DAG (Caminho Mais Longo em Grafo Aciclico)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosLongestPathInDAG) {
      println("==================================================")
      println("  SciAlgo: Longest Path in DAG (Topological Order)")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: src = 1

      #L Matriz de pesos do DAG (6x6). -1 indica sem aresta
      #L 1->2 (3), 1->3 (2)
      #L 2->4 (4), 2->5 (1)
      #L 3->4 (2), 3->5 (6)
      #L 4->6 (1)
      #L 5->6 (2)
      mut as list of int64: weight = [
            -1,  3,  2, -1, -1, -1,
            -1, -1, -1,  4,  1, -1,
            -1, -1, -1,  2,  6, -1,
            -1, -1, -1, -1, -1,  1,
            -1, -1, -1, -1, -1,  2,
            -1, -1, -1, -1, -1, -1
      ]

      println("1. Grafo Aciclico Direcionado (DAG) com 6 Vertices. Origem: " + src)

      #L ETAPA 1: Grau de entrada (in-degree) para Ordenacao Topologica de Kahn
      mut as list of int64: in_degree = [0, 0, 0, 0, 0, 0]
      mut as int64: u = 1
      mut as int64: v = 1
      infinite (u <= num_v) {
            v = 1
            infinite (v <= num_v) {
                  route {
                        weight[(u - 1) * num_v + v] >= 0 ==> {
                              in_degree[v] = in_degree[v] + 1
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
            u = u + 1
      }

      #L Fila para ordenacao topologica
      mut as list of int64: q = [0, 0, 0, 0, 0, 0]
      mut as int64: q_head = 1
      mut as int64: q_tail = 1

      mut as int64: i = 1
      infinite (i <= num_v) {
            route {
                  in_degree[i] == 0 ==> {
                        q[q_tail] = i
                        q_tail = q_tail + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      mut as list of int64: topo_order = [0, 0, 0, 0, 0, 0]
      mut as int64: topo_len = 0

      infinite (q_head < q_tail) {
            mut as int64: curr = q[q_head]
            q_head = q_head + 1

            topo_len = topo_len + 1
            topo_order[topo_len] = curr

            v = 1
            infinite (v <= num_v) {
                  route {
                        weight[(curr - 1) * num_v + v] >= 0 ==> {
                              in_degree[v] = in_degree[v] - 1
                              route {
                                    in_degree[v] == 0 ==> {
                                          q[q_tail] = v
                                          q_tail = q_tail + 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      println("2. Ordem Topologica Obtida: [" + topo_order[1] + ", " + topo_order[2] + ", " + topo_order[3] + ", " + topo_order[4] + ", " + topo_order[5] + ", " + topo_order[6] + "]")

      #L ETAPA 2: Relaxamento para o Caminho Mais Longo na Ordem Topologica
      mut as list of int64: dist = [-999999, -999999, -999999, -999999, -999999, -999999]
      mut as list of int64: parent = [0, 0, 0, 0, 0, 0]
      dist[src] = 0

      mut as int64: idx = 1
      infinite (idx <= topo_len) {
            u = topo_order[idx]
            route {
                  dist[u] > -999999 ==> {
                        v = 1
                        infinite (v <= num_v) {
                              mut as int64: w = weight[(u - 1) * num_v + v]
                              route {
                                    w >= 0 ==> {
                                          route {
                                                dist[u] + w > dist[v] ==> {
                                                      dist[v] = dist[u] + w
                                                      parent[v] = u
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }
                  }
                  _ ==> {}
            }
            idx = idx + 1
      }

      println("3. Distancias do Caminho Mais Longo a partir de " + src + ":")
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + ": distancia maxima = " + dist[i])
            i = i + 1
      }

      #L Reconstroi o caminho mais longo ate o vertice 6
      mut as list of int64: path = [0, 0, 0, 0, 0, 0]
      mut as int64: p_len = 0
      mut as int64: cp = 6
      infinite (cp != 0) {
            p_len = p_len + 1
            path[p_len] = cp
            cp = parent[cp]
      }

      println("4. Caminho Mais Longo ate o Vertice 6 (Comprimento " + dist[6] + "):")
      i = p_len
      infinite (i >= 1) {
            println("   -> No " + path[i])
            i = i - 1
      }

      println("Longest Path in DAG concluido com sucesso.")
}
