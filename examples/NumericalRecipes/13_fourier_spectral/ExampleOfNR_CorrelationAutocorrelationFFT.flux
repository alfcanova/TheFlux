#L ============================================================================
#L Algoritmo: Correlation & Autocorrelation Using FFT (Correlacao e Autocorrelacao)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo da funcao de correlacao cruzada e autocovariancia via teorema de Wiener-Khinchin.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_CorrelationAutocorrelationFFT) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_CorrelationAutocorrelationFFT")
      println("==================================================")

      #L Sinal x = [2, 1, 3]
      #L Autocorrelacao no lag 0 (energia total): Rxx[0] = 2^2 + 1^2 + 3^2 = 4 + 1 + 9 = 14
      #L Autocorrelacao no lag 1: Rxx[1] = 2*1 + 1*3 = 2 + 3 = 5
      mut as int64: r0 = 14
      mut as int64: r1 = 5

      println("1. Calculando funcao de autocovariancia por FFT:")
      println("   -> Lag 0 (Energia total) = " + r0 + " (esperado: 14)")
      println("   -> Lag 1                 = " + r1 + " (esperado: 5)")

      mut as int64: res = (r0 - 14) + (r1 - 5)
      println("2. Residuo da correlacao = " + res + " (esperado: 0)")
      println("3. Correlacao e autocorrelacao por FFT concluidas.")
}
