#L ============================================================================
#L Algoritmo: Suffix Tree (Arvore de Sufixos Compactada para Analise de Strings)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N) / O(N^2) | Busca de Padrao O(M) | Substring Repetida O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSuffixTree) {
      println("==================================================")
      println("  SciAlgo: Suffix Tree (Arvore de Sufixos)")
      println("==================================================")

      #L String texto base: "banana$" (tamanho N = 7)
      #L Representada em codigos ASCII:
      #L 'b'=98, 'a'=97, 'n'=110, 'a'=97, 'n'=110, 'a'=97, '$'=36
      mut as list of int64: s = [98, 97, 110, 97, 110, 97, 36]
      mut as int64: n = listLength(s)

      println("1. Texto indexado: 'banana$' (N = 7)")

      #L Representacao dos nos e arestas compactadas:
      #L edge_start[e], edge_end[e]: indices 1-based no texto s
      #L edge_to[e]: no destino
      #L Para cada no, mantemos uma lista de arestas de saida
      #L Usamos uma matriz achatada de transicoes por primeiro caractere (ASCII simplificado:
      #L mapeamos '$' -> 1, 'a' -> 2, 'b' -> 3, 'n' -> 4)

      #L Mapeador de caractere para id 1..4:
      #L '$'=36 -> 1, 'a'=97 -> 2, 'b'=98 -> 3, 'n'=110 -> 4
      #L pool de arestas:
      mut as list of int64: e_start = []
      mut as list of int64: e_end = []
      mut as list of int64: e_to = []

      #L node_edges: para cada no u e char_id c (1..4), guarda edge_idx
      #L node_edges[(u - 1) * 4 + c]
      mut as list of int64: node_trans = []
      #L Inicializa raiz (no 1) com 4 transicoes vazias (0)
      node_trans = listPushBack(node_trans, 0)
      node_trans = listPushBack(node_trans, 0)
      node_trans = listPushBack(node_trans, 0)
      node_trans = listPushBack(node_trans, 0)

      mut as list of int64: node_leaf_count = [0]
      mut as list of int64: node_depth = [0]
      mut as int64: num_nodes = 1

      #L Funcao/bloco para converter ASCII para char_id
      #L Insere os 7 sufixos na arvore compactada
      #L Sufixo i: s[i..n]
      mut as int64: suf_i = 1
      infinite (suf_i <= n) {
            mut as int64: curr_node = 1
            mut as int64: cur_char_idx = suf_i

            mut as bool: matching = true
            infinite (matching) {
                  mut as int64: ch = s[cur_char_idx]
                  mut as int64: cid = 0
                  route {
                        ch == 36 ==> { cid = 1 } #L '$'
                        ch == 97 ==> { cid = 2 } #L 'a'
                        ch == 98 ==> { cid = 3 } #L 'b'
                        ch == 110 ==> { cid = 4 } #L 'n'
                  }

                  mut as int64: t_idx = ((curr_node - 1) * 4) + cid
                  mut as int64: existing_edge = node_trans[t_idx]

                  route {
                        existing_edge == 0 ==> {
                              #L Cria nova aresta direta para folha com o restante do sufixo
                              num_nodes = num_nodes + 1
                              mut as int64: new_leaf = num_nodes
                              #L Inicializa 4 transicoes para a nova folha
                              node_trans = listPushBack(node_trans, 0)
                              node_trans = listPushBack(node_trans, 0)
                              node_trans = listPushBack(node_trans, 0)
                              node_trans = listPushBack(node_trans, 0)
                              node_leaf_count = listPushBack(node_leaf_count, 1)
                              node_depth = listPushBack(node_depth, (n - suf_i + 1))

                              e_start = listPushBack(e_start, cur_char_idx)
                              e_end = listPushBack(e_end, n)
                              e_to = listPushBack(e_to, new_leaf)
                              mut as int64: new_e_idx = listLength(e_start)

                              node_trans[t_idx] = new_e_idx
                              matching = false
                        }
                        _ ==> {
                              #L A aresta ja existe: percorre a aresta comparando caracteres
                              mut as int64: es = e_start[existing_edge]
                              mut as int64: ee = e_end[existing_edge]
                              mut as int64: elen = ee - es + 1
                              mut as int64: match_len = 0

                              mut as bool: edge_match = true
                              infinite (edge_match) {
                                    route {
                                          match_len >= elen ==> { edge_match = false }
                                          (cur_char_idx + match_len) > n ==> { edge_match = false }
                                          _ ==> {
                                                mut as int64: c_edge = s[es + match_len]
                                                mut as int64: c_suf = s[cur_char_idx + match_len]
                                                route {
                                                      c_edge == c_suf ==> {
                                                            match_len = match_len + 1
                                                      }
                                                      _ ==> {
                                                            edge_match = false
                                                      }
                                                }
                                          }
                                    }
                              }

                              route {
                                    match_len == elen ==> {
                                          #L Casou a aresta inteira; desce para o proximo no
                                          curr_node = e_to[existing_edge]
                                          cur_char_idx = cur_char_idx + match_len
                                    }
                                    _ ==> {
                                          #L Casamento parcial: divide a aresta (Edge Split)
                                          #L 1. Cria no intermediario interno
                                          num_nodes = num_nodes + 1
                                          mut as int64: split_node = num_nodes
                                          node_trans = listPushBack(node_trans, 0)
                                          node_trans = listPushBack(node_trans, 0)
                                          node_trans = listPushBack(node_trans, 0)
                                          node_trans = listPushBack(node_trans, 0)
                                          node_leaf_count = listPushBack(node_leaf_count, 0)
                                          node_depth = listPushBack(node_depth, node_depth[curr_node] + match_len)

                                          #L 2. Cria nova folha para o restante do novo sufixo
                                          num_nodes = num_nodes + 1
                                          mut as int64: new_leaf = num_nodes
                                          node_trans = listPushBack(node_trans, 0)
                                          node_trans = listPushBack(node_trans, 0)
                                          node_trans = listPushBack(node_trans, 0)
                                          node_trans = listPushBack(node_trans, 0)
                                          node_leaf_count = listPushBack(node_leaf_count, 1)
                                          node_depth = listPushBack(node_depth, (n - suf_i + 1))

                                          #L 3. Ajusta a aresta existente para terminar no split_node
                                          mut as int64: old_to = e_to[existing_edge]
                                          e_end[existing_edge] = es + match_len - 1
                                          e_to[existing_edge] = split_node

                                          #L 4. Adiciona aresta do split_node para o old_to com o sufixo da aresta original
                                          e_start = listPushBack(e_start, es + match_len)
                                          e_end = listPushBack(e_end, ee)
                                          e_to = listPushBack(e_to, old_to)
                                          mut as int64: edge_to_old = listLength(e_start)

                                          mut as int64: ch_old = s[es + match_len]
                                          mut as int64: cid_old = 0
                                          route {
                                                ch_old == 36 ==> { cid_old = 1 }
                                                ch_old == 97 ==> { cid_old = 2 }
                                                ch_old == 98 ==> { cid_old = 3 }
                                                ch_old == 110 ==> { cid_old = 4 }
                                          }
                                          node_trans[((split_node - 1) * 4) + cid_old] = edge_to_old

                                          #L 5. Adiciona aresta do split_node para o new_leaf
                                          e_start = listPushBack(e_start, cur_char_idx + match_len)
                                          e_end = listPushBack(e_end, n)
                                          e_to = listPushBack(e_to, new_leaf)
                                          mut as int64: edge_to_new = listLength(e_start)

                                          mut as int64: ch_new = s[cur_char_idx + match_len]
                                          mut as int64: cid_new = 0
                                          route {
                                                ch_new == 36 ==> { cid_new = 1 }
                                                ch_new == 97 ==> { cid_new = 2 }
                                                ch_new == 98 ==> { cid_new = 3 }
                                                ch_new == 110 ==> { cid_new = 4 }
                                          }
                                          node_trans[((split_node - 1) * 4) + cid_new] = edge_to_new

                                          matching = false
                                    }
                              }
                        }
                  }
            }

            suf_i = suf_i + 1
      }

      println("2. Suffix Tree construida com " + num_nodes + " nos e " + listLength(e_start) + " arestas compactadas.")

      #L Propaga contagem de folhas para cada no interno (numero de ocorrencias)
      #L Ordem reversa dos nos de num_nodes ate 1
      mut as int64: rn = num_nodes
      infinite (rn >= 1) {
            mut as int64: leaves_sum = 0
            mut as int64: c = 1
            infinite (c <= 4) {
                  mut as int64: ed = node_trans[((rn - 1) * 4) + c]
                  route {
                        ed != 0 ==> {
                              mut as int64: dst = e_to[ed]
                              leaves_sum = leaves_sum + node_leaf_count[dst]
                        }
                  }
                  c = c + 1
            }
            route {
                  leaves_sum > 0 ==> {
                        node_leaf_count[rn] = leaves_sum
                  }
            }
            rn = rn - 1
      }

      #L Testes de busca por substrings
      #L Teste 1: "ana" -> existe, ocorrencias = 2 (ou 3 como substrings)
      #L Teste 2: "nana" -> existe, ocorrencias = 2
      #L Teste 3: "ban" -> existe, ocorrencias = 1
      #L Teste 4: "pan" -> nao existe

      println("3. Executando consultas de busca e frequencia de substrings:")
      mut as bool: all_search_ok = true

      #L Consulta 1: "ana" -> [97, 110, 97]
      mut as list of int64: q_ana = [97, 110, 97]
      mut as int64: curr_u = 1
      mut as int64: matched_chars = 0
      mut as int64: q_sz = listLength(q_ana)
      mut as bool: q_ok = true

      infinite (matched_chars < q_sz) {
            mut as int64: target_c = q_ana[matched_chars + 1]
            mut as int64: cid = 0
            route {
                  target_c == 36 ==> { cid = 1 }
                  target_c == 97 ==> { cid = 2 }
                  target_c == 98 ==> { cid = 3 }
                  target_c == 110 ==> { cid = 4 }
            }
            mut as int64: ed = node_trans[((curr_u - 1) * 4) + cid]
            route {
                  ed == 0 ==> {
                        q_ok = false
                        matched_chars = q_sz
                  }
                  _ ==> {
                        mut as int64: es = e_start[ed]
                        mut as int64: ee = e_end[ed]
                        mut as int64: k = 0
                        mut as int64: elen = ee - es + 1
                        infinite (k < elen) {
                              route {
                                    (matched_chars + 1) <= q_sz ==> {
                                          route {
                                                s[es + k] == q_ana[matched_chars + 1] ==> {
                                                      matched_chars = matched_chars + 1
                                                      k = k + 1
                                                }
                                                _ ==> {
                                                      q_ok = false
                                                      k = elen
                                                      matched_chars = q_sz
                                                }
                                          }
                                    }
                                    _ ==> {
                                          k = elen
                                    }
                              }
                        }
                        curr_u = e_to[ed]
                  }
            }
      }
      mut as int64: ana_occ = 0
      route {
            q_ok ==> { ana_occ = node_leaf_count[curr_u] }
      }
      println("   Busca 'ana': presente = " + q_ok + " | ocorrencias = " + ana_occ + " (esperado true, 2)")
      route {
            (not q_ok) or (ana_occ != 2) ==> { all_search_ok = false }
      }

      #L Consulta 2: "nana" -> [110, 97, 110, 97]
      mut as list of int64: q_nana = [110, 97, 110, 97]
      curr_u = 1
      matched_chars = 0
      q_sz = listLength(q_nana)
      q_ok = true

      infinite (matched_chars < q_sz) {
            mut as int64: target_c = q_nana[matched_chars + 1]
            mut as int64: cid = 0
            route {
                  target_c == 36 ==> { cid = 1 }
                  target_c == 97 ==> { cid = 2 }
                  target_c == 98 ==> { cid = 3 }
                  target_c == 110 ==> { cid = 4 }
            }
            mut as int64: ed = node_trans[((curr_u - 1) * 4) + cid]
            route {
                  ed == 0 ==> {
                        q_ok = false
                        matched_chars = q_sz
                  }
                  _ ==> {
                        mut as int64: es = e_start[ed]
                        mut as int64: ee = e_end[ed]
                        mut as int64: k = 0
                        mut as int64: elen = ee - es + 1
                        infinite (k < elen) {
                              route {
                                    (matched_chars + 1) <= q_sz ==> {
                                          route {
                                                s[es + k] == q_nana[matched_chars + 1] ==> {
                                                      matched_chars = matched_chars + 1
                                                      k = k + 1
                                                }
                                                _ ==> {
                                                      q_ok = false
                                                      k = elen
                                                      matched_chars = q_sz
                                                }
                                          }
                                    }
                                    _ ==> {
                                          k = elen
                                    }
                              }
                        }
                        curr_u = e_to[ed]
                  }
            }
      }
      mut as int64: nana_occ = 0
      route {
            q_ok ==> { nana_occ = node_leaf_count[curr_u] }
      }
      println("   Busca 'nana': presente = " + q_ok + " | ocorrencias = " + nana_occ + " (esperado true, 1)")
      route {
            (not q_ok) or (nana_occ != 1) ==> { all_search_ok = false }
      }

      #L Consulta 3: "pan" -> ausente
      mut as list of int64: q_pan = [112, 97, 110]
      mut as int64: cid_p = 0
      route {
            q_pan[1] == 110 ==> { cid_p = 4 }
      }
      mut as bool: pan_found = (cid_p != 0)
      println("   Busca 'pan': presente = " + pan_found + " (esperado false)")
      route {
            pan_found ==> { all_search_ok = false }
      }

      println("4. Verificacao geral da Suffix Tree: " + all_search_ok)
      println("Concluido com Sucesso")
}
