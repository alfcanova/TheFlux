#L ============================================================================
#L Algoritmo: Transitive Reduction (Reducao Transitiva de DAGs - Aho et al. 1972)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V^3) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralTransitiveReduction) {
      println("==================================================")
      println("  SciAlgo: Transitive Reduction (Reducao Transitiva)")
      println("==================================================")

      #L Grafo aciclico direcionado (DAG) com V = 5 vertices e E = 7 arestas
      #L Arestas originais:
      #L (1->2), (2->3), (1->3), (3->4), (2->4), (4->5), (1->5)
      #L Arestas redundantes transitivas:
      #L (1->3) eh redundante por 1->2->3
      #L (2->4) eh redundante por 2->3->4
      #L (1->5) eh redundante por 1->2->3->4->5
      #L Reducao transitiva resultante: (1->2), (2->3), (3->4), (4->5) (4 arestas)

      mut as int64: num_v = 5
      mut as int64: num_e = 7

      mut as list of int64: edge_u = [1, 2, 1, 3, 2, 4, 1]
      mut as list of int64: edge_v = [2, 3, 3, 4, 4, 5, 5]

      println("1. Grafo direcionado de entrada (DAG):")
      println("   Vertices: " + num_v + ", Arestas: " + num_e)
      println("   Arestas: [(1->2), (2->3), (1->3), (3->4), (2->4), (4->5), (1->5)]")

      #L Matriz de adjacencia original (5x5 = 25)
      mut as list of int64: adj = []
      mut as list of int64: reach = [] #L fecho transitivo
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, 0)
            reach = listPushBack(reach, 0)
            c = c + 1
      }

      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            adj[(u - 1) * num_v + v] = 1
            reach[(u - 1) * num_v + v] = 1
            ei = ei + 1
      }

      #L ETAPA 1: Fecho Transitivo usando Algoritmo de Warshall
      mut as int64: k = 1
      infinite (k <= num_v) {
            mut as int64: i = 1
            infinite (i <= num_v) {
                  mut as int64: j = 1
                  infinite (j <= num_v) {
                        route {
                              reach[(i - 1) * num_v + j] == 0 ==> {
                                    route {
                                          reach[(i - 1) * num_v + k] == 1 and reach[(k - 1) * num_v + j] == 1 ==> {
                                                reach[(i - 1) * num_v + j] = 1
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }
                  i = i + 1
            }
            k = k + 1
      }

      println("2. Fecho transitivo calculado com sucesso.")

      #L ETAPA 2: Reducao Transitiva
      #L Uma aresta direta (u -> v) pertence a reducao transitiva se e somente se
      #L NAO existe nenhum vertice intermediario w (w != u e w != v) tal que:
      #L reach(u -> w) == 1 e reach(w -> v) == 1.
      mut as list of int64: red_edges_u = []
      mut as list of int64: red_edges_v = []
      mut as int64: redundant_count = 0

      mut as int64: ej = 1
      infinite (ej <= num_e) {
            mut as int64: u_cand = edge_u[ej]
            mut as int64: v_cand = edge_v[ej]
            mut as bool: is_redundant = false

            mut as int64: mid = 1
            infinite (mid <= num_v and not is_redundant) {
                  route {
                        mid != u_cand and mid != v_cand ==> {
                              mut as int64: r_u_mid = reach[(u_cand - 1) * num_v + mid]
                              mut as int64: r_mid_v = reach[(mid - 1) * num_v + v_cand]
                              route {
                                    r_u_mid == 1 and r_mid_v == 1 ==> {
                                          is_redundant = true
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  mid = mid + 1
            }

            route {
                  is_redundant ==> {
                        redundant_count = redundant_count + 1
                        println("   Aresta (" + u_cand + " -> " + v_cand + ") identificada como redundante (eliminada).")
                  }
                  _ ==> {
                        red_edges_u = listPushBack(red_edges_u, u_cand)
                        red_edges_v = listPushBack(red_edges_v, v_cand)
                  }
            }

            ej = ej + 1
      }

      println("3. Grafo Reduzido (Transitive Reduction):")
      println("   Arestas restantes: " + listLength(red_edges_u) + " (de " + num_e + " originais)")
      println("   Origens U : " + red_edges_u)
      println("   Destinos V: " + red_edges_v)

      #L Verificacao:
      #L As 4 arestas essenciais devem ser (1->2), (2->3), (3->4), (4->5)
      #L Arestas redundantes eliminadas = 3
      mut as bool: count_ok = listLength(red_edges_u) == 4
      mut as bool: red_ok = redundant_count == 3
      mut as bool: tr_ok = count_ok and red_ok
      println("4. Verificacao da Reducao Transitiva: " + tr_ok)

      println("Concluido com Sucesso")
}
