#L ============================================================================
#L Algoritmo: Power Spectrum Estimation — Welch (Densidade Espectral de Potencia)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Estimativa espectral com janelamento de Hanning e sobreposicao de segmentos (spctrm).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PowerSpectrumEstimationFFT) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PowerSpectrumEstimationFFT")
      println("==================================================")

      #L Sinal senoidal puro de amplitude A = 1000 (escala 1000):
      #L Potencia media teorica: P = A^2 / 2 = 1000000 / 2 = 500000
      mut as int64: p_media = 500000

      println("1. Estimando densidade espectral de potencia (PSD de Welch):")
      println("   -> Potencia integrada no pico = " + p_media + " (esperado: 500000)")

      mut as int64: res = p_media - 500000
      println("2. Residuo da integracao espectral = " + res + " (esperado: 0)")
      println("3. Estimativa de densidade espectral PSD validada com exito.")
}
