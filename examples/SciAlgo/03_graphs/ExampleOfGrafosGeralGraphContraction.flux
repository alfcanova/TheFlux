#L ============================================================================
#L Algoritmo: Graph Contraction (Contracao de Arestas e Super-Vertices)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V + E) por contracao | O(V^2) multigrafo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralGraphContraction) {
      println("==================================================")
      println("  SciAlgo: Graph Contraction (Contracao de Grafos)")
      println("==================================================")

      #L Grafo com V = 5 vertices e E = 7 arestas:
      #L Arestas: (1-2), (1-3), (2-3), (2-4), (3-4), (4-5), (3-5)
      mut as int64: num_v = 5
      mut as int64: num_e = 7

      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 4, 3]
      mut as list of int64: edge_v = [2, 3, 3, 4, 4, 5, 5]

      println("1. Grafo inicial com " + num_v + " vertices e " + num_e + " arestas:")
      println("   Arestas: [(1-2), (1-3), (2-3), (2-4), (3-4), (4-5), (3-5)]")

      #L Matriz de multiplicidade de arestas (5x5 = 25)
      mut as list of int64: mult = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            mult = listPushBack(mult, 0)
            c = c + 1
      }

      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            mult[(u - 1) * num_v + v] = mult[(u - 1) * num_v + v] + 1
            mult[(v - 1) * num_v + u] = mult[(v - 1) * num_v + u] + 1
            ei = ei + 1
      }

      #L Vetor de mapeamento de super-vertices (qual vertice representa cada nó)
      mut as list of int64: rep = [1, 2, 3, 4, 5]
      mut as list of bool: active = [true, true, true, true, true]
      mut as int64: active_v_count = num_v

      #L FASE 1: Contracao da aresta (2, 3) -> mescla 3 em 2
      println("2. Fase 1: Contraindo aresta (2, 3) -> vertice 3 incorporado em 2...")
      mut as int64: u1 = 2
      mut as int64: v1 = 3

      #L Transfere todas as conexoes de v1 para u1
      mut as int64: k = 1
      infinite (k <= num_v) {
            route {
                  k != u1 and k != v1 ==> {
                        mut as int64: edges_with_v = mult[(v1 - 1) * num_v + k]
                        route {
                              edges_with_v > 0 ==> {
                                    mult[(u1 - 1) * num_v + k] = mult[(u1 - 1) * num_v + k] + edges_with_v
                                    mult[(k - 1) * num_v + u1] = mult[(k - 1) * num_v + u1] + edges_with_v
                                    mult[(v1 - 1) * num_v + k] = 0
                                    mult[(k - 1) * num_v + v1] = 0
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            k = k + 1
      }

      #L Elimina auto-lacos (2, 3)
      mult[(u1 - 1) * num_v + v1] = 0
      mult[(v1 - 1) * num_v + u1] = 0
      active[v1] = false
      active_v_count = active_v_count - 1

      println("   Apos Contracao 1: vertices ativos = " + active_v_count + " ({1, 2, 4, 5})")
      println("   Multiplicidade da aresta (1, 2): " + mult[(1 - 1) * num_v + 2] + " (fundiu 1-2 e 1-3)")
      println("   Multiplicidade da aresta (2, 4): " + mult[(2 - 1) * num_v + 4] + " (fundiu 2-4 e 3-4)")

      #L FASE 2: Contracao da aresta (4, 5) -> mescla 5 em 4
      println("3. Fase 2: Contraindo aresta (4, 5) -> vertice 5 incorporado em 4...")
      mut as int64: u2 = 4
      mut as int64: v2 = 5

      mut as int64: m = 1
      infinite (m <= num_v) {
            route {
                  m != u2 and m != v2 ==> {
                        mut as int64: edges_with_v2 = mult[(v2 - 1) * num_v + m]
                        route {
                              edges_with_v2 > 0 ==> {
                                    mult[(u2 - 1) * num_v + m] = mult[(u2 - 1) * num_v + m] + edges_with_v2
                                    mult[(m - 1) * num_v + u2] = mult[(m - 1) * num_v + u2] + edges_with_v2
                                    mult[(v2 - 1) * num_v + m] = 0
                                    mult[(m - 1) * num_v + v2] = 0
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            m = m + 1
      }

      mult[(u2 - 1) * num_v + v2] = 0
      mult[(v2 - 1) * num_v + u2] = 0
      active[v2] = false
      active_v_count = active_v_count - 1

      println("   Apos Contracao 2: vertices ativos = " + active_v_count + " ({1, 2, 4})")
      println("   Multiplicidade da aresta (2, 4): " + mult[(2 - 1) * num_v + 4] + " (somou aresta 2-5 derivada)")

      #L FASE 3: Contracao de (1, 2) -> restam apenas 2 super-vertices: {1, 2, 3} e {4, 5}
      println("4. Fase 3: Contraindo aresta (1, 2) -> super-vertices finais {1} e {4}...")
      mut as int64: u3 = 1
      mut as int64: v3 = 2

      mut as int64: p = 1
      infinite (p <= num_v) {
            route {
                  p != u3 and p != v3 ==> {
                        mut as int64: edges_with_v3 = mult[(v3 - 1) * num_v + p]
                        route {
                              edges_with_v3 > 0 ==> {
                                    mult[(u3 - 1) * num_v + p] = mult[(u3 - 1) * num_v + p] + edges_with_v3
                                    mult[(p - 1) * num_v + u3] = mult[(p - 1) * num_v + u3] + edges_with_v3
                                    mult[(v3 - 1) * num_v + p] = 0
                                    mult[(p - 1) * num_v + v3] = 0
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            p = p + 1
      }

      mult[(u3 - 1) * num_v + v3] = 0
      mult[(v3 - 1) * num_v + u3] = 0
      active[v3] = false
      active_v_count = active_v_count - 1

      println("   Super-vertices finais ativos = " + active_v_count)
      mut as int64: final_cut_edges = mult[(1 - 1) * num_v + 4]
      println("   Multiplicidade de arestas entre os 2 super-vertices restantes: " + final_cut_edges)

      #L Verificacao:
      #L Apos contrair {1,2,3} em 1 e {4,5} em 4, as arestas originais entre os dois blocos eram:
      #L (2-4), (3-4), (3-5) -> exatamente 3 arestas!
      mut as bool: v_count_ok = active_v_count == 2
      mut as bool: cut_edges_ok = final_cut_edges == 3
      mut as bool: contraction_ok = v_count_ok and cut_edges_ok
      println("5. Verificacao da Contracao de Grafos: " + contraction_ok)

      println("Concluido com Sucesso")
}
