#L ============================================================================
#L Algoritmo: Adler-32 (Soma de Verificação Modular Rápida)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoAdler32) {
      println("==================================================")
      println("  SciAlgo: Adler-32 Checksum Algorithm")
      println("==================================================")

      mut as list of int64: dados = [87, 105, 107, 105]
      mut as int64: n = listLength(dados)
      mut as int64: mod_adler = 65521

      mut as int64: a = 1
      mut as int64: b = 0

      mut as int64: i = 1
      infinite (i <= n) {
            a = (a + dados[i]) /r mod_adler
            b = (b + a) /r mod_adler
            i = i + 1
      }

      mut as int64: adler = (b * 65536) + a

      println("1. Dados de entrada: " + n + " bytes")
      println("2. Acumuladores A=" + a + ", B=" + b)
      println("3. Adler-32: " + adler)
      println("4. Adler-32 concluido com sucesso.")
}
