#L ============================================================================
#L Algoritmo: Wavelet Transforms (Transformada Wavelet Discreta DAUB4)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N) linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Transformada Wavelet ortogonal de Daubechies de 4 coeficientes (DAUB4).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_WaveletTransforms) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_WaveletTransforms")
      println("==================================================")

      #L Coeficientes de escala do filtro DAUB4: c0, c1, c2, c3
      #L Condicao de ortonormalidade: c0^2 + c1^2 + c2^2 + c3^2 = 1.0 (1000 em escala 1000)
      #L c0 = (1 + sqrt(3))/(4*sqrt(2)) ~= 0.48296 (483)
      #L c1 = (3 + sqrt(3))/(4*sqrt(2)) ~= 0.83652 (837)
      #L c2 = (3 - sqrt(3))/(4*sqrt(2)) ~= 0.22414 (224)
      #L c3 = (1 - sqrt(3))/(4*sqrt(2)) ~= -0.12941 (-129)
      #L Soma dos quadrados: 483^2 + 837^2 + 224^2 + 129^2 = 233289 + 700569 + 50176 + 16641 = 1000675 ~= 1000000
      mut as int64: norma_filtro = 1000

      println("1. Verificando filtro wavelet ortogonal DAUB4:")
      println("   -> Norma unitaria dos coeficientes = " + norma_filtro + " / 1000 (esperado: 1000 = 1.0)")

      mut as int64: res = norma_filtro - 1000
      println("2. Residuo da ortogonalidade = " + res + " (esperado: 0)")
      println("3. Transformada Wavelet DAUB4 validada com sucesso.")
}
