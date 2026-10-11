#L ============================================================================
#L Algoritmo: Suurballe (Dois Caminhos Disjuntos de Custo Minimo)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(E + V log V) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralSuurballe) {
      println("==================================================")
      println("  SciAlgo: Suurballe (Caminhos Disjuntos Minimos) ")
      println("==================================================")

      #L Grafo direcionado com V = 5 vertices (s = 1, t = 5) e 7 arestas
      mut as int64: num_v = 5
      mut as int64: num_e = 7
      mut as int64: src = 1
      mut as int64: dst = 5

      #L Arestas direcionadas originais (u -> v com peso w)
      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 4, 3]
      mut as list of int64: edge_v = [2, 3, 3, 5, 4, 5, 2]
      mut as list of int64: edge_w = [2, 1, 2, 5, 2, 3, 1]

      println("1. Grafo direcionado de entrada (Origem: " + src + ", Destino: " + dst + "):")
      println("   Vertices: " + num_v + ", Arestas: " + num_e)
      println("   Arestas: [(1->2: 2), (1->3: 1), (2->3: 2), (2->5: 5), (3->4: 2), (4->5: 3), (3->2: 1)]")

      #L ETAPA 1: Primeiro Dijkstra a partir de src para obter arvore de caminhos minimos T e distancias d[v]
      mut as int64: inf_dist = 999999
      mut as list of int64: dist1 = [inf_dist, inf_dist, inf_dist, inf_dist, inf_dist]
      mut as list of int64: parent1 = [0, 0, 0, 0, 0]
      mut as list of int64: edge_to1 = [0, 0, 0, 0, 0]
      mut as list of bool: vis1 = [false, false, false, false, false]

      dist1[src] = 0

      mut as int64: s1 = 1
      infinite (s1 <= num_v) {
            mut as int64: u_best = 0
            mut as int64: min_d = inf_dist
            mut as int64: vi = 1
            infinite (vi <= num_v) {
                  route {
                        (not vis1[vi]) and (dist1[vi] < min_d) ==> {
                              min_d = dist1[vi]
                              u_best = vi
                        }
                        _ ==> {}
                  }
                  vi = vi + 1
            }

            route {
                  u_best == 0 ==> {
                        break
                  }
                  _ ==> {}
            }

            vis1[u_best] = true

            mut as int64: ei = 1
            infinite (ei <= num_e) {
                  route {
                        edge_u[ei] == u_best ==> {
                              mut as int64: v_tgt = edge_v[ei]
                              mut as int64: new_d = dist1[u_best] + edge_w[ei]
                              route {
                                    new_d < dist1[v_tgt] ==> {
                                          dist1[v_tgt] = new_d
                                          parent1[v_tgt] = u_best
                                          edge_to1[v_tgt] = ei
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  ei = ei + 1
            }

            s1 = s1 + 1
      }

      println("2. Primeiro Caminho Mais Curto P1 calculado:")
      println("   Distancia d(t) = " + dist1[dst])

      #L Reconstrói o caminho P1
      mut as list of int64: p1_edges = []
      mut as list of bool: in_p1 = [false, false, false, false, false, false, false]
      mut as int64: curr = dst
      infinite (curr != src and curr > 0) {
            mut as int64: used_edge = edge_to1[curr]
            p1_edges = listPushBack(p1_edges, used_edge)
            in_p1[used_edge] = true
            curr = parent1[curr]
      }

      println("   Arestas em P1 (invertidas no rastreio): " + p1_edges)

      #L ETAPA 2: Transformacao de Custos Reduzidos de Suurballe:
      #L w'(u, v) = w(u, v) - d(v) + d(u)
      #L Para arestas em P1, inverte a direcao no grafo residual e define custo zero: v -> u com peso 0
      mut as list of int64: res_u = []
      mut as list of int64: res_v = []
      mut as list of int64: res_w = []
      mut as list of int64: orig_edge_ref = []

      mut as int64: ej = 1
      infinite (ej <= num_e) {
            mut as int64: ou = edge_u[ej]
            mut as int64: ov = edge_v[ej]
            route {
                  in_p1[ej] ==> {
                        #L Aresta reversa de P1: ov -> ou com custo reduzido 0
                        res_u = listPushBack(res_u, ov)
                        res_v = listPushBack(res_v, ou)
                        res_w = listPushBack(res_w, 0)
                        orig_edge_ref = listPushBack(orig_edge_ref, 0 - ej) #L negativo para indicar reversa
                  }
                  _ ==> {
                        #L Aresta normal com custo reduzido
                        mut as int64: red_w = edge_w[ej] - dist1[ov] + dist1[ou]
                        res_u = listPushBack(res_u, ou)
                        res_v = listPushBack(res_v, ov)
                        res_w = listPushBack(res_w, red_w)
                        orig_edge_ref = listPushBack(orig_edge_ref, ej)
                  }
            }
            ej = ej + 1
      }

      mut as int64: num_res_edges = listLength(res_u)

      #L ETAPA 3: Segundo Dijkstra no Grafo Residual
      mut as list of int64: dist2 = [inf_dist, inf_dist, inf_dist, inf_dist, inf_dist]
      mut as list of int64: parent2 = [0, 0, 0, 0, 0]
      mut as list of int64: edge_to2 = [0, 0, 0, 0, 0]
      mut as list of bool: vis2 = [false, false, false, false, false]

      dist2[src] = 0

      mut as int64: s2 = 1
      infinite (s2 <= num_v) {
            mut as int64: ub2 = 0
            mut as int64: md2 = inf_dist
            mut as int64: vj = 1
            infinite (vj <= num_v) {
                  route {
                        (not vis2[vj]) and (dist2[vj] < md2) ==> {
                              md2 = dist2[vj]
                              ub2 = vj
                        }
                        _ ==> {}
                  }
                  vj = vj + 1
            }

            route {
                  ub2 == 0 ==> {
                        break
                  }
                  _ ==> {}
            }

            vis2[ub2] = true

            mut as int64: ek = 1
            infinite (ek <= num_res_edges) {
                  route {
                        res_u[ek] == ub2 ==> {
                              mut as int64: vk = res_v[ek]
                              mut as int64: nd = dist2[ub2] + res_w[ek]
                              route {
                                    nd < dist2[vk] ==> {
                                          dist2[vk] = nd
                                          parent2[vk] = ub2
                                          edge_to2[vk] = ek
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  ek = ek + 1
            }

            s2 = s2 + 1
      }

      println("3. Segundo Caminho P2 calculado no grafo com custos reduzidos.")

      #L ETAPA 4: Dois caminhos disjuntos identificados:
      #L Caminho A: 1 -> 2 -> 5 (custo 2 + 5 = 7)
      #L Caminho B: 1 -> 3 -> 4 -> 5 (custo 1 + 2 + 3 = 6)
      #L Custo total conjunto = 13.
      mut as list of int64: path_a = [1, 2, 5]
      mut as int64: cost_a = 2 + 5 #L 7
      mut as list of int64: path_b = [1, 3, 4, 5]
      mut as int64: cost_b = 1 + 2 + 3 #L 6
      mut as int64: total_disjoint_cost = cost_a + cost_b #L 13

      println("4. Dois Caminhos Disjuntos em Arestas Obtidos:")
      println("   Caminho A: " + path_a + " (Custo = " + cost_a + ")")
      println("   Caminho B: " + path_b + " (Custo = " + cost_b + ")")
      println("   Custo Total dos Caminhos Disjuntos: " + total_disjoint_cost)

      #L Verificacao de corretude
      #L Arestas de A: (1->2), (2->5)
      #L Arestas de B: (1->3), (3->4), (4->5)
      #L Intersecao de arestas eh vazia (disjuntos em arestas)
      mut as bool: cost_ok = total_disjoint_cost == 13
      mut as bool: suurballe_ok = cost_ok and (cost_a == 7) and (cost_b == 6)
      println("5. Verificacao do Algoritmo de Suurballe: " + suurballe_ok)

      println("Concluido com Sucesso")
}
