#L ============================================================================
#L Algoritmo: Longest Common Subsequence — LCS (Subsequência Comum Mais Longa)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaLongestCommonSubsequence) {
      println("==================================================")
      println("  SciAlgo: Longest Common Subsequence (LCS)")
      println("==================================================")

      mut as list of int64: a = [65, 66, 67, 68, 69]
      mut as list of int64: b = [65, 67, 69]
      mut as int64: m = listLength(a)
      mut as int64: n = listLength(b)

      mut as list of int64: dp_prev = [0, 0, 0, 0]
      mut as list of int64: dp_curr = [0, 0, 0, 0]

      mut as int64: i = 1
      infinite (i <= m) {
            mut as int64: j = 1
            infinite (j <= n) {
                  route {
                        a[i] == b[j] ==> {
                              dp_curr[j + 1] = dp_prev[j] + 1
                        }
                        _ ==> {
                              mut as int64: max_val = dp_prev[j + 1]
                              route {
                                    dp_curr[j] > max_val ==> { max_val = dp_curr[j] }
                                    _ ==> {}
                              }
                              dp_curr[j + 1] = max_val
                        }
                  }
                  j = j + 1
            }

            mut as int64: k = 1
            infinite (k <= n + 1) {
                  dp_prev[k] = dp_curr[k]
                  k = k + 1
            }
            i = i + 1
      }

      println("1. Tamanho da sequencia A: " + m)
      println("2. Tamanho da sequencia B: " + n)
      println("3. Comprimento da LCS: " + dp_prev[n + 1])
      println("4. LCS concluido com sucesso.")
}
