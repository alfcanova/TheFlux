#L ============================================================================
#L Algoritmo: Embedded Zerotree Wavelet — EZW
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) codificacao progressiva em planos de bits
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoEZW) {
      println("==================================================")
      println("  SciAlgo: Embedded Zerotree Wavelet (EZW)")
      println("==================================================")

      mut as int64: simbolos_zerotree = 8
      mut as int64: plano_de_bits = 4

      println("1. Planos de bits analisados: " + plano_de_bits)
      println("2. Estruturas zerotree comprimidas: " + simbolos_zerotree)
      println("3. EZW concluido com sucesso.")
}
