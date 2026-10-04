#L ============================================================================
#L Algoritmo: Yen's Algorithm (K Menores Caminhos Simples sem Ciclos)
#L Domínio: 03_graphs / Categoria: Caminhos Mínimos
#L Complexidade: O(K * V * (E + V log V))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

#L Dijkstra restrito com arestas e nós mascarados
function (dijkstraMasked) (
      as int64: num_v,
      as int64: src,
      as int64: dst,
      as list of int64: u,
      as list of int64: v,
      as list of int64: w,
      as list of bool: edge_disabled,
      as list of bool: node_disabled
) as list of data {
      mut as list of int64: dist = []
      mut as list of int64: prev = []
      mut as list of bool: visited = []
      
      mut as int64: i = 1
      infinite (i <= num_v) {
            dist = listPushBack(dist, 999999)
            prev = listPushBack(prev, 0)
            visited = listPushBack(visited, false)
            i = i + 1
      }
      
      dist[src] = 0
      
      infinite (true) {
            mut as int64: u_best = 0
            mut as int64: d_best = 999999
            
            i = 1
            infinite (i <= num_v) {
                  route {
                        not visited[i] and not node_disabled[i] and dist[i] < d_best ==> {
                              d_best = dist[i]
                              u_best = i
                        }
                  }
                  i = i + 1
            }
            
            route {
                  u_best == 0 or u_best == dst ==> {
                        break
                  }
            }
            
            visited[u_best] = true
            
            #L Relaxamento das arestas que saem de u_best
            mut as int64: e = 1
            mut as int64: num_edges = listLength(u)
            infinite (e <= num_edges) {
                  route {
                        not edge_disabled[e] and u[e] == u_best ==> {
                              mut as int64: v_dest = v[e]
                              mut as int64: weight = w[e]
                              route {
                                    not node_disabled[v_dest] ==> {
                                          mut as int64: new_dist = dist[u_best] + weight
                                          route {
                                                new_dist < dist[v_dest] ==> {
                                                      dist[v_dest] = new_dist
                                                      prev[v_dest] = u_best
                                                }
                                          }
                                    }
                              }
                        }
                  }
                  e = e + 1
            }
      }
      
      mut as int64: final_dist = dist[dst]
      route {
            final_dist >= 999999 ==> {
                  mut as list of data: empty_res = [999999, []]
                  emit(nice, empty_res, "unreachable")
            }
            _ ==> {
                  #L Reconstrói o caminho de dst até src
                  mut as list of int64: rev_path = []
                  mut as int64: curr = dst
                  infinite (curr != 0) {
                        rev_path = listPushBack(rev_path, curr)
                        curr = prev[curr]
                  }
                  
                  #L Inverte para obter src -> dst
                  mut as list of int64: path = []
                  mut as int64: p_len = listLength(rev_path)
                  i = p_len
                  infinite (i >= 1) {
                        path = listPushBack(path, rev_path[i])
                        i = i - 1
                  }
                  
                  mut as list of data: ret = [final_dist, path]
                  emit(nice, ret, "ok")
            }
      }
}

