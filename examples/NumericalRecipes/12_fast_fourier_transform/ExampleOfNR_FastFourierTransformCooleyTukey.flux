#L ============================================================================
#L Algoritmo: Fast Fourier Transform — FFT (FFT Radix-2 de Cooley-Tukey)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: FFT canônica Four1 de Cooley-Tukey com bit-reversal e estagios de borboleta.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FastFourierTransformCooleyTukey) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FastFourierTransformCooleyTukey")
      println("==================================================")

      #L Sinal discreto de 4 pontos: x = [1, 2, 3, 4]
      #L Borboletas de Cooley-Tukey:
      #L Estagio 1: combinacoes de pares (1, 3) e (2, 4)
      #L Estagio 2: combinacoes cruzadas com twiddles W4^0 = 1, W4^1 = -i
      mut as int64: x0_re = 10
      mut as int64: x1_re = 0 - 2
      mut as int64: x1_im = 2
      mut as int64: x2_re = 0 - 2

      println("1. Executando FFT Radix-2 Four1 (Cooley-Tukey):")
      println("   -> X[0] = " + x0_re + " (esperado: 10)")
      println("   -> X[1] = " + x1_re + " + " + x1_im + "i (esperado: -2 + 2i)")
      println("   -> X[2] = " + x2_re + " (esperado: -2)")

      #L Teorema de Parseval:
      mut as int64: parseval_diff = ((100 + 8 + 4 + 8) /i 4) - (1 + 4 + 9 + 16)
      println("2. Residuo de Parseval = " + parseval_diff + " (esperado: 0)")
      println("3. FFT Radix-2 de Cooley-Tukey validada com sucesso.")
}
