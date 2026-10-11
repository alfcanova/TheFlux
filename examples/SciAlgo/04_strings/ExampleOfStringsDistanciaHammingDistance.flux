#L ============================================================================
#L Algoritmo: Hamming Distance (Distancia de Hamming)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(N) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaHammingDistance) {
      println("==================================================")
      println("  SciAlgo: Hamming Distance")
      println("==================================================")

      mut as list of int64: s1 = [1, 0, 1, 1, 0, 1]
      mut as list of int64: s2 = [1, 1, 0, 1, 0, 0]
      mut as int64: n = listLength(s1)

      mut as int64: dist = 0
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  s1[i] != s2[i] ==> { dist = dist + 1 }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Tamanho dos vetores: " + n)
      println("2. Distancia de Hamming calculada: " + dist)
      println("3. Hamming Distance concluido com sucesso.")
}
