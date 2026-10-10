#L ============================================================================
#L Algoritmo: Sparse Table (Tabela Esparsa para RMQ em O(1))
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N log N) pre-processamento | O(1) consulta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysSparseTable) {
      println("==================================================")
      println("  SciAlgo: Sparse Table")
      println("==================================================")

      mut as list of int64: arr = [3, 1, 5, 3, 4, 7, 6, 1]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Tabela esparsa linearizada: st[j][i] onde j in 0..3 (tamanho 2^j) e i in 1..N
      #L Indice plano: (j * n) + i
      mut as list of int64: st = []
      mut as int64: total_cells = 4 * n
      mut as int64: z = 1
      infinite (z <= total_cells) {
            st = listPushBack(st, 0)
            z = z + 1
      }

      #L Nivel j = 0: intervalos de tamanho 2^0 = 1 (copia do array)
      mut as int64: i = 1
      infinite (i <= n) {
            st[i] = arr[i]
            i = i + 1
      }

      #L Pre-computacao para niveis j = 1, 2, 3
      mut as int64: j = 1
      mut as int64: len_prev = 1 #L 2^(j-1)

      infinite (j <= 3) {
            mut as int64: len_cur = len_prev * 2 #L 2^j
            mut as int64: row_cur = j * n
            mut as int64: row_prev = (j - 1) * n

            i = 1
            infinite (i + len_cur - 1 <= n) {
                  mut as int64: v1 = st[row_prev + i]
                  mut as int64: v2 = st[row_prev + i + len_prev]
                  route {
                        v1 < v2 ==> {
                              st[row_cur + i] = v1
                        }
                        _ ==> {
                              st[row_cur + i] = v2
                        }
                  }
                  i = i + 1
            }

            len_prev = len_cur
            j = j + 1
      }
      println("2. Tabela esparsa construida em O(N log N)")

      #L Consultas de minimo em O(1): [1..5], [3..7], [1..8]
      mut as list of int64: q_l = [1, 3, 1]
      mut as list of int64: q_r = [5, 7, 8]
      mut as int64: num_q = 3

      mut as int64: q = 1
      infinite (q <= num_q) {
            mut as int64: l = q_l[q]
            mut as int64: r = q_r[q]
            mut as int64: q_len = r - l + 1

            #L Determina o maior k tal que 2^k <= q_len
            mut as int64: k = 0
            mut as int64: p2 = 1
            infinite (p2 * 2 <= q_len) {
                  p2 = p2 * 2
                  k = k + 1
            }

            mut as int64: offset = k * n
            mut as int64: left_val = st[offset + l]
            mut as int64: right_val = st[offset + r - p2 + 1]

            mut as int64: ans = left_val
            route {
                  right_val < left_val ==> {
                        ans = right_val
                  }
                  _ ==> {
                  }
            }

            println("3. Consulta [" + l + ".." + r + "]: Minimo = " + ans)
            q = q + 1
      }
}
