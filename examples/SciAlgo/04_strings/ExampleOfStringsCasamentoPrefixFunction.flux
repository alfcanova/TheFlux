#L ============================================================================
#L Algoritmo: Prefix Function (Função de Prefixo / LPS Array)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo amortizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoPrefixFunction) {
      println("==================================================")
      println("  SciAlgo: Prefix Function (Longest Proper Prefix/Suffix)")
      println("==================================================")

      mut as list of int64: s = [65, 66, 65, 66, 65]
      mut as int64: n = listLength(s)
      mut as list of int64: pi = [0, 0, 0, 0, 0]

      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: j = pi[i - 1]
            infinite (j > 0 and s[i] != s[j + 1]) {
                  j = pi[j]
            }
            route {
                  s[i] == s[j + 1] ==> { j = j + 1 }
                  _ ==> {}
            }
            pi[i] = j
            i = i + 1
      }

      println("1. String de tamanho: " + n)
      println("2. Vetor Pi: [" + pi[1] + ", " + pi[2] + ", " + pi[3] + ", " + pi[4] + ", " + pi[5] + "]")
      println("3. Prefix Function concluido com sucesso.")
}