program (ExampleOfYenKShortestPaths) {
      println("==================================================")
      println("  SciAlgo: Yen's K-Shortest Simple Paths")
      println("==================================================")

      #L Grafo direcionado de 5 vértices
      #L Origem = 1, Destino = 5, K = 3
      mut as int64: num_v = 5
      mut as int64: src = 1
      mut as int64: dst = 5
      mut as int64: K = 3

      mut as list of int64: u = [1, 1, 2, 2, 3, 3, 3, 4]
      mut as list of int64: v = [2, 3, 4, 5, 2, 4, 5, 5]
      mut as list of int64: w = [3, 2, 4, 8, 1, 2, 6, 3]
      mut as int64: num_e = listLength(u)

      #L Inicializa máscaras
      mut as list of bool: edge_dis = []
      mut as int64: e = 1
      infinite (e <= num_e) {
            edge_dis = listPushBack(edge_dis, false)
            e = e + 1
      }
      mut as list of bool: node_dis = []
      mut as int64: i = 1
      infinite (i <= num_v) {
            node_dis = listPushBack(node_dis, false)
            i = i + 1
      }

      #L 1. Encontra o menor caminho inicial (A[1]) via Dijkstra
      mut as list of data: d1 = dijkstraMasked(num_v, src, dst, u, v, w, edge_dis, node_dis)
      mut as int64: c1 = d1[1] as int64
      mut as list of int64: p1 = d1[2] as list of int64

      mut as list of data: A_paths = [p1]
      mut as list of int64: A_costs = [c1]

      println("1. 1o Menor Caminho (Custo: " + c1 + "): " + p1)

      #L Conjunto de caminhos candidatos B
      mut as list of data: B_paths = []
      mut as list of int64: B_costs = []

      #L 2. Loop de Yen para k = 1 até K - 1
      mut as int64: k = 1
      infinite (k < K and listLength(A_paths) == k) {
            mut as list of int64: prev_path = A_paths[k] as list of int64
            mut as int64: prev_len = listLength(prev_path)
            
            #L Itera sobre nós de desvio (spur nodes)
            mut as int64: s_idx = 1
            infinite (s_idx < prev_len) {
                  mut as int64: spur_node = prev_path[s_idx]
                  mut as list of int64: root_path = listTake(prev_path, s_idx)
                  mut as int64: root_len = listLength(root_path)
                  
                  #L Calcula custo do root_path
                  mut as int64: root_cost = 0
                  mut as int64: r_i = 1
                  infinite (r_i < root_len) {
                        mut as int64: r_u = root_path[r_i]
                        mut as int64: r_v = root_path[r_i + 1]
                        e = 1
                        infinite (e <= num_e) {
                              route {
                                    u[e] == r_u and v[e] == r_v ==> {
                                          root_cost = root_cost + w[e]
                                          break
                                    }
                              }
                              e = e + 1
                        }
                        r_i = r_i + 1
                  }
                  
                  #L Desabilita arestas que coincidem com caminhos de A
                  mut as list of bool: cur_edge_dis = []
                  e = 1
                  infinite (e <= num_e) {
                        cur_edge_dis = listPushBack(cur_edge_dis, false)
                        e = e + 1
                  }
                  
                  mut as int64: a_idx = 1
                  mut as int64: num_a = listLength(A_paths)
                  infinite (a_idx <= num_a) {
                        mut as list of int64: p_a = A_paths[a_idx] as list of int64
                        mut as int64: len_pa = listLength(p_a)
                        route {
                              len_pa >= s_idx + 1 ==> {
                                    mut as bool: prefix_equal = true
                                    mut as int64: p_i = 1
                                    infinite (p_i <= s_idx) {
                                          route {
                                                root_path[p_i] != p_a[p_i] ==> {
                                                      prefix_equal = false
                                                      break
                                                }
                                          }
                                          p_i = p_i + 1
                                    }
                                    route {
                                          prefix_equal ==> {
                                                mut as int64: blocked_u = p_a[s_idx]
                                                mut as int64: blocked_v = p_a[s_idx + 1]
                                                e = 1
                                                infinite (e <= num_e) {
                                                      route {
                                                            u[e] == blocked_u and v[e] == blocked_v ==> {
                                                                  cur_edge_dis[e] = true
                                                            }
                                                      }
                                                      e = e + 1
                                                }
                                          }
                                    }
                              }
                        }
                        a_idx = a_idx + 1
                  }
                  
                  #L Desabilita nós do root_path exceto o spur_node para evitar ciclos
                  mut as list of bool: cur_node_dis = []
                  i = 1
                  infinite (i <= num_v) {
                        cur_node_dis = listPushBack(cur_node_dis, false)
                        i = i + 1
                  }
                  r_i = 1
                  infinite (r_i < root_len) {
                        cur_node_dis[root_path[r_i]] = true
                        r_i = r_i + 1
                  }
                  
                  #L Executa Dijkstra a partir do spur_node até dst
                  mut as list of data: spur_res = dijkstraMasked(num_v, spur_node, dst, u, v, w, cur_edge_dis, cur_node_dis)
                  mut as int64: spur_cost = spur_res[1] as int64
                  mut as list of int64: spur_path = spur_res[2] as list of int64
                  
                  route {
                        spur_cost < 999999 ==> {
                              #L Concatena root_path com spur_path (sem duplicar o spur_node)
                              mut as list of int64: candidate = []
                              mut as int64: c_i = 1
                              infinite (c_i <= root_len) {
                                    candidate = listPushBack(candidate, root_path[c_i])
                                    c_i = c_i + 1
                              }
                              mut as int64: spur_len = listLength(spur_path)
                              c_i = 2
                              infinite (c_i <= spur_len) {
                                    candidate = listPushBack(candidate, spur_path[c_i])
                                    c_i = c_i + 1
                              }
                              
                              mut as int64: total_c = root_cost + spur_cost
                              B_paths = listPushBack(B_paths, candidate)
                              B_costs = listPushBack(B_costs, total_c)
                        }
                  }
                  s_idx = s_idx + 1
            }
            
            route {
                  listLength(B_paths) == 0 ==> {
                        break
                  }
            }
            
            #L Encontra o candidato de menor custo em B
            mut as int64: best_b = 1
            mut as int64: min_b_cost = B_costs[1]
            mut as int64: b_idx = 2
            mut as int64: total_b = listLength(B_costs)
            infinite (b_idx <= total_b) {
                  route {
                        B_costs[b_idx] < min_b_cost ==> {
                              min_b_cost = B_costs[b_idx]
                              best_b = b_idx
                        }
                  }
                  b_idx = b_idx + 1
            }
            
            mut as list of int64: best_path = B_paths[best_b] as list of int64
            A_paths = listPushBack(A_paths, best_path)
            A_costs = listPushBack(A_costs, min_b_cost)
            
            #L Remove best_b de B
            mut as list of data: new_bp = []
            mut as list of int64: new_bc = []
            b_idx = 1
            infinite (b_idx <= total_b) {
                  route {
                        b_idx != best_b ==> {
                              new_bp = listPushBack(new_bp, B_paths[b_idx])
                              new_bc = listPushBack(new_bc, B_costs[b_idx])
                        }
                  }
                  b_idx = b_idx + 1
            }
            B_paths = new_bp
            B_costs = new_bc
            
            k = k + 1
            println((k as string) + ". " + k + "o Menor Caminho (Custo: " + min_b_cost + "): " + best_path)
      }

      mut as bool: ok = (A_costs[1] == 7) and (A_costs[2] == 8) and (A_costs[3] == 10)
      println("4. Verificacao dos 3 menores caminhos (7 <= 8 <= 10): " + ok)
      println("==================================================")
}
