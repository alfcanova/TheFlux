#L ============================================================================
#L Algoritmo: Bron-Kerbosch com Pivoteamento (Cliques Maximais em Grafos)
#L Domínio: 03_graphs / Categoria: Cliques e Subgrafos Densos
#L Complexidade: Pior Caso O(3^(V/3))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

#L Retorna lista com adjacencias de v em matriz booleana
function (getNeighbors) (as int64: num_v, as list of int64: adj_matrix, as int64: v) as list of int64 {
      mut as list of int64: vizinhos = []
      mut as int64: u = 1
      infinite (u <= num_v) {
            mut as int64: idx = (v - 1) * num_v + u
            route {
                  adj_matrix[idx] == 1 ==> {
                        vizinhos = listPushBack(vizinhos, u)
                  }
            }
            u = u + 1
      }
      emit(nice, vizinhos, "ok")
}

#L Intersecao de duas listas de inteiros
function (intersectLists) (as list of int64: a, as list of int64: b) as list of int64 {
      mut as list of int64: res = []
      mut as int64: i = 1
      mut as int64: len_a = listLength(a)
      mut as int64: len_b = listLength(b)
      
      infinite (i <= len_a) {
            mut as int64: item = a[i]
            mut as bool: in_b = false
            mut as int64: j = 1
            infinite (j <= len_b) {
                  route {
                        b[j] == item ==> {
                              in_b = true
                              break
                        }
                  }
                  j = j + 1
            }
            route {
                  in_b ==> {
                        res = listPushBack(res, item)
                  }
            }
            i = i + 1
      }
      emit(nice, res, "ok")
}

#L Bron-Kerbosch com pivoteamento
function (bronKerbosch) (
      as int64: num_v,
      as list of int64: adj,
      as list of int64: R,
      as list of int64: P,
      as list of int64: X,
      as list of data: cliques
) as list of data {
      mut as int64: len_p = listLength(P)
      mut as int64: len_x = listLength(X)
      
      #L Se P e X estão vazios, R é um clique maximal
      route {
            len_p == 0 and len_x == 0 ==> {
                  mut as list of data: nova_lista = listPushBack(cliques, R)
                  emit(nice, nova_lista, "found")
            }
            len_p == 0 ==> {
                  emit(nice, cliques, "none")
            }
            _ ==> {
                  #L Escolha de pivô u em P união X (escolhemos o primeiro elemento de P)
                  mut as int64: pivot = P[1]
                  mut as list of int64: pivot_neighbors = getNeighbors(num_v, adj, pivot)
                  
                  #L Candidatos: v in P \ N(pivot)
                  mut as list of int64: candidatos = []
                  mut as int64: i = 1
                  infinite (i <= len_p) {
                        mut as int64: v = P[i]
                        mut as bool: eh_vizinho = false
                        mut as int64: j = 1
                        mut as int64: n_piv = listLength(pivot_neighbors)
                        infinite (j <= n_piv) {
                              route {
                                    pivot_neighbors[j] == v ==> {
                                          eh_vizinho = true
                                          break
                                    }
                              }
                              j = j + 1
                        }
                        route {
                              not eh_vizinho ==> {
                                    candidatos = listPushBack(candidatos, v)
                              }
                        }
                        i = i + 1
                  }
                  
                  mut as list of data: cur_cliques = cliques
                  mut as list of int64: cur_p = P
                  mut as list of int64: cur_x = X
                  
                  mut as int64: c_idx = 1
                  mut as int64: num_cand = listLength(candidatos)
                  infinite (c_idx <= num_cand) {
                        mut as int64: v = candidatos[c_idx]
                        mut as list of int64: v_neighbors = getNeighbors(num_v, adj, v)
                        
                        mut as list of int64: next_r = listPushBack(R, v)
                        mut as list of int64: next_p = intersectLists(cur_p, v_neighbors)
                        mut as list of int64: next_x = intersectLists(cur_x, v_neighbors)
                        
                        cur_cliques = bronKerbosch(num_v, adj, next_r, next_p, next_x, cur_cliques)
                        
                        #L Remove v de cur_p e adiciona em cur_x
                        mut as list of int64: novo_p = []
                        mut as int64: p_i = 1
                        mut as int64: p_sz = listLength(cur_p)
                        infinite (p_i <= p_sz) {
                              route {
                                    cur_p[p_i] != v ==> {
                                          novo_p = listPushBack(novo_p, cur_p[p_i])
                                    }
                              }
                              p_i = p_i + 1
                        }
                        cur_p = novo_p
                        cur_x = listPushBack(cur_x, v)
                        
                        c_idx = c_idx + 1
                  }
                  
                  emit(nice, cur_cliques, "done")
            }
      }
}

program (ExampleOfGrafosComplexidadeBronKerbosch) {
      println("==================================================")
      println("  SciAlgo: Bron-Kerbosch (Cliques Maximais)")
      println("==================================================")

      #L Grafo de 6 vértices com um 4-clique {1, 2, 3, 4} e arestas para 5 e 6
      #L Cliques maximais esperados:
      #L - {1, 2, 3, 4} (tamanho 4)
      #L - {4, 5} (tamanho 2)
      #L - {5, 6} (tamanho 2)
      mut as int64: num_v = 6
      mut as list of int64: adj = []
      
      #L Inicializa matriz de adjacência 6x6 com 0
      mut as int64: i = 1
      infinite (i <= 36) {
            adj = listPushBack(adj, 0)
            i = i + 1
      }
      
      #L Adiciona arestas não-direcionadas
      #L 4-clique: 1-2, 1-3, 1-4, 2-3, 2-4, 3-4
      #L e arestas: 4-5, 5-6
      mut as list of int64: u_edges = [1, 1, 1, 2, 2, 3, 4, 5]
      mut as list of int64: v_edges = [2, 3, 4, 3, 4, 4, 5, 6]
      mut as int64: e = 1
      mut as int64: m = listLength(u_edges)
      infinite (e <= m) {
            mut as int64: eu = u_edges[e]
            mut as int64: ev = v_edges[e]
            adj[(eu - 1) * num_v + ev] = 1
            adj[(ev - 1) * num_v + eu] = 1
            e = e + 1
      }

      println("1. Grafo com 6 vertices inicializado")
      println("   4-clique entre {1, 2, 3, 4}")
      println("   Arestas adicionais: (4-5) e (5-6)")

      mut as list of int64: initial_R = []
      mut as list of int64: initial_P = [1, 2, 3, 4, 5, 6]
      mut as list of int64: initial_X = []
      mut as list of data: cliques_encontrados = []

      cliques_encontrados = bronKerbosch(num_v, adj, initial_R, initial_P, initial_X, cliques_encontrados)

      mut as int64: total_cliques = listLength(cliques_encontrados)
      println("2. Total de cliques maximais encontrados: " + total_cliques)

      mut as bool: encontrou_4clique = false
      mut as int64: c_i = 1
      infinite (c_i <= total_cliques) {
            mut as list of int64: clq = cliques_encontrados[c_i] as list of int64
            println("   Clique #" + c_i + " (Tamanho " + listLength(clq) + "): " + clq)
            route {
                  listLength(clq) == 4 ==> {
                        encontrou_4clique = true
                  }
            }
            c_i = c_i + 1
      }

      mut as bool: ok = (total_cliques == 3) and encontrou_4clique
      println("3. Verificacao de cliques maximais (3 cliques, incluindo 4-clique): " + ok)
      println("==================================================")
}
