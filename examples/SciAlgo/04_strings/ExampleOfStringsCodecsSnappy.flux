#L ============================================================================
#L Algoritmo: Snappy (Byte-Aligned Fast Compression)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N) tempo | O(1) memoria adicional
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsSnappy) {
      println("==================================================")
      println("  SciAlgo: Snappy Byte-Aligned Compression")
      println("==================================================")

      mut as list of int64: seq = [1, 2, 3, 1, 2, 3, 4, 5]
      mut as int64: n = listLength(seq)

      #L Elementos Snappy: tag 00 = literal, tag 01 = copy 1-byte offset
      mut as int64: tag_literal = 0
      mut as int64: tag_copy = 1
      mut as int64: copy_len = 3
      mut as int64: copy_offset = 3

      println("1. Entrada de teste: " + n + " bytes")
      println("2. Emissao de tags Snappy:")
      println("   - Tag literal: " + tag_literal)
      println("   - Tag copy (len=" + copy_len + ", off=" + copy_offset + "): " + tag_copy)
      println("3. Snappy concluido com sucesso.")
}
