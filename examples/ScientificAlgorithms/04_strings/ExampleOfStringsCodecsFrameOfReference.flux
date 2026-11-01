#L ============================================================================
#L Algoritmo: Frame of Reference Encoding (FoR / Bit Packing)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsFrameOfReference) {
      println("==================================================")
      println("  SciAlgo: Frame of Reference (FoR) Compression")
      println("==================================================")

      mut as list of int64: valores = [102, 105, 108, 101, 107]
      mut as int64: n = listLength(valores)

      #L Encontrar valor base de referência (mínimo)
      mut as int64: base = valores[1]
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  valores[i] < base ==> { base = valores[i] }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Valor base de referencia (Frame): " + base)

      #L Codificar offsets em relacao à base
      mut as list of int64: offsets = [0, 0, 0, 0, 0]
      mut as int64: j = 1
      infinite (j <= n) {
            offsets[j] = valores[j] - base
            println("   Item " + j + " (original=" + valores[j] + ") -> offset=" + offsets[j])
            j = j - 1 + 2
      }

      println("2. Frame of Reference concluido com sucesso.")
}
