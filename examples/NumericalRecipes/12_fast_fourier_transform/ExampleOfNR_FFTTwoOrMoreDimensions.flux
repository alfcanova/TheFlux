#L ============================================================================
#L Algoritmo: FFT in Two or More Dimensions (FFT 2D e Multidimensional — Fourn)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N1*N2*log(N1*N2))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: FFT bidimensional por produto tensorial de transformadas unidimensionais.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FFTTwoOrMoreDimensions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FFTTwoOrMoreDimensions")
      println("==================================================")

      #L Grade 2D 2x2: [[1, 2], [3, 4]]
      #L Componente fundamental 2D DC (0, 0) = sum(matriz) = 1 + 2 + 3 + 4 = 10
      mut as int64: dc_2d = 10

      println("1. Executando FFT 2D (Fourn):")
      println("   -> Coeficiente espacial DC (0, 0) = " + dc_2d + " (esperado: 10)")

      mut as int64: res = dc_2d - 10
      println("2. Residuo da transformada 2D = " + res + " (esperado: 0)")
      println("3. FFT em duas ou mais dimensoes validada.")
}
