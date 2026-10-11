#L ============================================================================
#L Algoritmo: Wavelet Compression (Compressão Wavelet DWT 1D)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) transformada rápida de wavelet
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoWaveletCompression) {
      println("==================================================")
      println("  SciAlgo: 1D Wavelet Decomposition Compression")
      println("==================================================")

      mut as list of int64: sinal = [4, 6, 10, 12]
      mut as int64: n = listLength(sinal)

      #L Média (aproximação) e diferença (detalhe) de pares Haar
      mut as int64: a1 = (sinal[1] + sinal[2]) /i 2
      mut as int64: d1 = sinal[1] - sinal[2]
      mut as int64: a2 = (sinal[3] + sinal[4]) /i 2
      mut as int64: d2 = sinal[3] - sinal[4]

      println("1. Sinal de entrada: " + n + " amostras")
      println("2. Coeficientes de aproximacao: [" + a1 + ", " + a2 + "]")
      println("3. Coeficientes de detalhe: [" + d1 + ", " + d2 + "]")
      println("4. Wavelet Compression concluido com sucesso.")
}
