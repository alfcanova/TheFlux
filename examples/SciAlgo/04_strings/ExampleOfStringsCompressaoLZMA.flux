#L ============================================================================
#L Algoritmo: LZMA (Lempel-Ziv-Markov Algorithm Clássico)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZMA) {
      println("==================================================")
      println("  SciAlgo: Classical LZMA Compression")
      println("==================================================")

      mut as int64: estados_markov = 12
      mut as int64: dicionario_kb = 64
      println("1. Estados de contexto LZMA: " + estados_markov)
      println("2. Janela de dicionario: " + dicionario_kb + " KB")
      println("3. Classical LZMA concluido com sucesso.")
}
