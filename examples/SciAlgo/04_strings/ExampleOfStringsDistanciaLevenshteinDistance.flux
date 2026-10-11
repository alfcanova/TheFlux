#L ============================================================================
#L Algoritmo: Levenshtein Distance (Distancia de Edicao DP)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaLevenshteinDistance) {
      println("==================================================")
      println("  SciAlgo: Levenshtein Distance")
      println("==================================================")

      #L S1: "KITTEN" -> [75, 73, 84, 84, 69, 78] (tam 6)
      #L S2: "SITTIN" -> [83, 73, 84, 84, 73, 78] (tam 6)
      mut as list of int64: s1 = [75, 73, 84, 84, 69, 78]
      mut as list of int64: s2 = [83, 73, 84, 84, 73, 78]
      mut as int64: m = listLength(s1)
      mut as int64: n = listLength(s2)

      #L Vetor DP para linha anterior (1-based: 1..n+1)
      mut as list of int64: dp_prev = [0, 1, 2, 3, 4, 5, 6]
      mut as list of int64: dp_curr = [0, 0, 0, 0, 0, 0, 0]

      mut as int64: i = 1
      infinite (i <= m) {
            dp_curr[1] = i
            mut as int64: j = 1
            infinite (j <= n) {
                  mut as int64: cost = 1
                  route {
                        s1[i] == s2[j] ==> { cost = 0 }
                        _ ==> {}
                  }

                  mut as int64: del_op = dp_prev[j + 1] + 1
                  mut as int64: ins_op = dp_curr[j] + 1
                  mut as int64: sub_op = dp_prev[j] + cost

                  mut as int64: menor = del_op
                  route {
                        ins_op < menor ==> { menor = ins_op }
                        _ ==> {}
                  }
                  route {
                        sub_op < menor ==> { menor = sub_op }
                        _ ==> {}
                  }

                  dp_curr[j + 1] = menor
                  j = j + 1
            }

            mut as int64: k = 1
            infinite (k <= n + 1) {
                  dp_prev[k] = dp_curr[k]
                  k = k + 1
            }
            i = i + 1
      }

      println("1. Tamanhos das cadeias: " + m + " e " + n)
      println("2. Distancia de Levenshtein calculada: " + dp_prev[n + 1])
      println("3. Levenshtein concluido com sucesso.")
}
