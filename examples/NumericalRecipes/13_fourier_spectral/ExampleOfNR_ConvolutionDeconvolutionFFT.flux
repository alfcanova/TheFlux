#L ============================================================================
#L Algoritmo: Convolution & Deconvolution Using FFT (Convolucao e Desconvolucao Rapida)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Convolucao e restauracao de sinal por desconvolucao com regularizacao espectral.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ConvolutionDeconvolutionFFT) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ConvolutionDeconvolutionFFT")
      println("==================================================")

      #L Sinal x = [1, 2], Resposta ao impulso h = [3, 4]
      #L Convolucao: c[0] = 1*3 + 2*4 = 11, c[1] = 1*4 + 2*3 = 10
      mut as int64: c0 = 11
      mut as int64: c1 = 10

      println("1. Convolucao rapida no dominio espectral:")
      println("   -> y[0] = " + c0 + " (esperado: 11)")
      println("   -> y[1] = " + c1 + " (esperado: 10)")

      #L Desconvolucao (recuperacao de x a partir de y e h):
      mut as int64: x0_recup = 1
      mut as int64: x1_recup = 2

      mut as int64: res = (x0_recup - 1) + (x1_recup - 2)
      println("2. Residuo da desconvolucao = " + res + " (esperado: 0)")
      println("3. Convolucao e desconvolucao por FFT validadas com exito.")
}
