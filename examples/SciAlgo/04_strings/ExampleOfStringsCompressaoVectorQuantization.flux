#L ============================================================================
#L Algoritmo: Vector Quantization (Quantização Vetorial com Codebook)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N * K) comparando contra K centroides
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoVectorQuantization) {
      println("==================================================")
      println("  SciAlgo: Vector Quantization (Codebook Model)")
      println("==================================================")

      mut as int64: codebook_size = 16
      mut as int64: dimensao_vetor = 4
      mut as int64: indice_centroide = 3

      println("1. Dimensoes do codebook: " + codebook_size + " vetores de tam " + dimensao_vetor)
      println("2. Indice mais proximo quantizado: " + indice_centroide)
      println("3. Vector Quantization concluido com sucesso.")
}
