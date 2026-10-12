#L ============================================================================
#L Algoritmo: Completely Hashing a Large Array (Hash FNV-1a de Alta Entropia)
#L Capitulo: 07_random_numbers
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Funcao de dispersao FNV-1a para arrays e vetores de dados.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HashingLargeArray) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HashingLargeArray")
      println("==================================================")

      mut as list of int64: arr = [10, 25, 42, 99, 105]
      mut as int64: fnv_offset = 21661362
      mut as int64: fnv_prime = 16777619
      mut as int64: mod_hash = 1000000007

      println("1. Calculando hash FNV-1a para array de 5 elementos:")
      mut as int64: h = fnv_offset
      mut as int64: i = 1
      infinite (i <= 5) {
            mut as int64: val = arr[i]
            h = (h ^ val) * fnv_prime /r mod_hash
            route {
                  h < 0 ==> {
                        h = 0 - h
                  }
                  h >= 0 ==> {}
            }
            i = i + 1
      }
      println("   -> Hash calculado: " + h)

      #L Modificando 1 unico elemento para demonstrar efeito avalanche:
      mut as list of int64: arr2 = [10, 25, 43, 99, 105]
      mut as int64: h2 = fnv_offset
      mut as int64: j = 1
      infinite (j <= 5) {
            mut as int64: val2 = arr2[j]
            h2 = (h2 ^ val2) * fnv_prime /r mod_hash
            route {
                  h2 < 0 ==> {
                        h2 = 0 - h2
                  }
                  h2 >= 0 ==> {}
            }
            j = j + 1
      }
      println("   -> Hash com perturbacao de 1 bit (42 -> 43): " + h2)

      mut as int64: avalanche = 0
      route {
            h != h2 ==> {
                  avalanche = 1
            }
            h == h2 ==> {
                  avalanche = 0
            }
      }
      mut as int64: res = 1 - avalanche
      println("2. Verificacao de dispersao avalanche: " + avalanche + " (residuo: " + res + ")")
      println("3. Hashing de array de dados concluido.")
}
