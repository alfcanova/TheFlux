#L ============================================================================
#L Algoritmo: Delta-of-Delta Encoding (Compressao de Series Temporais)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N) tempo | O(1) espaco extra
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsDeltaOfDelta) {
      println("==================================================")
      println("  SciAlgo: Delta-of-Delta Encoding")
      println("==================================================")

      #L Série temporal linearmente crescente: 1000, 1060, 1120, 1180, 1245
      mut as list of int64: serie = [1000, 1060, 1120, 1180, 1245]
      mut as int64: n = listLength(serie)

      #L D1: delta simples; D2: delta de delta
      mut as list of int64: d1 = [0, 0, 0, 0, 0]
      mut as list of int64: d2 = [0, 0, 0, 0, 0]

      mut as int64: i = 2
      infinite (i <= n) {
            d1[i] = serie[i] - serie[i - 1]
            route {
                  i >= 3 ==> {
                        d2[i] = d1[i] - d1[i - 1]
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Serie original de " + n + " pontos")
      println("2. D1 (deltas): [" + d1[2] + ", " + d1[3] + ", " + d1[4] + ", " + d1[5] + "]")
      println("3. D2 (delta-of-delta): [" + d2[3] + ", " + d2[4] + ", " + d2[5] + "]")
      println("4. Delta-of-Delta concluido com sucesso.")
}
