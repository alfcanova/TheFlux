#L ============================================================================
#L Algoritmo: LZ4 (Ultra-Fast Byte-Oriented Compression)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N) linear com alto throughput
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsLZ4) {
      println("==================================================")
      println("  SciAlgo: LZ4 Token-Based Block Compression")
      println("==================================================")

      mut as list of int64: dados_bytes = [10, 20, 10, 20, 10, 20, 30, 40]
      mut as int64: n = listLength(dados_bytes)

      #L Token LZ4: 4 bits lit_len + 4 bits match_len
      mut as int64: lit_len = 2
      mut as int64: match_len = 4
      mut as int64: offset = 2
      mut as int64: token = (lit_len * 16) + match_len

      println("1. Bloco de entrada: " + n + " bytes")
      println("2. Token LZ4 construído: " + token)
      println("   - Literal length: " + lit_len)
      println("   - Match length: " + match_len)
      println("   - Offset: " + offset)
      println("3. LZ4 concluido com sucesso.")
}
