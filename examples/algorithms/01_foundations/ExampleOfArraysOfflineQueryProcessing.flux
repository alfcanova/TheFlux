#L ============================================================================
#L Algoritmo: Offline Query Processing (Processamento Offline com Fenwick Tree)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O((N + Q) * log N) tempo | O(N + Q) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysOfflineQueryProcessing) {
      println("==================================================")
      println("  SciAlgo: Offline Query Processing (BIT / Fenwick)")
      println("==================================================")

      mut as list of int64: arr = [1, 2, 1, 3, 2, 1]
      mut as int64: n = listLength(arr)
      println("1. Array de entrada (N = " + n + "): " + arr)

      #L Consultas de contagem de elementos distintos em [L, R]
      #L Q1 = [1, 3], Q2 = [2, 5], Q3 = [1, 6]
      mut as list of int64: q_l = [1, 2, 1]
      mut as list of int64: q_r = [3, 5, 6]
      mut as list of int64: q_orig_id = [1, 2, 3]
      mut as int64: num_q = 3

      #L Ordena consultas por R crescente
      mut as int64: a = 1
      infinite (a <= num_q) {
            mut as int64: b = a + 1
            infinite (b <= num_q) {
                  route {
                        q_r[b] < q_r[a] ==> {
                              mut as int64: tr = q_r[a]
                              q_r[a] = q_r[b]
                              q_r[b] = tr

                              mut as int64: tl = q_l[a]
                              q_l[a] = q_l[b]
                              q_l[b] = tl

                              mut as int64: tid = q_orig_id[a]
                              q_orig_id[a] = q_orig_id[b]
                              q_orig_id[b] = tid
                        }
                        _ ==> {
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      #L Estrutura Fenwick Tree (Binary Indexed Tree) de tamanho N+1
      mut as list of int64: bit = [0, 0, 0, 0, 0, 0, 0]

      #L Rastreamento da ultima posicao de cada valor (valores 1..3)
      mut as list of int64: last_pos = [0, 0, 0, 0]
      mut as list of int64: results = [0, 0, 0, 0]

      mut as int64: q_idx = 1
      mut as int64: i = 1

      infinite (i <= n) {
            mut as int64: val = arr[i]

            #L Se o valor ja apareceu antes, remove a ocorrencia anterior da BIT
            mut as int64: prev = last_pos[val]
            route {
                  prev > 0 ==> {
                        #L BIT update (prev, -1)
                        mut as int64: idx_u1 = prev
                        infinite (idx_u1 <= n) {
                              bit[idx_u1] = bit[idx_u1] - 1
                              mut as int64: lsb1 = 1
                              infinite ((idx_u1 /r (lsb1 * 2)) == 0 and lsb1 < 16) {
                                    lsb1 = lsb1 * 2
                              }
                              idx_u1 = idx_u1 + lsb1
                        }
                  }
                  _ ==> {
                  }
            }

            #L Adiciona a nova posicao mais a direita na BIT (+1)
            mut as int64: idx_u2 = i
            infinite (idx_u2 <= n) {
                  bit[idx_u2] = bit[idx_u2] + 1
                  mut as int64: lsb2 = 1
                  infinite ((idx_u2 /r (lsb2 * 2)) == 0 and lsb2 < 16) {
                        lsb2 = lsb2 * 2
                  }
                  idx_u2 = idx_u2 + lsb2
            }
            last_pos[val] = i

            #L Responde todas as consultas que terminam no indice i
            mut as bool: match_q = true
            infinite (q_idx <= num_q and match_q) {
                  route {
                        q_r[q_idx] == i ==> {
                              mut as int64: ql = q_l[q_idx]
                              mut as int64: qr = q_r[q_idx]

                              #L BIT query(qr)
                              mut as int64: sum_r = 0
                              mut as int64: qi_r = qr
                              infinite (qi_r > 0) {
                                    sum_r = sum_r + bit[qi_r]
                                    mut as int64: lsb_r = 1
                                    infinite ((qi_r /r (lsb_r * 2)) == 0 and lsb_r < 16) {
                                          lsb_r = lsb_r * 2
                                    }
                                    qi_r = qi_r - lsb_r
                              }

                              #L BIT query(ql - 1)
                              mut as int64: sum_l = 0
                              mut as int64: qi_l = ql - 1
                              infinite (qi_l > 0) {
                                    sum_l = sum_l + bit[qi_l]
                                    mut as int64: lsb_l = 1
                                    infinite ((qi_l /r (lsb_l * 2)) == 0 and lsb_l < 16) {
                                          lsb_l = lsb_l * 2
                                    }
                                    qi_l = qi_l - lsb_l
                              }

                              results[q_orig_id[q_idx]] = sum_r - sum_l
                              q_idx = q_idx + 1
                        }
                        _ ==> {
                              match_q = false
                        }
                  }
            }

            i = i + 1
      }

      println("2. Respostas offline ordenadas pelo ID original:")
      println("   Q1 [1..3]: " + results[1] + " distintos (esperado: 2 -> {1, 2})")
      println("   Q2 [2..5]: " + results[2] + " distintos (esperado: 3 -> {2, 1, 3})")
      println("   Q3 [1..6]: " + results[3] + " distintos (esperado: 3 -> {1, 2, 3})")
}
