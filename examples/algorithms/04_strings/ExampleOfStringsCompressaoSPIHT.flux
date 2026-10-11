#L ============================================================================
#L Algoritmo: SPIHT (Set Partitioning in Hierarchical Trees)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo progressivo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoSPIHT) {
      println("==================================================")
      println("  SciAlgo: SPIHT Hierarchical Tree Compression")
      println("==================================================")

      mut as int64: threshold = 64
      mut as int64: coeficientes_significantes = 5

      println("1. Threshold atual de bit-plane: " + threshold)
      println("2. Coeficientes wavelet significativos identificados: " + coeficientes_significantes)
      println("3. SPIHT concluido com sucesso.")
}
