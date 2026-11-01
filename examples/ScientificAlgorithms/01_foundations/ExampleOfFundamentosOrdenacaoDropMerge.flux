#L ============================================================================
#L Algoritmo: Drop-Merge Sort (Adaptativo para Quase-Ordenados)
#L Dominio: 01_foundations / Ordenacao
#L Complexidade: O(n + k log k) tempo | O(k) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoDropMerge) {
      println("==================================================")
      println("  SciAlgo: Drop-Merge Sort                        ")
      println("==================================================")

      mut as list of int64: arr = [1, 2, 8, 3, 4, 9, 5]
      mut as int64: n = listLength(arr)
      println("1. Vetor Quase-Ordenado: " + arr)

      #L Passo 1: Varredura para coletar elementos fora de ordem (dropped)
      mut as list of int64: kept = [arr[1]]
      mut as list of int64: dropped = []

      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: last_kept = kept[listLength(kept)]
            route {
                  arr[i] >= last_kept ==> {
                        kept = listPushBack(kept, arr[i])
                  }
                  _ ==> {
                        dropped = listPushBack(dropped, arr[i])
                  }
            }
            i = i + 1
      }

      println("   Mantidos: " + kept)
      println("   Descartados (Dropped): " + dropped)

      #L Passo 2: Ordenar os elementos descartados (Insertion sort simples)
      mut as int64: d_len = listLength(dropped)
      i = 2
      infinite (i <= d_len) {
            mut as int64: key = dropped[i]
            mut as int64: j = i - 1
            infinite (j >= 1 and dropped[j] > key) {
                  dropped[j + 1] = dropped[j]
                  j = j - 1
            }
            dropped[j + 1] = key
            i = i + 1
      }

      #L Passo 3: Intercalar kept e dropped de volta em result
      mut as list of int64: result = []
      mut as int64: p1 = 1
      mut as int64: p2 = 1
      mut as int64: k_len = listLength(kept)

      infinite (p1 <= k_len and p2 <= d_len) {
            route {
                  kept[p1] <= dropped[p2] ==> {
                        result = listPushBack(result, kept[p1])
                        p1 = p1 + 1
                  }
                  _ ==> {
                        result = listPushBack(result, dropped[p2])
                        p2 = p2 + 1
                  }
            }
      }

      infinite (p1 <= k_len) {
            result = listPushBack(result, kept[p1])
            p1 = p1 + 1
      }

      infinite (p2 <= d_len) {
            result = listPushBack(result, dropped[p2])
            p2 = p2 + 1
      }

      println("2. Vetor Final Ordenado: " + result)
      #L Esperado: [1, 2, 3, 4, 5, 8, 9]
      mut as bool: ok = (result[1] == 1 and result[2] == 2 and result[3] == 3 and result[4] == 4 and result[5] == 5 and result[6] == 8 and result[7] == 9)
      println("3. Validacao (Drop-merge correto): " + ok)
      println("==================================================")
}
