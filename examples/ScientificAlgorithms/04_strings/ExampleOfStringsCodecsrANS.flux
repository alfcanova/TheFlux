#L ============================================================================
#L Algoritmo: rANS (Range Asymmetric Numeral Systems)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(1) aritmetica de precisao finita por simbolo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsrANS) {
      println("==================================================")
      println("  SciAlgo: rANS Range Asymmetric Numeral Systems")
      println("==================================================")

      mut as int64: freq_total = 16
      mut as int64: freq_sym = 4
      mut as int64: start_sym = 8
      mut as int64: estado = 64

      #L Passo de codificação rANS: x' = ((x / freq) * total) + start + (x % freq)
      mut as int64: q = estado /i freq_sym
      mut as int64: rem = estado /r freq_sym
      mut as int64: novo_estado = (q * freq_total) + start_sym + rem

      println("1. Estado inicial rANS: " + estado)
      println("2. Novo estado apos codificacao: " + novo_estado)
      println("3. rANS concluido com sucesso.")
}
