#L ============================================================================
#L Algoritmo: Sqrt Tree (Estrutura de Decomposicao Hierarquica para RMQ O(1))
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N log log N) ou O(N) | Consulta RMQ O(1) | Atualizacao O(sqrt(N))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSqrtTree) {
      println("==================================================")
      println("  SciAlgo: Sqrt Tree (Range Minimum Query O(1))")
      println("==================================================")

      #L Vetor original de tamanho N = 16
      mut as list of int64: arr = [12, 5, 8, 19, 3, 17, 24, 7, 15, 2, 9, 11, 6, 14, 20, 1]
      mut as int64: n = listLength(arr)
      mut as int64: block_size = 4
      mut as int64: num_blocks = 4

      println("1. Array de entrada (N = 16, 4 blocos de tamanho 4):")
      println("   " + arr)

      #L Estruturas do Sqrt Tree:
      #L pref[i]: menor elemento do inicio do bloco ate o indice i
      #L suff[i]: menor elemento do indice i ate o fim do bloco
      #L between[b1, b2]: menor elemento entre blocos b1 e b2 (achatado: (b1-1)*num_blocks + b2)
      mut as list of int64: pref = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: suff = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: between = [0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0]

      #L Construcao de prefixos e sufixos dentro de cada bloco
      mut as int64: b = 1
      infinite (b <= num_blocks) {
            mut as int64: b_start = ((b - 1) * block_size) + 1
            mut as int64: b_end = b * block_size

            #L Prefixo
            mut as int64: cur_min = arr[b_start]
            pref[b_start] = cur_min
            mut as int64: i = b_start + 1
            infinite (i <= b_end) {
                  route {
                        arr[i] < cur_min ==> { cur_min = arr[i] }
                  }
                  pref[i] = cur_min
                  i = i + 1
            }

            #L Sufixo
            cur_min = arr[b_end]
            suff[b_end] = cur_min
            mut as int64: j = b_end - 1
            infinite (j >= b_start) {
                  route {
                        arr[j] < cur_min ==> { cur_min = arr[j] }
                  }
                  suff[j] = cur_min
                  j = j - 1
            }

            #L between[b, b] = minimo do bloco b = suff[b_start]
            mut as int64: b_idx = ((b - 1) * num_blocks) + b
            between[b_idx] = suff[b_start]

            b = b + 1
      }

      #L Construcao da matriz between de blocos para intervalos maiores
      mut as int64: len = 2
      infinite (len <= num_blocks) {
            mut as int64: b1 = 1
            infinite (b1 <= (num_blocks - len + 1)) {
                  mut as int64: b2 = b1 + len - 1
                  mut as int64: idx_prev = ((b1 - 1) * num_blocks) + (b2 - 1)
                  mut as int64: idx_curr = ((b1 - 1) * num_blocks) + b2
                  mut as int64: idx_single = ((b2 - 1) * num_blocks) + b2

                  mut as int64: m1 = between[idx_prev]
                  mut as int64: m2 = between[idx_single]
                  mut as int64: m_comb = m1
                  route {
                        m2 < m_comb ==> { m_comb = m2 }
                  }
                  between[idx_curr] = m_comb
                  b1 = b1 + 1
            }
            len = len + 1
      }

      println("2. Sqrt Tree pre-processado com sucesso.")

      #L Consultas de teste RMQ (1-based)
      #L Teste 1: mesmo bloco [1..4] -> esperado 5
      #L Teste 2: blocos adjacentes [2..6] -> min(5,8,19, 3,17) -> esperado 3
      #L Teste 3: blocos distantes [5..12] -> min(3..11) -> esperado 2
      #L Teste 4: intervalo total [1..16] -> esperado 1
      #L Teste 5: dentro de bloco [9..11] -> esperado 2

      mut as list of int64: q_l = [1, 2, 5, 1, 9]
      mut as list of int64: q_r = [4, 6, 12, 16, 11]
      mut as list of int64: q_exp = [5, 3, 2, 1, 2]
      mut as int64: num_queries = listLength(q_l)

      println("3. Executando consultas Range Minimum Query (RMQ):")
      mut as bool: all_correct = true
      mut as int64: q = 1
      infinite (q <= num_queries) {
            mut as int64: l = q_l[q]
            mut as int64: r = q_r[q]
            mut as int64: ans = 0

            mut as int64: b_l = ((l - 1) /i block_size) + 1
            mut as int64: b_r = ((r - 1) /i block_size) + 1

            route {
                  b_l == b_r ==> {
                        #L Dentro do mesmo bloco: varredura direta O(sqrt(N))
                        mut as int64: min_local = arr[l]
                        mut as int64: k = l + 1
                        infinite (k <= r) {
                              route {
                                    arr[k] < min_local ==> { min_local = arr[k] }
                              }
                              k = k + 1
                        }
                        ans = min_local
                  }
                  (b_l + 1) == b_r ==> {
                        #L Blocos adjacentes: min(suff[l], pref[r])
                        mut as int64: m_left = suff[l]
                        mut as int64: m_right = pref[r]
                        ans = m_left
                        route {
                              m_right < ans ==> { ans = m_right }
                        }
                  }
                  _ ==> {
                        #L Blocos separados: min(suff[l], between[b_l+1, b_r-1], pref[r])
                        mut as int64: m_left = suff[l]
                        mut as int64: m_right = pref[r]
                        mut as int64: mid_b1 = b_l + 1
                        mut as int64: mid_b2 = b_r - 1
                        mut as int64: mid_idx = ((mid_b1 - 1) * num_blocks) + mid_b2
                        mut as int64: m_mid = between[mid_idx]

                        ans = m_left
                        route {
                              m_mid < ans ==> { ans = m_mid }
                        }
                        route {
                              m_right < ans ==> { ans = m_right }
                        }
                  }
            }

            mut as bool: ok = (ans == q_exp[q])
            route {
                  not ok ==> { all_correct = false }
            }
            println("   RMQ(" + l + ", " + r + ") = " + ans + " [esperado " + q_exp[q] + "] -> " + ok)
            q = q + 1
      }

      #L 4. Atualizacao pontual (Update) e re-consulta
      #L Modificando indice 10: de 2 para 25
      println("4. Atualizando elemento no indice 10: 2 -> 25...")
      arr[10] = 25
      mut as int64: b_upd = ((10 - 1) /i block_size) + 1
      mut as int64: up_start = ((b_upd - 1) * block_size) + 1
      mut as int64: up_end = b_upd * block_size

      #L Reconstroi bloco 3
      mut as int64: c_min = arr[up_start]
      pref[up_start] = c_min
      mut as int64: ui = up_start + 1
      infinite (ui <= up_end) {
            route {
                  arr[ui] < c_min ==> { c_min = arr[ui] }
            }
            pref[ui] = c_min
            ui = ui + 1
      }
      c_min = arr[up_end]
      suff[up_end] = c_min
      mut as int64: uj = up_end - 1
      infinite (uj >= up_start) {
            route {
                  arr[uj] < c_min ==> { c_min = arr[uj] }
            }
            suff[uj] = c_min
            uj = uj - 1
      }
      between[((b_upd - 1) * num_blocks) + b_upd] = suff[up_start]

      #L Reconstroi between
      len = 2
      infinite (len <= num_blocks) {
            mut as int64: b1 = 1
            infinite (b1 <= (num_blocks - len + 1)) {
                  mut as int64: b2 = b1 + len - 1
                  mut as int64: idx_prev = ((b1 - 1) * num_blocks) + (b2 - 1)
                  mut as int64: idx_curr = ((b1 - 1) * num_blocks) + b2
                  mut as int64: idx_single = ((b2 - 1) * num_blocks) + b2

                  mut as int64: m1 = between[idx_prev]
                  mut as int64: m2 = between[idx_single]
                  mut as int64: m_comb = m1
                  route {
                        m2 < m_comb ==> { m_comb = m2 }
                  }
                  between[idx_curr] = m_comb
                  b1 = b1 + 1
            }
            len = len + 1
      }

      #L Re-consulta no intervalo [5..12] onde o antigo minimo era 2
      #L Agora o menor elemento em [5..12] (bloco 2 e 3) e 3 (em arr[5])
      mut as int64: post_l = 5
      mut as int64: post_r = 12
      mut as int64: post_ans = suff[post_l]
      mut as int64: r_part = pref[post_r]
      route {
            r_part < post_ans ==> { post_ans = r_part }
      }
      println("   Nova consulta RMQ(5, 12) pos-atualizacao = " + post_ans + " (esperado 3)")
      route {
            post_ans != 3 ==> { all_correct = false }
      }

      println("5. Verificacao geral do Sqrt Tree: " + all_correct)
      println("Concluido com Sucesso")
}
