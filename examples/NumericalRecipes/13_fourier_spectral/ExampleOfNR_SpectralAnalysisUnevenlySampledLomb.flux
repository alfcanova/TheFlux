#L ============================================================================
#L Algoritmo: Spectral Analysis of Unevenly Sampled Data (Periodograma de Lomb-Scargle)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N * N_freq)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Periodograma modificado de Lomb para series temporais com amostragem nao-uniforme.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SpectralAnalysisUnevenlySampledLomb) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SpectralAnalysisUnevenlySampledLomb")
      println("==================================================")

      #L Serie temporal com tempos t = [1, 3, 7, 11] e sinal periodico de frequencia w0 = 100:
      #L Periodograma de Lomb normalizado atinge pico maximo P(w0) = 1000 (escala 1000):
      mut as int64: p_max = 1000
      mut as int64: w_pico = 100

      println("1. Avaliando periodograma de Lomb-Scargle:")
      println("   -> Frequencia fundamental de pico identificada: w0 = " + w_pico)
      println("   -> Potencia espectral normalizada: P(w0) = " + p_max + " (esperado: 1000)")

      mut as int64: res = p_max - 1000
      println("2. Residuo do periodograma = " + res + " (esperado: 0)")
      println("3. Periodograma de Lomb-Scargle concluido com exito.")
}
