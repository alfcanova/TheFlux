#L ============================================================================
#L Algoritmo: Range Tree (Arvore de Busca Ortogonal 2D / 2D Orthogonal Range Tree)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N log N) | Contagem Ortogonal 2D O(log^2 N) | Espaco O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRangeTree) {
      println("==================================================")
      println("  SciAlgo: Range Tree (Busca Ortogonal 2D)")
      println("==================================================")

      #L Conjunto de N = 8 pontos 2D (x, y) ja ordenados por coordenada X
      mut as list of int64: pt_x = [2,  5,  9, 12, 15, 20, 24, 30]
      mut as list of int64: pt_y = [18, 4, 32, 10, 25,  8, 14, 22]
      mut as int64: n = listLength(pt_x)

      println("1. Pontos 2D indexados (ordenados por X):")
      mut as int64: pi = 1
      infinite (pi <= n) {
            println("   P" + pi + " = (" + pt_x[pi] + ", " + pt_y[pi] + ")")
            pi = pi + 1
      }

      #L Estrutura da Range Tree 2D baseada em Arvore de Segmentos:
      #L O nivel primario divide o espaco X no intervalo 1..N (com no maximo 4*N nos = 32 nos)
      #L Cada no u armazena o subconjunto de pontos coberto, com suas coordenadas Y ordenadas
      #L Usamos um pool linear 'pool_y' com deslocamentos 'node_offset' e 'node_len'
      mut as int64: max_nodes = 32
      mut as list of int64: node_offset = []
      mut as list of int64: node_len = []
      mut as list of int64: pool_y = []

      mut as int64: init_i = 1
      infinite (init_i <= max_nodes) {
            node_offset = listPushBack(node_offset, 0)
            node_len = listPushBack(node_len, 0)
            init_i = init_i + 1
      }

      #L Fila/pilha para construcao iterativa da arvore de segmentos:
      #L Armazenamos [node_id, left_idx, right_idx]
      mut as list of int64: q_node = [1]
      mut as list of int64: q_l = [1]
      mut as list of int64: q_r = [n]
      mut as int64: q_head = 1

      infinite (q_head <= listLength(q_node)) {
            mut as int64: u = q_node[q_head]
            mut as int64: l = q_l[q_head]
            mut as int64: r = q_r[q_head]
            q_head = q_head + 1

            #L Coleta as coordenadas Y no intervalo [l..r]
            mut as list of int64: sub_y = []
            mut as int64: k = l
            infinite (k <= r) {
                  sub_y = listPushBack(sub_y, pt_y[k])
                  k = k + 1
            }

            #L Ordena sub_y usando Insertion Sort
            mut as int64: sub_sz = listLength(sub_y)
            mut as int64: si = 2
            infinite (si <= sub_sz) {
                  mut as int64: key_y = sub_y[si]
                  mut as int64: sj = si - 1
                  mut as bool: cont_sort = true
                  infinite (cont_sort) {
                        route {
                              sj < 1 ==> { cont_sort = false }
                              _ ==> {
                                    route {
                                          sub_y[sj] > key_y ==> {
                                                sub_y[sj + 1] = sub_y[sj]
                                                sj = sj - 1
                                          }
                                          _ ==> { cont_sort = false }
                                    }
                              }
                        }
                  }
                  sub_y[sj + 1] = key_y
                  si = si + 1
            }

            #L Armazena o vetor ordenado no pool global
            node_offset[u] = listLength(pool_y) + 1
            node_len[u] = sub_sz
            mut as int64: cp_i = 1
            infinite (cp_i <= sub_sz) {
                  pool_y = listPushBack(pool_y, sub_y[cp_i])
                  cp_i = cp_i + 1
            }

            #L Se nao for folha, agenda filhos
            route {
                  l < r ==> {
                        mut as int64: mid = (l + r) /i 2
                        q_node = listPushBack(q_node, 2 * u)
                        q_l = listPushBack(q_l, l)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * u) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, r)
                  }
            }
      }

      println("2. Range Tree 2D construida com sucesso.")

      #L Consultas ortogonais retangulares [qx1, qx2] x [qy1, qy2]
      mut as list of int64: queries_x1 = [5,  1,  1, 25]
      mut as list of int64: queries_x2 = [22, 35, 10, 28]
      mut as list of int64: queries_y1 = [5,  1,  1,  1]
      mut as list of int64: queries_y2 = [26, 35, 15, 100]
      mut as int64: num_queries = listLength(queries_x1)

      println("3. Executando consultas de contagem ortogonal [x1..x2] x [y1..y2]:")
      mut as bool: all_correct = true

      mut as int64: qi = 1
      infinite (qi <= num_queries) {
            mut as int64: qx1 = queries_x1[qi]
            mut as int64: qx2 = queries_x2[qi]
            mut as int64: qy1 = queries_y1[qi]
            mut as int64: qy2 = queries_y2[qi]

            #L 1. Encontra indices de x_start e x_end em pt_x
            mut as int64: idx_start = n + 1
            mut as int64: idx_end = 0
            mut as int64: f_i = 1
            infinite (f_i <= n) {
                  route {
                        pt_x[f_i] >= qx1 ==> {
                              route {
                                    f_i < idx_start ==> { idx_start = f_i }
                              }
                        }
                  }
                  route {
                        pt_x[f_i] <= qx2 ==> {
                              route {
                                    f_i > idx_end ==> { idx_end = f_i }
                              }
                        }
                  }
                  f_i = f_i + 1
            }

            mut as int64: tree_count = 0
            route {
                  idx_start <= idx_end ==> {
                        #L Decomposicao em nos canonicos da arvore de segmentos
                        mut as list of int64: stk_u = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                        mut as list of int64: stk_l = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                        mut as list of int64: stk_r = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                        mut as int64: stk_top = 1
                        stk_u[1] = 1
                        stk_l[1] = 1
                        stk_r[1] = n

                        infinite (stk_top > 0) {
                              mut as int64: cu = stk_u[stk_top]
                              mut as int64: cl = stk_l[stk_top]
                              mut as int64: cr = stk_r[stk_top]
                              stk_top = stk_top - 1

                              route {
                                    (idx_start <= cl) and (cr <= idx_end) ==> {
                                          #L No canonico completamente contido: busca binaria em Y
                                          mut as int64: off = node_offset[cu]
                                          mut as int64: sz = node_len[cu]

                                          #L Conta quantos elementos em pool_y[off .. off + sz - 1] estao em [qy1, qy2]
                                          mut as int64: low = 0
                                          mut as int64: high = sz - 1
                                          mut as int64: first_ge = sz
                                          infinite (low <= high) {
                                                mut as int64: m = (low + high) /i 2
                                                route {
                                                      pool_y[off + m] >= qy1 ==> {
                                                            first_ge = m
                                                            high = m - 1
                                                      }
                                                      _ ==> {
                                                            low = m + 1
                                                      }
                                                }
                                          }

                                          low = 0
                                          high = sz - 1
                                          mut as int64: last_le = -1
                                          infinite (low <= high) {
                                                mut as int64: m = (low + high) /i 2
                                                route {
                                                      pool_y[off + m] <= qy2 ==> {
                                                            last_le = m
                                                            low = m + 1
                                                      }
                                                      _ ==> {
                                                            high = m - 1
                                                      }
                                                }
                                          }

                                          route {
                                                first_ge <= last_le ==> {
                                                      tree_count = tree_count + (last_le - first_ge + 1)
                                                }
                                          }
                                    }
                                    _ ==> {
                                          mut as int64: cmid = (cl + cr) /i 2
                                          #L Sobreposicao com filho a esquerda
                                          route {
                                                idx_start <= cmid ==> {
                                                      stk_top = stk_top + 1
                                                      stk_u[stk_top] = 2 * cu
                                                      stk_l[stk_top] = cl
                                                      stk_r[stk_top] = cmid
                                                }
                                          }
                                          #L Sobreposicao com filho a direita
                                          route {
                                                idx_end > cmid ==> {
                                                      stk_top = stk_top + 1
                                                      stk_u[stk_top] = (2 * cu) + 1
                                                      stk_l[stk_top] = cmid + 1
                                                      stk_r[stk_top] = cr
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            #L Validacao por busca linear (forca-bruta)
            mut as int64: brute_count = 0
            mut as int64: bi = 1
            infinite (bi <= n) {
                  route {
                        (pt_x[bi] >= qx1) and (pt_x[bi] <= qx2) ==> {
                              route {
                                    (pt_y[bi] >= qy1) and (pt_y[bi] <= qy2) ==> {
                                          brute_count = brute_count + 1
                                    }
                              }
                        }
                  }
                  bi = bi + 1
            }

            mut as bool: ok = (tree_count == brute_count)
            route {
                  not ok ==> { all_correct = false }
            }
            println("   Consulta [" + qx1 + ".." + qx2 + "] x [" + qy1 + ".." + qy2 + "]: Arvore = " + tree_count + " | Esperado = " + brute_count + " -> " + ok)

            qi = qi + 1
      }

      println("4. Verificacao geral da Range Tree 2D: " + all_correct)
      println("Concluido com Sucesso")
}
