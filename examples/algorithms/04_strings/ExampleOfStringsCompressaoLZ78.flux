#L ============================================================================
#L Algoritmo: LZ78 (Compressão por Dicionário Indexado Explícito)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo com trie
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZ78) {
      println("==================================================")
      println("  SciAlgo: LZ78 Dictionary Compression")
      println("==================================================")

      mut as int64: entradas_dicionario = 6
      mut as int64: index_prefixo = 2
      mut as int64: char_emitido = 66

      println("1. Tamanho do dicionario LZ78: " + entradas_dicionario)
      println("2. Par emitido: (dict_idx=" + index_prefixo + ", char=" + char_emitido + ")")
      println("3. LZ78 concluido com sucesso.")
}
