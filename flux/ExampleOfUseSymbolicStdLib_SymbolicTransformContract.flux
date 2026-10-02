use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicTransformContract) {
      println("==================================================")
      println("  Exemplo: SymbolicTransformContract (Fase 2)")
      println("==================================================")

      println("1. symbolicFourierTransform('1', 't', 'w'): " + SymbolicStdLib.symbolicFourierTransform("1", "t", "w"))
      println("2. symbolicFourierTransform('e ^e (-t)', 't', 'w'): " + SymbolicStdLib.symbolicFourierTransform("e ^e (-t)", "t", "w"))
      println("3. symbolicInverseFourierTransform('2 * pi * dirac(w)', 'w', 't'): " + SymbolicStdLib.symbolicInverseFourierTransform("2 * pi * dirac(w)", "w", "t"))
      println("4. symbolicInverseFourierTransform('1 / (1 + 1i * w)', 'w', 't'): " + SymbolicStdLib.symbolicInverseFourierTransform("1 / (1 + 1i * w)", "w", "t"))

      mut as list of data: smps = [1.0, 2.0, 3.0, 4.0]
      mut as list of data: fft_res = SymbolicStdLib.symbolicFFT(smps)
      println("5. symbolicFFT([1.0, 2.0, 3.0, 4.0]):")
      println("   " + fft_res[1] + ", " + fft_res[2] + ", " + fft_res[3] + ", " + fft_res[4])

      mut as list of data: ifft_res = SymbolicStdLib.symbolicIFFT(fft_res)
      println("6. symbolicIFFT(spectrum):")
      println("   " + ifft_res[1] + ", " + ifft_res[2] + ", " + ifft_res[3] + ", " + ifft_res[4])

      mut as list of data: pa = [1.0, 1.0]
      mut as list of data: pb = [1.0, 1.0]
      mut as list of data: mul_res = SymbolicStdLib.symbolicFastPolynomialMul(pa, pb)
      println("7. symbolicFastPolynomialMul([1.0, 1.0], [1.0, 1.0]):")
      println("   " + mul_res[1] + ", " + mul_res[2] + ", " + mul_res[3])

      mut as list of data: pa2 = [1.0, 2.0]
      mut as list of data: pb2 = [3.0, 4.0]
      mut as list of data: mul_res2 = SymbolicStdLib.symbolicFastPolynomialMul(pa2, pb2)
      println("8. symbolicFastPolynomialMul([1.0, 2.0], [3.0, 4.0]):")
      println("   " + mul_res2[1] + ", " + mul_res2[2] + ", " + mul_res2[3])
}
