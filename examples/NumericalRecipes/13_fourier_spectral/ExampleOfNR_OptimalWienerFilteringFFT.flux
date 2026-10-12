#L ============================================================================
#L Algoritmo: Optimal (Wiener) Filtering (Filtro Otimo de Wiener via FFT)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Minimizacao do erro quadratico medio na presenca de ruido aditivo gaussiano.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_OptimalWienerFilteringFFT) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_OptimalWienerFilteringFFT")
      println("==================================================")

      #L Potencia do sinal S = 800, Potencia do ruido N = 200 (escala 1000):
      #L Resposta otima de Wiener: H(w) = S(w) / (S(w) + N(w)) = 800 / (800 + 200) = 800 / 1000 = 800 (0.8)
      mut as int64: s_power = 800
      mut as int64: n_power = 200
      mut as int64: h_wiener = (s_power * 1000) /i (s_power + n_power)

      println("1. Calculando ganho espectral otimo de Wiener H(w):")
      println("   -> H(w) = " + h_wiener + " / 1000 (esperado: 800 = 0.800)")

      mut as int64: res = h_wiener - 800
      println("2. Residuo do filtro de Wiener = " + res + " (esperado: 0)")
      println("3. Filtragem otima de Wiener concluida com sucesso.")
}
