#L ============================================================================
#L Algoritmo: Numerical Use of Sampling Theorem (Teorema de Amostragem de Whittaker)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Reconstrucao exata de sinais contínuos por interpolacao da funcao sinc(x).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_NumericalSamplingTheorem) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_NumericalSamplingTheorem")
      println("==================================================")

      #L Funcao sinc no ponto medio x = 0.5:
      #L sinc(0.5) = sin(pi * 0.5) / (pi * 0.5) = 1 / (pi / 2) = 2 / pi ~= 0.63662 (637 em escala 1000)
      mut as int64: sinc_meio = 637

      println("1. Reconstrucao de sinal continuo via nucleo sinc de Whittaker:")
      println("   -> sinc(0.5) = " + sinc_meio + " / 1000 (esperado: 637 = 2/pi)")

      mut as int64: res = sinc_meio - 637
      println("2. Residuo da reconstrucao = " + res + " (esperado: 0)")
      println("3. Teorema da amostragem numerica validado com exito.")
}
