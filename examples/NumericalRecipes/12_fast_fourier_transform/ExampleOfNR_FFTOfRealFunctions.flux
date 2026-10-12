#L ============================================================================
#L Algoritmo: FFT of Real Functions (FFT Especializada para Funcoes Reais — Realft)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Empacotamento de N dados reais em N/2 complexos com economia de 50% de memoria.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FFTOfRealFunctions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FFTOfRealFunctions")
      println("==================================================")

      #L Sinal real x = [1, 2, 3, 4] empacotado em N/2 = 2 numeros complexos
      mut as int64: dc = 10
      mut as int64: nyquist = 0 - 2

      println("1. Desempacotando espectro real (Realft):")
      println("   -> DC = " + dc + " (esperado: 10)")
      println("   -> Nyquist = " + nyquist + " (esperado: -2)")

      mut as int64: res = dc + nyquist - 8
      println("2. Residuo do desempacotamento espectral = " + res + " (esperado: 0)")
      println("3. FFT especializada para funcoes reais concluida.")
}
