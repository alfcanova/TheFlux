#L ============================================================================
#L Algoritmo: Patience Sort (Ordenação por Paciência e Cálculo de LIS)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) criação das pilhas | O(N log K) mesclagem k-way
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortPatience) {
      println("==================================================")
      println("  SciAlgo: Patience Sort (Pilhas de Cartas e LIS)")
      println("==================================================")

      mut as list of int64: arr = [22, 15, 36, 44, 10, 3, 25, 18, 8, 40, 12, 30]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 12): " + arr)

      mut as int64: max_cap = 16
      mut as int64: num_piles = 0

      #L Pilhas armazenadas em matriz plana (16 x 16)
      mut as list of int64: pile_cards = []
      mut as int64: total_grid = max_cap * max_cap
      mut as int64: gi = 1
      infinite (gi <= total_grid) {
            pile_cards = listPushBack(pile_cards, 0)
            gi = gi + 1
      }

      mut as list of int64: pile_sizes = []
      mut as list of int64: pile_tops = []
      gi = 1
      infinite (gi <= max_cap) {
            pile_sizes = listPushBack(pile_sizes, 0)
            pile_tops = listPushBack(pile_tops, 0)
            gi = gi + 1
      }

      #L Distribuição gananciosa com Busca Binária
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: card = arr[i]

            #L Busca binária pela pilha mais à esquerda com topo >= card
            mut as int64: l = 1
            mut as int64: r = num_piles
            mut as int64: dest = 0

            infinite (l <= r) {
                  mut as int64: mid = (l + r) /i 2
                  route {
                        pile_tops[mid] >= card ==> {
                              dest = mid
                              r = mid - 1
                        }
                        _ ==> {
                              l = mid + 1
                        }
                  }
            }

            route {
                  dest == 0 ==> {
                        #L Cria uma nova pilha à direita
                        num_piles = num_piles + 1
                        dest = num_piles
                  }
            }

            #L Insere a carta no topo da pilha escolhida
            mut as int64: cur_sz = pile_sizes[dest] + 1
            pile_sizes[dest] = cur_sz
            mut as int64: c_idx = (dest - 1) * max_cap + cur_sz
            pile_cards[c_idx] = card
            pile_tops[dest] = card

            i = i + 1
      }

      println("2. Total de pilhas criadas (tamanho do LIS): " + num_piles)

      #L Exibe distribuição das cartas em cada pilha
      mut as int64: p = 1
      infinite (p <= num_piles) {
            mut as list of int64: p_view = []
            mut as int64: c = 1
            mut as int64: s = pile_sizes[p]
            infinite (c <= s) {
                  mut as int64: c_idx = (p - 1) * max_cap + c
                  p_view = listPushBack(p_view, pile_cards[c_idx])
                  c = c + 1
            }
            println("   Pilha " + p + ": " + p_view)
            p = p + 1
      }

      #L Fase de mesclagem (k-way merge)
      mut as list of int64: output = []
      mut as int64: remaining = n

      infinite (remaining > 0) {
            #L Localiza a pilha ativa com o menor topo
            mut as int64: best_p = 0
            mut as int64: best_val = 999999999
            p = 1
            infinite (p <= num_piles) {
                  route {
                        pile_sizes[p] > 0 ==> {
                              route {
                                    pile_tops[p] < best_val ==> {
                                          best_val = pile_tops[p]
                                          best_p = p
                                    }
                              }
                        }
                  }
                  p = p + 1
            }

            #L Remove a menor carta do topo da pilha selecionada
            output = listPushBack(output, best_val)
            mut as int64: new_sz = pile_sizes[best_p] - 1
            pile_sizes[best_p] = new_sz
            route {
                  new_sz > 0 ==> {
                        mut as int64: c_idx = (best_p - 1) * max_cap + new_sz
                        pile_tops[best_p] = pile_cards[c_idx]
                  }
                  _ ==> {
                        pile_tops[best_p] = 999999999
                  }
            }

            remaining = remaining - 1
      }

      #L Copia resultado para o vetor original
      i = 1
      infinite (i <= n) {
            arr[i] = output[i]
            i = i + 1
      }

      println("3. Vetor ordenado pelo Patience Sort: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  arr[vi] > arr[vi + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            vi = vi + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
