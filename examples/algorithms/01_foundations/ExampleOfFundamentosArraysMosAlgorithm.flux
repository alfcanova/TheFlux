#L ============================================================================
#L Algoritmo: Mo's Algorithm (Algoritmo de Mo para Consultas em Intervalos)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O((N + Q) * sqrt(N)) tempo | O(N + Q) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysMosAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Mo's Algorithm (Range Queries)")
      println("==================================================")

      mut as list of int64: arr = [1, 3, 1, 2, 3, 2, 1, 4]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Tamanho do bloco B = sqrt(N) ~ 2
      mut as int64: block_size = 2

      #L Consultas de quantidade de elementos distintos em [L, R]
      #L Q1 = [1, 4], Q2 = [2, 6], Q3 = [4, 8], Q4 = [3, 7]
      mut as list of int64: q_l = [1, 2, 4, 3]
      mut as list of int64: q_r = [4, 6, 8, 7]
      mut as list of int64: q_id = [1, 2, 3, 4]
      mut as int64: num_q = 4

      #L Ordenacao das consultas por (L /i B, R)
      mut as int64: a = 1
      infinite (a <= num_q) {
            mut as int64: b = a + 1
            infinite (b <= num_q) {
                  mut as int64: block_a = (q_l[a] - 1) /i block_size
                  mut as int64: block_b = (q_l[b] - 1) /i block_size

                  mut as bool: swap_needed = false
                  route {
                        block_b < block_a ==> {
                              swap_needed = true
                        }
                        block_b == block_a and q_r[b] < q_r[a] ==> {
                              swap_needed = true
                        }
                        _ ==> {
                        }
                  }

                  route {
                        swap_needed ==> {
                              mut as int64: tl = q_l[a]
                              q_l[a] = q_l[b]
                              q_l[b] = tl

                              mut as int64: tr = q_r[a]
                              q_r[a] = q_r[b]
                              q_r[b] = tr

                              mut as int64: tid = q_id[a]
                              q_id[a] = q_id[b]
                              q_id[b] = tid
                        }
                        _ ==> {
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      #L Frequencias dos valores no universo (valores de 1 a 4)
      mut as list of int64: freq = [0, 0, 0, 0, 0]
      mut as int64: distinct_count = 0

      mut as list of int64: answers = [0, 0, 0, 0, 0]
      mut as int64: cur_l = 1
      mut as int64: cur_r = 0

      #L Processamento com dois ponteiros
      mut as int64: qi = 1
      infinite (qi <= num_q) {
            mut as int64: target_l = q_l[qi]
            mut as int64: target_r = q_r[qi]

            #L Expande cur_r
            infinite (cur_r < target_r) {
                  cur_r = cur_r + 1
                  mut as int64: val_add = arr[cur_r]
                  route {
                        freq[val_add] == 0 ==> {
                              distinct_count = distinct_count + 1
                        }
                        _ ==> {
                        }
                  }
                  freq[val_add] = freq[val_add] + 1
            }

            #L Contrai cur_r
            infinite (cur_r > target_r) {
                  mut as int64: val_rem = arr[cur_r]
                  freq[val_rem] = freq[val_rem] - 1
                  route {
                        freq[val_rem] == 0 ==> {
                              distinct_count = distinct_count - 1
                        }
                        _ ==> {
                        }
                  }
                  cur_r = cur_r - 1
            }

            #L Expande cur_l (move para esquerda)
            infinite (cur_l > target_l) {
                  cur_l = cur_l - 1
                  mut as int64: val_l_add = arr[cur_l]
                  route {
                        freq[val_l_add] == 0 ==> {
                              distinct_count = distinct_count + 1
                        }
                        _ ==> {
                        }
                  }
                  freq[val_l_add] = freq[val_l_add] + 1
            }

            #L Contrai cur_l (move para direita)
            infinite (cur_l < target_l) {
                  mut as int64: val_l_rem = arr[cur_l]
                  freq[val_l_rem] = freq[val_l_rem] - 1
                  route {
                        freq[val_l_rem] == 0 ==> {
                              distinct_count = distinct_count - 1
                        }
                        _ ==> {
                        }
                  }
                  cur_l = cur_l + 1
            }

            answers[q_id[qi]] = distinct_count
            qi = qi + 1
      }

      println("2. Resultados das consultas (elementos distintos):")
      println("   Q1 [1..4]: " + answers[1] + " distintos (esperado: 3)")
      println("   Q2 [2..6]: " + answers[2] + " distintos (esperado: 3)")
      println("   Q3 [4..8]: " + answers[3] + " distintos (esperado: 4)")
      println("   Q4 [3..7]: " + answers[4] + " distintos (esperado: 3)")
}
