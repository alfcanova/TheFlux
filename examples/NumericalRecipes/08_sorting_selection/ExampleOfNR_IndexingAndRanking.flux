#L ============================================================================
#L Algoritmo: Indexing & Ranking (Ordenacao Indireta por Indices e Postos)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Gera tabela de indices ordenados (Indexx) e postos estatisticos (Rank).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_IndexingAndRanking) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_IndexingAndRanking")
      println("==================================================")

      #L Array original (preservado sem alteracao):
      mut as list of int64: a = [30, 10, 50, 20, 40]
      mut as int64: n = 5

      #L Array de indices indx = [1, 2, 3, 4, 5]:
      mut as list of int64: indx = [1, 2, 3, 4, 5]

      println("1. Calculando vetor de indices indiretos (Indexx):")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: j = i + 1
            infinite (j <= n) {
                  route {
                        a[indx[i]] > a[indx[j]] ==> {
                              mut as int64: tmp = indx[i]
                              indx[i] = indx[j]
                              indx[j] = tmp
                        }
                        a[indx[i]] <= a[indx[j]] ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Ordem indireta de indices:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   -> indx[" + k + "] aponta para a[" + indx[k] + "] = " + a[indx[k]])
            k = k + 1
      }

      #L Vetor de postos rank:
      mut as list of int64: rk = [0, 0, 0, 0, 0]
      k = 1
      infinite (k <= n) {
            rk[indx[k]] = k
            k = k + 1
      }

      println("3. Vetor de postos estatisticos (Rank):")
      println("   -> rank do elemento a[1]=30: " + rk[1] + " (esperado: 3)")
      println("   -> rank do elemento a[2]=10: " + rk[2] + " (esperado: 1)")
      println("   -> rank do elemento a[3]=50: " + rk[3] + " (esperado: 5)")

      mut as int64: res = (rk[1] - 3) + (rk[2] - 1) + (rk[3] - 5)
      println("4. Residuo dos postos = " + res + " (esperado: 0)")
      println("5. Indexing e Ranking concluidos.")
}
