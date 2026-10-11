#L ============================================================================
#L Algoritmo: Range Minimum Query (RMQ - Consulta de Minimo em Intervalo)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N log N) pre-processamento | O(1) consulta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysRangeMinimumQuery) {
      println("==================================================")
      println("  SciAlgo: Range Minimum Query (RMQ)")
      println("==================================================")

      mut as list of int64: arr = [18, 17, 13, 19, 15, 11, 20, 12, 33, 25]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Construcao da Sparse Table para RMQ
      #L K = 4 niveis (2^0, 2^1, 2^2, 2^3)
      mut as list of int64: st = []
      mut as int64: z = 1
      infinite (z <= 4 * n) {
            st = listPushBack(st, 0)
            z = z + 1
      }

      mut as int64: i = 1
      infinite (i <= n) {
            st[i] = arr[i]
            i = i + 1
      }

      mut as int64: j = 1
      mut as int64: len_prev = 1
      infinite (j <= 3) {
            mut as int64: len_cur = len_prev * 2
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

      #L Bateria de consultas RMQ
      mut as list of int64: ql = [1, 4, 8, 1]
      mut as list of int64: qr = [5, 8, 10, 10]
      mut as int64: num_q = 4

      mut as int64: q = 1
      infinite (q <= num_q) {
            mut as int64: l = ql[q]
            mut as int64: r = qr[q]
            mut as int64: q_len = r - l + 1

            mut as int64: k = 0
            mut as int64: p2 = 1
            infinite (p2 * 2 <= q_len) {
                  p2 = p2 * 2
                  k = k + 1
            }

            mut as int64: offset = k * n
            mut as int64: v_l = st[offset + l]
            mut as int64: v_r = st[offset + r - p2 + 1]

            mut as int64: ans = v_l
            route {
                  v_r < v_l ==> {
                        ans = v_r
                  }
                  _ ==> {
                  }
            }

            println("2. RMQ [" + l + ".." + r + "]: Minimo = " + ans)
            q = q + 1
      }
}
