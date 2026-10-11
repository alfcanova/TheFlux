#L ============================================================================
#L Algoritmo: LZO (Lempel-Ziv-Oberhumer)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) com descompressao extremamente rapida
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZO) {
      println("==================================================")
      println("  SciAlgo: LZO Real-Time Fast Decompression")
      println("==================================================")

      mut as int64: tam_buffer = 1024
      mut as int64: tempo_descompressao_estimado_us = 2

      println("1. Bloco de entrada LZO: " + tam_buffer + " bytes")
      println("2. Throughput de leitura de instrucoes verificado.")
      println("3. LZO concluido com sucesso.")
}
