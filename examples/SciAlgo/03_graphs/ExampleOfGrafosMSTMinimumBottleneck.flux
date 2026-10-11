#L ============================================================================
#L Algoritmo: Minimum Bottleneck Spanning Tree (MBST - Gargalo Minimo)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(E) linear (Camerini 1978) / O(E log E) com ordenacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTMinimumBottleneck) {
      println("==================================================")
      println("  SciAlgo: Minimum Bottleneck Spanning Tree (MBST)")
      println("==================================================")

      #L O problema MBST busca uma arvore geradora T que minimiza
      #L o peso da sua aresta mais pesada: min_T max_{e in T} w(e).
      #L Teorema Fundamental: Toda MST e uma MBST (o gargalo da MST eh otimo).

      mut as int64: num_v = 6
      mut as int64: num_e = 9

      #L Arestas do grafo (ordenadas por peso):
      mut as list of int64: edge_u = [2, 1, 4, 5, 1, 2, 4, 3, 3]
      mut as list of int64: edge_v = [3, 3, 5, 6, 2, 4, 6, 4, 5]
      mut as list of int64: edge_w = [1, 2, 2, 3, 4, 5, 6, 8, 10]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas:")
      println("   Pesos ordenados: " + edge_w)

      #L ETAPA 1: Busca do Gargalo Minimo (Threshold B*)
      #L Um valor B e um gargalo valido se o subgrafo contendo apenas arestas
      #L com peso <= B for conexo (1 componente).
      println("2. Testando limiares de gargalo B...")

      mut as int64: optimal_bottleneck = 0
      mut as int64: test_idx = 1
      mut as bool: found_bottleneck = false

      infinite (test_idx <= num_e and not found_bottleneck) {
            mut as int64: b_cand = edge_w[test_idx]

            #L DSU para testar conectividade com arestas <= b_cand
            mut as list of int64: parent = [1, 2, 3, 4, 5, 6]
            mut as int64: components = num_v

            mut as int64: k = 1
            infinite (k <= num_e) {
                  route {
                        edge_w[k] <= b_cand ==> {
                              mut as int64: u = edge_u[k]
                              mut as int64: v = edge_v[k]

                              mut as int64: ru = u
                              infinite (parent[ru] != ru) {
                                    ru = parent[ru]
                              }

                              mut as int64: rv = v
                              infinite (parent[rv] != rv) {
                                    rv = parent[rv]
                              }

                              route {
                                    ru != rv ==> {
                                          parent[ru] = rv
                                          components = components - 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            println("   Limiar B = " + b_cand + ": componentes conexas restantes = " + components)

            route {
                  components == 1 ==> {
                        optimal_bottleneck = b_cand
                        found_bottleneck = true
                  }
                  _ ==> {}
            }

            test_idx = test_idx + 1
      }

      println("3. Gargalo Minimo Otimo B* encontrado: " + optimal_bottleneck)

      #L ETAPA 2: Construcao da MBST com arestas restritas a peso <= B*
      mut as list of int64: mbst_parent = [1, 2, 3, 4, 5, 6]
      mut as list of int64: mbst_edges_u = []
      mut as list of int64: mbst_edges_v = []
      mut as list of int64: mbst_weights = []
      mut as int64: mbst_max_weight = 0
      mut as int64: mbst_total_weight = 0

      mut as int64: m = 1
      infinite (m <= num_e and listLength(mbst_edges_u) < (num_v - 1)) {
            route {
                  edge_w[m] <= optimal_bottleneck ==> {
                        mut as int64: mu = edge_u[m]
                        mut as int64: mv = edge_v[m]
                        mut as int64: mw = edge_w[m]

                        mut as int64: r1 = mu
                        infinite (mbst_parent[r1] != r1) {
                              r1 = mbst_parent[r1]
                        }

                        mut as int64: r2 = mv
                        infinite (mbst_parent[r2] != r2) {
                              r2 = mbst_parent[r2]
                        }

                        route {
                              r1 != r2 ==> {
                                    mbst_parent[r1] = r2
                                    mbst_edges_u = listPushBack(mbst_edges_u, mu)
                                    mbst_edges_v = listPushBack(mbst_edges_v, mv)
                                    mbst_weights = listPushBack(mbst_weights, mw)
                                    mbst_total_weight = mbst_total_weight + mw
                                    route {
                                          mw > mbst_max_weight ==> {
                                                mbst_max_weight = mw
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            m = m + 1
      }

      println("4. Arvore Geradora de Gargalo Minimo (MBST) construida:")
      println("   Extremos U: " + mbst_edges_u)
      println("   Extremos V: " + mbst_edges_v)
      println("   Pesos: " + mbst_weights)
      println("   Aresta de Gargalo na MBST: " + mbst_max_weight)
      println("   Peso Total da MBST: " + mbst_total_weight)

      #L Verificacao do Teorema MBST vs MST:
      #L Gargalo otimo deve ser 5 (a aresta 2-4 conecta os dois blocos).
      mut as bool: count_ok = listLength(mbst_edges_u) == (num_v - 1)
      mut as bool: bottleneck_ok = (mbst_max_weight == optimal_bottleneck) and (optimal_bottleneck == 5)
      mut as bool: mbst_verified = count_ok and bottleneck_ok
      println("5. Verificacao da MBST: " + mbst_verified)

      println("Concluido com Sucesso")
}
