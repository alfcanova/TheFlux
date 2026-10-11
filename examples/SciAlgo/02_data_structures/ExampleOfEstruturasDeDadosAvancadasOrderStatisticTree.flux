#L ============================================================================
#L Algoritmo: Order Statistic Tree (Arvore com Estatistica de Ordem Select/Rank)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca, select(k) e rank(x) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasOrderStatisticTree) {
      println("==================================================")
      println("  SciAlgo: Order Statistic Tree (Rank & Select)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL)
      mut as list of int64: key = [0]
      mut as list of int64: sz = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Chaves a inserir: 20, 10, 40, 5, 15, 30, 50
      mut as list of int64: in_keys = [20, 10, 40, 5, 15, 30, 50]
      mut as int64: n = listLength(in_keys)

      println("1. Inserindo " + n + " chaves na Order Statistic Tree:")

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: k = in_keys[i]

            key = listPushBack(key, k)
            sz = listPushBack(sz, 1)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: node = listLength(key) - 1

            route {
                  root == 0 ==> {
                        root = node
                  }
                  _ ==> {
                        mut as int64: curr = root
                        mut as list of int64: path = []

                        infinite (curr != 0) {
                              path = listPushBack(path, curr)
                              route {
                                    k < key[curr] ==> {
                                          route {
                                                left_ch[curr] == 0 ==> {
                                                      left_ch[curr] = node
                                                      curr = 0
                                                }
                                                _ ==> {
                                                      curr = left_ch[curr]
                                                }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                right_ch[curr] == 0 ==> {
                                                      right_ch[curr] = node
                                                      curr = 0
                                                }
                                                _ ==> {
                                                      curr = right_ch[curr]
                                                }
                                          }
                                    }
                              }
                        }

                        #L Sobe pelo caminho atualizando sz[p] = 1 + sz[left] + sz[right]
                        mut as int64: p_idx = listLength(path)
                        infinite (p_idx >= 1) {
                              mut as int64: p = path[p_idx]
                              mut as int64: l = left_ch[p]
                              mut as int64: r = right_ch[p]
                              mut as int64: sl = 0
                              mut as int64: sr = 0
                              route { l != 0 ==> { sl = sz[l] } }
                              route { r != 0 ==> { sr = sz[r] } }
                              sz[p] = sl + sr + 1
                              p_idx = p_idx - 1
                        }
                  }
            }
            println("   Inserido " + k + " (tamanho da subarvore raiz: " + sz[root] + ")")
            i = i + 1
      }

      println("2. Raiz da arvore: no " + root + " (chave = " + key[root] + ", tamanho total = " + sz[root] + ")")

      #L Consulta SELECT(k): encontra o k-esimo menor elemento
      #L Ordem ordenada dos elementos: 5, 10, 15, 20, 30, 40, 50
      #L k=1 -> 5, k=3 -> 15, k=6 -> 40
      println("3. Executando operacoes SELECT(k):")
      mut as list of int64: k_queries = [1, 3, 6]
      mut as list of int64: select_results = []
      mut as int64: qi = 1
      infinite (qi <= listLength(k_queries)) {
            mut as int64: target_k = k_queries[qi]
            mut as int64: curr_sel = root
            mut as int64: k_rem = target_k

            infinite (curr_sel != 0) {
                  mut as int64: l = left_ch[curr_sel]
                  mut as int64: sl = 0
                  route { l != 0 ==> { sl = sz[l] } }
                  mut as int64: rk = sl + 1

                  route {
                        k_rem == rk ==> {
                              select_results = listPushBack(select_results, key[curr_sel])
                              println("   SELECT(" + target_k + "): chave encontrada = " + key[curr_sel])
                              break
                        }
                        k_rem < rk ==> {
                              curr_sel = left_ch[curr_sel]
                        }
                        _ ==> {
                              k_rem = k_rem - rk
                              curr_sel = right_ch[curr_sel]
                        }
                  }
            }
            qi = qi + 1
      }

      #L Consulta RANK(x): encontra a posicao ordenada da chave x
      #L x=30 -> rank deve ser 5 (chaves menores: 5, 10, 15, 20)
      println("4. Executando operacao RANK(x) para x = 30:")
      mut as int64: rank_x = 0
      mut as int64: c_rnk = root
      mut as int64: target_x = 30

      infinite (c_rnk != 0) {
            route {
                  target_x == key[c_rnk] ==> {
                        mut as int64: l = left_ch[c_rnk]
                        mut as int64: sl = 0
                        route { l != 0 ==> { sl = sz[l] } }
                        rank_x = rank_x + sl + 1
                        break
                  }
                  target_x < key[c_rnk] ==> {
                        c_rnk = left_ch[c_rnk]
                  }
                  _ ==> {
                        mut as int64: l = left_ch[c_rnk]
                        mut as int64: sl = 0
                        route { l != 0 ==> { sl = sz[l] } }
                        rank_x = rank_x + sl + 1
                        c_rnk = right_ch[c_rnk]
                  }
            }
      }
      println("   RANK(30): posicao = " + rank_x)

      println("5. Validacao: " + (select_results[1] == 5 and select_results[2] == 15 and select_results[3] == 40 and rank_x == 5))
      println("==================================================")
}
