#L ============================================================================
#L Algoritmo: Bead Sort (Ordenação por Gravidade / Abacus Beads)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N * Max) em software | O(1) analógico em hardware | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortBead) {
      println("==================================================")
      println("  SciAlgo: Bead Sort (Ordenacao por Gravidade)")
      println("==================================================")

      mut as list of int64: arr = [5, 3, 1, 7, 4, 2, 6, 3]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Localiza o elemento máximo para determinar largura da grade
      mut as int64: max_val = arr[1]
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  arr[i] > max_val ==> {
                        max_val = arr[i]
                  }
            }
            i = i + 1
      }
      println("2. Total de elementos N: " + n + ", Altura maxima: " + max_val)

      #L Aloca matriz plana (N x max_val) de contas
      mut as int64: grid_size = n * max_val
      mut as list of int64: grid = []
      i = 1
      infinite (i <= grid_size) {
            grid = listPushBack(grid, 0)
            i = i + 1
      }

      #L Posiciona as contas nas hastes horizontais
      mut as int64: r = 1
      infinite (r <= n) {
            mut as int64: beads = arr[r]
            mut as int64: c = 1
            infinite (c <= beads) {
                  mut as int64: idx = (r - 1) * max_val + c
                  grid[idx] = 1
                  c = c + 1
            }
            r = r + 1
      }
      println("3. Grade inicial de contas montada com sucesso.")

      #L Simula a gravidade: as contas caem verticalmente em cada coluna
      mut as int64: col = 1
      infinite (col <= max_val) {
            #L Conta quantas contas existem na coluna atual
            mut as int64: count_col = 0
            r = 1
            infinite (r <= n) {
                  mut as int64: idx = (r - 1) * max_val + col
                  route {
                        grid[idx] == 1 ==> {
                              count_col = count_col + 1
                        }
                  }
                  r = r + 1
            }

            #L Deixa as contas caírem para a base da grade
            r = 1
            infinite (r <= n) {
                  mut as int64: idx = (r - 1) * max_val + col
                  route {
                        r <= (n - count_col) ==> {
                              grid[idx] = 0
                        }
                        _ ==> {
                              grid[idx] = 1
                        }
                  }
                  r = r + 1
            }
            col = col + 1
      }
      println("4. Gravidade aplicada em todas as colunas.")

      #L Reconstroi o vetor lendo a quantidade de contas por linha (topo para base)
      r = 1
      infinite (r <= n) {
            mut as int64: row_beads = 0
            mut as int64: c = 1
            infinite (c <= max_val) {
                  mut as int64: idx = (r - 1) * max_val + c
                  route {
                        grid[idx] == 1 ==> {
                              row_beads = row_beads + 1
                        }
                  }
                  c = c + 1
            }
            arr[r] = row_beads
            r = r + 1
      }

      println("5. Vetor reconstruido e ordenado: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      i = 1
      infinite (i < n) {
            route {
                  arr[i] > arr[i + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            i = i + 1
      }
      println("6. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
