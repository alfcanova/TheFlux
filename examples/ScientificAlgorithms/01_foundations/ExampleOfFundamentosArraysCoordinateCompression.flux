#L ============================================================================
#L Algoritmo: Coordinate Compression (Compressao de Coordenadas)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N log N) tempo | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysCoordinateCompression) {
      println("==================================================")
      println("  SciAlgo: Coordinate Compression")
      println("==================================================")

      mut as list of int64: raw = [1000, -50, 42, 1000, 7, -50, 999999]
      mut as int64: n = listLength(raw)
      println("1. Coordenadas brutas originais (N = " + n + "): " + raw)

      #L Copia para ordenacao e deduplicacao
      mut as list of int64: sorted_vals = []
      mut as int64: i = 1
      infinite (i <= n) {
            sorted_vals = listPushBack(sorted_vals, raw[i])
            i = i + 1
      }

      #L Ordenacao do array
      mut as int64: u = 1
      infinite (u <= n) {
            mut as int64: v = u + 1
            infinite (v <= n) {
                  route {
                        sorted_vals[v] < sorted_vals[u] ==> {
                              mut as int64: tmp = sorted_vals[u]
                              sorted_vals[u] = sorted_vals[v]
                              sorted_vals[v] = tmp
                        }
                        _ ==> {
                        }
                  }
                  v = v + 1
            }
            u = u + 1
      }

      #L Deduplicacao (extracao de valores unicos)
      mut as list of int64: unique_vals = [sorted_vals[1]]
      mut as int64: d = 2
      infinite (d <= n) {
            route {
                  sorted_vals[d] != sorted_vals[d - 1] ==> {
                        unique_vals = listPushBack(unique_vals, sorted_vals[d])
                  }
                  _ ==> {
                  }
            }
            d = d + 1
      }
      mut as int64: num_unique = listLength(unique_vals)
      println("2. Valores unicos ordenados (universo comprimido): " + unique_vals)
      println("   Total de postos distintos: " + num_unique)

      #L Mapeamento de cada coordenada original para o seu posto 1..num_unique
      mut as list of int64: compressed = []
      mut as int64: c = 1
      infinite (c <= n) {
            mut as int64: target = raw[c]

            #L Busca binaria pelo posto em unique_vals
            mut as int64: low = 1
            mut as int64: high = num_unique
            mut as int64: rank = 0

            infinite (low <= high and rank == 0) {
                  mut as int64: mid = low + ((high - low) /i 2)
                  route {
                        unique_vals[mid] == target ==> {
                              rank = mid
                        }
                        unique_vals[mid] < target ==> {
                              low = mid + 1
                        }
                        _ ==> {
                              high = mid - 1
                        }
                  }
            }

            compressed = listPushBack(compressed, rank)
            c = c + 1
      }

      println("3. Coordenadas comprimidas (valores em 1.." + num_unique + "):")
      println("   Resultado: " + compressed)
      println("   Esperado:  [4, 1, 3, 4, 2, 1, 5]")
}
