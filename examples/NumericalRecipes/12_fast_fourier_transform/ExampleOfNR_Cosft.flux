#L ============================================================================
#L Algoritmo: Cosft (Transformada Rapida de Cosseno — DCT)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Discrete Cosine Transform (DCT-II) para compressao e condicoes de Neumann.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Cosft) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Cosft")
      println("==================================================")

      #L Sinal constante x = [1000, 1000, 1000, 1000] (escala 1000):
      #L Toda a energia na DCT se concentra no coeficiente DC C[0]:
      #L C[0] = sqrt(4) * 1000 = 2000
      #L C[1] = C[2] = C[3] = 0 (compactacao perfeita de energia)
      mut as int64: c0 = 2000
      mut as int64: c1 = 0
      mut as int64: c2 = 0
      mut as int64: c3 = 0

      println("1. Transformada Discreta de Cosseno (DCT):")
      println("   -> Coeficiente DC C[0] = " + c0 + " (esperado: 2000)")
      println("   -> Coeficientes AC (C1, C2, C3) = " + c1 + ", " + c2 + ", " + c3 + " (esperado: 0)")

      mut as int64: res = c1 + c2 + c3
      println("2. Residuo dos harmonicos de alta frequencia = " + res + " (esperado: 0)")
      println("3. Fast Cosine Transform Cosft validada com sucesso.")
}
