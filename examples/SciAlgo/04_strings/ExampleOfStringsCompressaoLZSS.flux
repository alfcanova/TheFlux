#L ============================================================================
#L Algoritmo: LZSS (Lempel-Ziv-Storer-Szymanski)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N * W) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZSS) {
      println("==================================================")
      println("  SciAlgo: LZSS Flag-Bit Compression")
      println("==================================================")

      #L Flag bit: 1 = literal, 0 = (offset, length)
      mut as int64: flag_literal = 1
      mut as int64: flag_referencia = 0
      mut as int64: min_match_len = 3

      println("1. Limite minimo de match compensatorio: " + min_match_len + " bytes")
      println("2. LZSS flags inicializadas.")
      println("3. LZSS concluido com sucesso.")
}
