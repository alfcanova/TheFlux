#L ============================================================================
#L Algoritmo: BLAST (Basic Local Alignment Search Tool)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(W * |Q| + |D|) tempo heuristico | O(|Q|) espaco para indice de k-mers
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaBLAST) {
      println("==================================================")
      println("  SciAlgo: BLAST (Basic Local Alignment Search Tool)")
      println("==================================================")

      #L Mapeamento de Nucleotideos: 1='A', 2='C', 3='G', 4='T'
      #L Query Q:   "AGCTGAT" -> [1, 3, 2, 4, 3, 1, 4] (tam 7)
      #L Target D:  "TTAGCTGATTC" -> [4, 4, 1, 3, 2, 4, 3, 1, 4, 4, 2] (tam 11)
      mut as list of int64: query = [1, 3, 2, 4, 3, 1, 4]
      mut as int64: q_len = 7

      mut as list of int64: target = [4, 4, 1, 3, 2, 4, 3, 1, 4, 4, 2]
      mut as int64: t_len = 11

      mut as int64: word_size = 3
      mut as int64: score_match = 2
      mut as int64: penalty_mismatch = -1
      mut as int64: dropoff_x = 3

      println("1. Parametros e Sequencias de Entrada:")
      println("   Query  (Q) [tam " + q_len + "]: AGCTGAT")
      println("   Target (D) [tam " + t_len + "]: TTAGCTGATTC")
      println("   Word size W = " + word_size + " | Match = +" + score_match + " | Mismatch = " + penalty_mismatch + " | Dropoff X = " + dropoff_x)

      println("==================================================")
      println("2. Fase de Indexacao de Sementes (K-mers da Query):")

      #L Gera hash para cada k-mer da query: hash = c1*25 + c2*5 + c3
      mut as list of int64: q_hashes = []
      mut as list of int64: q_positions = []
      mut as int64: i = 1
      mut as int64: max_q_start = q_len - word_size + 1
      infinite (i <= max_q_start) {
            mut as int64: h = (query[i] * 25) + (query[i + 1] * 5) + query[i + 2]
            q_hashes = listPushBack(q_hashes, h)
            q_positions = listPushBack(q_positions, i)
            println("   K-mer Q[" + i + ".." + (i + 2) + "] -> Hash: " + h)
            i = i + 1
      }

      println("==================================================")
      println("3. Varredura no Alvo e Deteccao de Hits:")

      mut as int64: best_hsp_score = 0
      mut as int64: best_q_start = 0
      mut as int64: best_t_start = 0
      mut as int64: best_hsp_len = 0

      mut as int64: j = 1
      mut as int64: max_t_start = t_len - word_size + 1
      infinite (j <= max_t_start) {
            mut as int64: th = (target[j] * 25) + (target[j + 1] * 5) + target[j + 2]

            #L Busca exata na lista de sementes da query
            mut as int64: k = 1
            mut as int64: n_seeds = listLength(q_hashes)
            infinite (k <= n_seeds) {
                  route {
                        q_hashes[k] == th ==> {
                              mut as int64: q_hit = q_positions[k]
                              mut as int64: t_hit = j
                              println("   Hit encontrado: Query pos " + q_hit + " <=> Target pos " + t_hit + " (Hash: " + th + ")")

                              #L 4. Extensao Bidirecional sem gaps (Extension Phase)
                              #L Inicializa com a pontuacao da semente
                              mut as int64: seed_score = word_size * score_match
                              mut as int64: cur_score = seed_score
                              mut as int64: max_score = seed_score

                              #L Extensao para a esquerda
                              mut as int64: ext_l_q = q_hit - 1
                              mut as int64: ext_l_t = t_hit - 1
                              mut as int64: stop_l = 0
                              infinite (ext_l_q >= 1 and ext_l_t >= 1 and stop_l == 0) {
                                    route {
                                          query[ext_l_q] == target[ext_l_t] ==> {
                                                cur_score = cur_score + score_match
                                          }
                                          _ ==> {
                                                cur_score = cur_score + penalty_mismatch
                                          }
                                    }
                                    route {
                                          cur_score > max_score ==> { max_score = cur_score }
                                          (max_score - cur_score) >= dropoff_x ==> { stop_l = 1 }
                                          _ ==> {}
                                    }
                                    ext_l_q = ext_l_q - 1
                                    ext_l_t = ext_l_t - 1
                              }

                              #L Extensao para a direita
                              mut as int64: ext_r_q = q_hit + word_size
                              mut as int64: ext_r_t = t_hit + word_size
                              mut as int64: stop_r = 0
                              infinite (ext_r_q <= q_len and ext_r_t <= t_len and stop_r == 0) {
                                    route {
                                          query[ext_r_q] == target[ext_r_t] ==> {
                                                cur_score = cur_score + score_match
                                          }
                                          _ ==> {
                                                cur_score = cur_score + penalty_mismatch
                                          }
                                    }
                                    route {
                                          cur_score > max_score ==> { max_score = cur_score }
                                          (max_score - cur_score) >= dropoff_x ==> { stop_r = 1 }
                                          _ ==> {}
                                    }
                                    ext_r_q = ext_r_q + 1
                                    ext_r_t = ext_r_t + 1
                              }

                              mut as int64: hsp_len = (ext_r_q - 1) - (ext_l_q + 1) + 1
                              println("      Extensao concluida -> Escore HSP: " + max_score + " | Comprimento: " + hsp_len)

                              route {
                                    max_score > best_hsp_score ==> {
                                          best_hsp_score = max_score
                                          best_q_start = ext_l_q + 1
                                          best_t_start = ext_l_t + 1
                                          best_hsp_len = hsp_len
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }
            j = j + 1
      }

      println("==================================================")
      println("4. Resultado do Alinhamento Local BLAST (Melhor HSP):")
      println("   Escore Otimo (Bit Score proxy): " + best_hsp_score)
      println("   Coordenadas Query:  [" + best_q_start + " .. " + (best_q_start + best_hsp_len - 1) + "]")
      println("   Coordenadas Target: [" + best_t_start + " .. " + (best_t_start + best_hsp_len - 1) + "]")
      println("   Comprimento do Alinhamento: " + best_hsp_len + " nucleotideos")
      println("   BLAST concluido com sucesso!")
      println("==================================================")
}
