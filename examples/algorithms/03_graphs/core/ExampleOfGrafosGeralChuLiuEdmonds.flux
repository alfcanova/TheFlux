#L ============================================================================
#L Algoritmo: Chu-Liu/Edmonds (Árvore Geradora Mínima Direcionada / Arborescência)
#L Domínio: 03_graphs / Categoria: Árvores Geradoras e Ramificação
#L Complexidade: O(V * E)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (chuLiuEdmonds) (as int64: num_v, as int64: root, as list of int64: edges_u, as list of int64: edges_v, as list of int64: edges_w) as int64 {
      mut as int64: num_edges = listLength(edges_u)
      mut as int64: total_weight = 0
      mut as int64: v_count = num_v
      mut as int64: root_node = root
      
      mut as list of int64: cur_u = edges_u
      mut as list of int64: cur_v = edges_v
      mut as list of int64: cur_w = edges_w
      
      infinite (true) {
            #L 1. Encontra a menor aresta incidente para cada vertice v != root
            mut as list of int64: min_in = []
            mut as list of int64: parent = []
            mut as int64: i = 1
            infinite (i <= v_count) {
                  min_in = listPushBack(min_in, 999999)
                  parent = listPushBack(parent, 0)
                  i = i + 1
            }
            
            mut as int64: e = 1
            mut as int64: m = listLength(cur_u)
            infinite (e <= m) {
                  mut as int64: u = cur_u[e]
                  mut as int64: v = cur_v[e]
                  mut as int64: w = cur_w[e]
                  route {
                        u != v and v != root_node ==> {
                              route {
                                    w < min_in[v] ==> {
                                          min_in[v] = w
                                          parent[v] = u
                                    }
                              }
                        }
                  }
                  e = e + 1
            }
            
            #L 2. Detecta ciclos na selecao de arestas
            mut as list of int64: group = []
            mut as list of int64: visited = []
            mut as list of bool: in_cycle = []
            i = 1
            infinite (i <= v_count) {
                  group = listPushBack(group, 0)
                  visited = listPushBack(visited, 0)
                  in_cycle = listPushBack(in_cycle, false)
                  i = i + 1
            }
            
            mut as int64: group_count = 0
            mut as bool: has_cycle = false
            
            i = 1
            infinite (i <= v_count) {
                  route {
                        i != root_node and visited[i] == 0 ==> {
                              mut as int64: curr = i
                              infinite (curr != root_node and curr != 0 and visited[curr] == 0) {
                                    visited[curr] = i
                                    curr = parent[curr]
                              }
                              
                              #L Se encontramos o mesmo marcador i, temos um ciclo
                              route {
                                    curr != root_node and curr != 0 and visited[curr] == i ==> {
                                          has_cycle = true
                                          group_count = group_count + 1
                                          mut as int64: cycle_node = curr
                                          group[cycle_node] = group_count
                                          in_cycle[cycle_node] = true
                                          cycle_node = parent[cycle_node]
                                          infinite (cycle_node != curr) {
                                                group[cycle_node] = group_count
                                                in_cycle[cycle_node] = true
                                                cycle_node = parent[cycle_node]
                                          }
                                    }
                              }
                        }
                  }
                  i = i + 1
            }
            
            #L 3. Se não há ciclos, somamos todos os min_in e encerramos
            route {
                  not has_cycle ==> {
                        i = 1
                        infinite (i <= v_count) {
                              route {
                                    i != root_node ==> {
                                          total_weight = total_weight + min_in[i]
                                    }
                              }
                              i = i + 1
                        }
                        break
                  }
            }
            
            #L 4. Se há ciclo, acumula peso dos nós do ciclo e atribui IDs de grupos
            i = 1
            infinite (i <= v_count) {
                  route {
                        in_cycle[i] ==> {
                              total_weight = total_weight + min_in[i]
                        }
                        _ ==> {
                              group_count = group_count + 1
                              group[i] = group_count
                        }
                  }
                  i = i + 1
            }
            
            #L 5. Reconstrói arestas com pesos ajustados para o grafo contraído
            mut as list of int64: next_u = []
            mut as list of int64: next_v = []
            mut as list of int64: next_w = []
            
            e = 1
            infinite (e <= m) {
                  mut as int64: u_old = cur_u[e]
                  mut as int64: v_old = cur_v[e]
                  mut as int64: w_old = cur_w[e]
                  
                  mut as int64: u_new = group[u_old]
                  mut as int64: v_new = group[v_old]
                  route {
                        u_new != v_new ==> {
                              next_u = listPushBack(next_u, u_new)
                              next_v = listPushBack(next_v, v_new)
                              #L Ajuste compensatório apenas se v_old pertence ao ciclo contraído
                              mut as int64: adjusted_w = w_old
                              route {
                                    in_cycle[v_old] ==> {
                                          adjusted_w = w_old - min_in[v_old]
                                    }
                              }
                              next_w = listPushBack(next_w, adjusted_w)
                        }
                  }
                  e = e + 1
            }
            
            cur_u = next_u
            cur_v = next_v
            cur_w = next_w
            root_node = group[root_node]
            v_count = group_count
      }
      
      emit(nice, total_weight, "ok")
}

program (ExampleOfGrafosGeralChuLiuEdmonds) {
      println("==================================================")
      println("  SciAlgo: Chu-Liu/Edmonds (Directed MST)")
      println("==================================================")

      #L Grafo direcionado ponderado de 4 vértices
      #L Raiz = 1
      #L Arestas: (1->2: 10), (1->3: 12), (2->3: 4), (3->2: 2), (2->4: 8), (3->4: 7)
      mut as list of int64: u = [1, 1, 2, 3, 2, 3]
      mut as list of int64: v = [2, 3, 3, 2, 4, 4]
      mut as list of int64: w = [10, 12, 4, 2, 8, 7]

      println("1. Grafo com 4 vertices e 6 arestas direcionadas")
      println("   Origens : " + u)
      println("   Destinos: " + v)
      println("   Pesos   : " + w)
      println("2. Vertice raiz: 1")

      mut as int64: custo_arborescencia = chuLiuEdmonds(4, 1, u, v, w)
      println("3. Custo minimo da arborescencia (Directed MST): " + custo_arborescencia)

      #L O custo ótimo canônico para este grafo é 21: (1->3: 12) + (3->2: 2) + (3->4: 7) = 21
      mut as bool: ok = custo_arborescencia == 21
      println("4. Verificacao de custo otimo (21): " + ok)
      println("Concluido com Sucesso")
      println("==================================================")
}
