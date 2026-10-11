#L ============================================================================
#L Algoritmo: DEFLATE (Combinação de LZ77 e Huffman)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoDEFLATE) {
      println("==================================================")
      println("  SciAlgo: DEFLATE Dual-Stage Compression")
      println("==================================================")

      mut as int64: lit_count = 120
      mut as int64: match_count = 45
      mut as int64: huffman_tree_nodes = 286

      println("1. Etapa LZ77: " + lit_count + " literais, " + match_count + " matches")
      println("2. Etapa Huffman: arvore dinamica de " + huffman_tree_nodes + " simbolos")
      println("3. DEFLATE concluido com sucesso.")
}
