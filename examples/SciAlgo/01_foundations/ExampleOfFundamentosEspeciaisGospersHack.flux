#L ============================================================================
#L Algoritmo: Gosper's Hack (Geracao de Subconjuntos de Tamanho K)
#L Dominio: 01_foundations / Algoritmos Especiais
#L Complexidade: O(1) amortizado por combinacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisGospersHack) {
      println("==================================================")
      println("  SciAlgo: Gosper's Hack (Subconjuntos k de n)    ")
      println("==================================================")

      mut as int64: n = 5
      mut as int64: k = 3
      println("1. Parametros: n = " + n + " | k = " + k)

      #L Gera todas as combinacoes de k indices em ordem lexicografica
      mut as list of int64: c = [1, 2, 3]
      mut as int64: total_comb = 0

      println("2. Combinacoes geradas:")

      mut as bool: has_next = true
      infinite (has_next and total_comb < 15) {
            total_comb = total_comb + 1
            println("   Combinacao " + total_comb + ": " + c)

            #L Encontra o elemento mais a direita que pode ser incrementado (guarda segura)
            mut as int64: idx = k
            infinite (idx >= 1) {
                  route {
                        c[idx] == n - k + idx ==> {
                              idx = idx - 1
                        }
                        _ ==> {
                              break
                        }
                  }
            }

            route {
                  idx < 1 ==> {
                        has_next = false
                  }
                  _ ==> {
                        c[idx] = c[idx] + 1
                        mut as int64: j = idx + 1
                        infinite (j <= k) {
                              c[j] = c[j - 1] + 1
                              j = j + 1
                        }
                  }
            }
      }

      println("3. Total de Combinacoes C(5, 3): " + total_comb)
      #L C(5, 3) = 10
      mut as bool: ok = (total_comb == 10)
      println("4. Validacao (Total esperado == 10): " + ok)
      println("==================================================")
}
