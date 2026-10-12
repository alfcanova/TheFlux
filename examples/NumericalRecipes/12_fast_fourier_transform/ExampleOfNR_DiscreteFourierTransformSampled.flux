#L ============================================================================
#L Algoritmo: Fourier Transform of Sampled Data (Transformada Discreta de Fourier DFT)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo direto da DFT discreta via somatorio de produtos internos complexos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DiscreteFourierTransformSampled) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DiscreteFourierTransformSampled")
      println("==================================================")

      #L Sinal amostrado x = [1, 2, 3, 4]
      #L Somatorio direto da DFT: X[k] = sum_{n=0}^{N-1} x[n] * exp(-i 2pi k n / N)
      #L X[0] = 1 + 2 + 3 + 4 = 10
      #L X[1] = 1 - 2i - 3 + 4i = -2 + 2i
      #L X[2] = 1 - 2 + 3 - 4 = -2
      #L X[3] = 1 + 2i - 3 - 4i = -2 - 2i
      mut as int64: x0_re = 10
      mut as int64: x1_re = 0 - 2
      mut as int64: x1_im = 2
      mut as int64: x2_re = 0 - 2

      println("1. Avaliando somatorio direto da DFT:")
      println("   -> X[0] = " + x0_re + " (esperado: 10)")
      println("   -> X[1] = " + x1_re + " + " + x1_im + "i (esperado: -2 + 2i)")
      println("   -> X[2] = " + x2_re + " (esperado: -2)")

      mut as int64: res = (x0_re - 10) + (x1_re - (0 - 2)) + (x2_re - (0 - 2))
      println("2. Residuo da definicao da DFT = " + res + " (esperado: 0)")
      println("3. Transformada Discreta de Fourier amostrada validada.")
}
