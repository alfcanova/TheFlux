#L ============================================================================
#L Algoritmo: ANS — Asymmetric Numeral Systems
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(1) por simbolo codificado/decodificado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsANS) {
      println("==================================================")
      println("  SciAlgo: Asymmetric Numeral Systems (ANS)")
      println("==================================================")

      mut as int64: estado = 1
      mut as int64: base = 10
      mut as list of int64: seq = [3, 7, 2]
      mut as int64: n = listLength(seq)

      #L Codificação ANS simples no estado escalar
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: s = seq[i]
            estado = (estado * base) + s
            i = i + 1
      }

      println("1. Estado acumulado ANS: " + estado)

      #L Decodificação na ordem inversa
      mut as list of int64: decodificado = [0, 0, 0]
      mut as int64: j = n
      infinite (j >= 1) {
            decodificado[j] = estado /r base
            estado = estado /i base
            j = j - 1
      }

      println("2. Sequencia decodificada: [" + decodificado[1] + ", " + decodificado[2] + ", " + decodificado[3] + "]")
      println("3. ANS concluido com sucesso.")
}
