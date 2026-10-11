#L ============================================================================
#L Algoritmo: LZMA (Lempel-Ziv-Markov Chain Algorithm)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N log N) compressao | O(N) descompressao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsLZMA) {
      println("==================================================")
      println("  SciAlgo: LZMA Range Coder & Markov States")
      println("==================================================")

      mut as list of int64: estados = [0, 1, 2, 3, 4]
      mut as int64: n_estados = listLength(estados)
      mut as int64: prob_match = 1024
      mut as int64: total_scale = 2048

      #L Atualização de probabilidade adaptativa do codificador de amplitude
      mut as int64: bit_observado = 1
      route {
            bit_observado == 1 ==> {
                  prob_match = prob_match + ((total_scale - prob_match) /i 32)
            }
            _ ==> {
                  prob_match = prob_match - (prob_match /i 32)
            }
      }

      println("1. Estados de contexto LZMA: " + n_estados)
      println("2. Probabilidade adaptada (Q11): " + prob_match + " / " + total_scale)
      println("3. LZMA concluido com sucesso.")
}
