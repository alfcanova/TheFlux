#L ============================================================================
#L Algoritmo: MPM (Malhotra, Pramodh-Kumar & Maheshwari)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^3) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteMPM) {
      println("==================================================")
      println("  SciAlgo: MPM (Malhotra-Pramodh-Kumar-Maheshwari)")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Matriz de capacidades residuais 4x4
      mut as list of int64: capacity = [
            0, 15, 10, 0,
            0, 0, 5, 10,
            0, 0, 0, 15,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Capacidades: 1->2: 15, 1->3: 10, 2->3: 5, 2->4: 10, 3->4: 15")

      mut as int64: total_flow = 0
      mut as bool: has_augmenting_phase = true

      #L Execucao em fases do algoritmo MPM
      infinite (has_augmenting_phase) {
            #L Passo 1: Construir o grafo em niveis via BFS
            mut as list of int64: level = [-1, -1, -1, -1]
            level[src] = 0

            mut as list of int64: queue = [0, 0, 0, 0]
            mut as int64: q_head = 1
            mut as int64: q_tail = 1
            queue[q_tail] = src
            q_tail = q_tail + 1

            infinite (q_head < q_tail) {
                  mut as int64: curr = queue[q_head]
                  q_head = q_head + 1

                  mut as int64: nxt = 1
                  infinite (nxt <= num_v) {
                        mut as int64: c_idx = (curr - 1) * num_v + nxt
                        route {
                              (capacity[c_idx] > 0) and (level[nxt] == -1) ==> {
                                    level[nxt] = level[curr] + 1
                                    queue[q_tail] = nxt
                                    q_tail = q_tail + 1
                              }
                              _ ==> {}
                        }
                        nxt = nxt + 1
                  }
            }

            route {
                  level[sink] == -1 ==> {
                        has_augmenting_phase = false
                  }
                  _ ==> {
                        #L Passo 2: Empurrar fluxo na rede em camadas usando potenciais
                        mut as bool: phase_done = false

                        infinite (not phase_done) {
                              #L Calcula potenciais dos nos no grafo em niveis
                              #L in_pot: soma das capacidades residuais de arestas (v, u) com level[v] == level[u] - 1
                              #L out_pot: soma das capacidades residuais de arestas (u, w) com level[w] == level[u] + 1
                              mut as list of int64: in_pot = [0, 0, 0, 0]
                              mut as list of int64: out_pot = [0, 0, 0, 0]
                              mut as list of int64: node_pot = [0, 0, 0, 0]

                              mut as int64: u = 1
                              infinite (u <= num_v) {
                                    mut as int64: v_idx = 1
                                    infinite (v_idx <= num_v) {
                                          mut as int64: cap_uv = capacity[(u - 1) * num_v + v_idx]
                                          route {
                                                (cap_uv > 0) and (level[u] + 1 == level[v_idx]) ==> {
                                                      out_pot[u] = out_pot[u] + cap_uv
                                                      in_pot[v_idx] = in_pot[v_idx] + cap_uv
                                                }
                                                _ ==> {}
                                          }
                                          v_idx = v_idx + 1
                                    }
                                    u = u + 1
                              }

                              #L Potencial de cada no
                              u = 1
                              infinite (u <= num_v) {
                                    route {
                                          u == src ==> {
                                                node_pot[u] = out_pot[u]
                                          }
                                          u == sink ==> {
                                                node_pot[u] = in_pot[u]
                                          }
                                          _ ==> {
                                                mut as int64: p = in_pot[u]
                                                route {
                                                      out_pot[u] < p ==> {
                                                            p = out_pot[u]
                                                      }
                                                      _ ==> {}
                                                }
                                                node_pot[u] = p
                                          }
                                    }
                                    u = u + 1
                              }

                              #L Verifica se ha potencial valido entre os nos com caminho
                              route {
                                    (node_pot[src] <= 0) or (node_pot[sink] <= 0) ==> {
                                          phase_done = true
                                    }
                                    _ ==> {
                                          #L Encontra vertice com potencial minimo estritamente positivo
                                          mut as int64: min_node = 0
                                          mut as int64: min_p = 999999
                                          u = 1
                                          infinite (u <= num_v) {
                                                route {
                                                      (node_pot[u] > 0) and (node_pot[u] < min_p) ==> {
                                                            min_p = node_pot[u]
                                                            min_node = u
                                                      }
                                                      _ ==> {}
                                                }
                                                u = u + 1
                                          }

                                          route {
                                                min_node == 0 ==> {
                                                      phase_done = true
                                                }
                                                _ ==> {
                                                      #L Empurra min_p para frente ate o sumidouro
                                                      mut as int64: push_val = min_p

                                                      #L 1. Encontra caminho de min_node ate sink
                                                      mut as list of int64: path_fwd = [0, 0, 0, 0]
                                                      mut as int64: len_fwd = 1
                                                      path_fwd[1] = min_node
                                                      mut as int64: curr_f = min_node
                                                      infinite (curr_f != sink) {
                                                            mut as int64: cand = 1
                                                            mut as int64: found_nxt = 0
                                                            infinite (cand <= num_v and found_nxt == 0) {
                                                                  mut as int64: c_idx = (curr_f - 1) * num_v + cand
                                                                  route {
                                                                        (capacity[c_idx] >= push_val) and (level[curr_f] + 1 == level[cand]) ==> {
                                                                              found_nxt = cand
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  cand = cand + 1
                                                            }
                                                            route {
                                                                  found_nxt > 0 ==> {
                                                                        len_fwd = len_fwd + 1
                                                                        path_fwd[len_fwd] = found_nxt
                                                                        curr_f = found_nxt
                                                                  }
                                                                  _ ==> {
                                                                        #L Nao encontrou aresta individual de capacidade suficiente, encerra fase
                                                                        curr_f = sink
                                                                  }
                                                            }
                                                      }

                                                      #L 2. Encontra caminho de src ate min_node
                                                      mut as list of int64: path_bwd = [0, 0, 0, 0]
                                                      mut as int64: len_bwd = 1
                                                      path_bwd[1] = min_node
                                                      mut as int64: curr_b = min_node
                                                      infinite (curr_b != src) {
                                                            mut as int64: cand = 1
                                                            mut as int64: found_prev = 0
                                                            infinite (cand <= num_v and found_prev == 0) {
                                                                  mut as int64: c_idx = (cand - 1) * num_v + curr_b
                                                                  route {
                                                                        (capacity[c_idx] >= push_val) and (level[cand] + 1 == level[curr_b]) ==> {
                                                                              found_prev = cand
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  cand = cand + 1
                                                            }
                                                            route {
                                                                  found_prev > 0 ==> {
                                                                        len_bwd = len_bwd + 1
                                                                        path_bwd[len_bwd] = found_prev
                                                                        curr_b = found_prev
                                                                  }
                                                                  _ ==> {
                                                                        curr_b = src
                                                                  }
                                                            }
                                                      }

                                                      #L Se ambos os caminhos alcancam src e sink, aplica o fluxo
                                                      route {
                                                            (path_fwd[len_fwd] == sink) and (path_bwd[len_bwd] == src) ==> {
                                                                  #L Aplica fluxo fwd
                                                                  mut as int64: i = 1
                                                                  infinite (i < len_fwd) {
                                                                        mut as int64: a = path_fwd[i]
                                                                        mut as int64: b = path_fwd[i + 1]
                                                                        mut as int64: f_idx = (a - 1) * num_v + b
                                                                        mut as int64: r_idx = (b - 1) * num_v + a
                                                                        capacity[f_idx] = capacity[f_idx] - push_val
                                                                        capacity[r_idx] = capacity[r_idx] + push_val
                                                                        i = i + 1
                                                                  }

                                                                  #L Aplica fluxo bwd
                                                                  i = len_bwd
                                                                  infinite (i > 1) {
                                                                        mut as int64: a = path_bwd[i]
                                                                        mut as int64: b = path_bwd[i - 1]
                                                                        mut as int64: f_idx = (a - 1) * num_v + b
                                                                        mut as int64: r_idx = (b - 1) * num_v + a
                                                                        capacity[f_idx] = capacity[f_idx] - push_val
                                                                        capacity[r_idx] = capacity[r_idx] + push_val
                                                                        i = i - 1
                                                                  }

                                                                  total_flow = total_flow + push_val
                                                            }
                                                            _ ==> {
                                                                  phase_done = true
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Fluxo maximo calculado via MPM: " + total_flow)
      println("MPM concluido com sucesso.")
}
