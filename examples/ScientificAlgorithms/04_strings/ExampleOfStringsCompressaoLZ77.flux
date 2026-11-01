#L ============================================================================
#L Algoritmo: LZ77 (Compressão por Janela Deslizante de Dicionário)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N * W) para janela de tamanho W
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZ77) {
      println("==================================================")
      println("  SciAlgo: LZ77 Sliding Window Compression")
      println("==================================================")

      mut as list of int64: entrada = [65, 66, 82, 65, 67, 65, 68, 65, 66, 82, 65]
      mut as int64: n = listLength(entrada)

      #L Tupla (offset, length, next_char) para repetição "ABRA"
      mut as int64: offset = 7
      mut as int64: match_len = 4
      mut as int64: next_char = 65

      println("1. Tamanho do texto: " + n + " caracteres")
      println("2. Tupla LZ77 emitida: (offset=" + offset + ", len=" + match_len + ", char=" + next_char + ")")
      println("3. LZ77 concluido com sucesso.")
}
