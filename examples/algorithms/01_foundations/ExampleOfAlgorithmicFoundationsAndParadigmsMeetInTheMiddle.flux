#L ============================================================================
#L Algoritmo: Meet-in-the-Middle (Encontro no Meio)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(2^(N/2) * log(2^(N/2))) tempo | O(2^(N/2)) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsMeetInTheMiddle) {
      println("==================================================")
      println("  SciAlgo: Meet-in-the-Middle (Subset Sum)")
      println("==================================================")

      #L Vetor com N = 8 elementos
      mut as list of int64: arr = [3, 34, 4, 12, 5, 2, 7, 9]
      mut as int64: target = 24
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = " + n + "): " + arr)
      println("2. Soma alvo: " + target)

      #L Particao em duas metades de 4 elementos cada
      mut as list of int64: left_arr = [3, 34, 4, 12]
      mut as list of int64: right_arr = [5, 2, 7, 9]
      mut as int64: n_l = listLength(left_arr)
      mut as int64: n_r = listLength(right_arr)

      #L Gera todas as 2^4 = 16 somas da metade esquerda
      mut as list of int64: sums_l = [0]
      mut as int64: li = 1
      infinite (li <= n_l) {
            mut as int64: val = left_arr[li]
            mut as int64: cur_len = listLength(sums_l)
            mut as int64: idx = 1
            infinite (idx <= cur_len) {
                  sums_l = listPushBack(sums_l, sums_l[idx] + val)
                  idx = idx + 1
            }
            li = li + 1
      }

      #L Gera todas as 2^4 = 16 somas da metade direita
      mut as list of int64: sums_r = [0]
      mut as int64: ri = 1
      infinite (ri <= n_r) {
            mut as int64: val = right_arr[ri]
            mut as int64: cur_len = listLength(sums_r)
            mut as int64: idx = 1
            infinite (idx <= cur_len) {
                  sums_r = listPushBack(sums_r, sums_r[idx] + val)
                  idx = idx + 1
            }
            ri = ri + 1
      }

      #L Ordena sums_r para permitir busca binaria
      mut as int64: len_r = listLength(sums_r)
      mut as int64: si = 2
      infinite (si <= len_r) {
            mut as int64: key = sums_r[si]
            mut as int64: sj = si - 1
            mut as bool: sorting = true
            infinite (sorting) {
                  route {
                        sj >= 1 ==> {
                              route {
                                    sums_r[sj] > key ==> {
                                          sums_r[sj + 1] = sums_r[sj]
                                          sj = sj - 1
                                    }
                                    _ ==> {
                                          sorting = false
                                    }
                              }
                        }
                        _ ==> {
                              sorting = false
                        }
                  }
            }
            sums_r[sj + 1] = key
            si = si + 1
      }

      #L Busca no meio: para cada sl in sums_l, busca binaria por (target - sl) in sums_r
      mut as int64: len_l = listLength(sums_l)
      mut as bool: found = false
      mut as int64: match_l = 0
      mut as int64: match_r = 0
      mut as int64: bi = 1

      infinite (bi <= len_l and not found) {
            mut as int64: sl = sums_l[bi]
            mut as int64: complement = target - sl

            #L Busca binaria em sums_r
            mut as int64: low = 1
            mut as int64: high = len_r
            infinite (low <= high and not found) {
                  mut as int64: mid = (low + high) /i 2
                  route {
                        sums_r[mid] == complement ==> {
                              found = true
                              match_l = sl
                              match_r = complement
                        }
                        sums_r[mid] < complement ==> {
                              low = mid + 1
                        }
                        _ ==> {
                              high = mid - 1
                        }
                  }
            }
            bi = bi + 1
      }

      println("3. Somas geradas na esquerda: " + len_l)
      println("4. Somas geradas na direita: " + len_r)
      route {
            found ==> {
                  println("5. Subconjunto com soma " + target + " ENCONTRADO!")
                  println("   Soma Esquerda (" + match_l + ") + Soma Direita (" + match_r + ") = " + target)
            }
            _ ==> {
                  println("5. Subconjunto NAO encontrado")
            }
      }
      println("Concluido com Sucesso")
}
