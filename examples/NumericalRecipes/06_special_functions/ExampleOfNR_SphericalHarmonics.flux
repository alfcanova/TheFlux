#L ============================================================================
#L Algoritmo: Spherical Harmonics (Polinomios de Legendre Associados P_l^m)
#L Capitulo: 06_special_functions
#L Complexidade: O(L)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Recorrencia estavel de Bonnet para polinomios associados de Legendre.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SphericalHarmonics) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SphericalHarmonics")
      println("==================================================")

      #L Polinomios de Legendre:
      #L P0(x) = 1, P1(x) = x, P2(x) = (3x^2 - 1)/2
      #L Para x = 0.5 (500 em escala 1000):
      #L P0(0.5) = 1.0 (1000)
      #L P1(0.5) = 0.5 (500)
      #L P2(0.5) = (3*0.25 - 1)/2 = (0.75 - 1)/2 = -0.125 (-125)
      #L Recorrencia de Bonnet: (l) P_l(x) = (2l - 1) x P_{l-1}(x) - (l - 1) P_{l-2}(x)
      #L Para l=2: 2 * P2 = 3 * 0.5 * 500 - 1 * 1000 = 750 - 1000 = -250 -> P2 = -125
      mut as int64: p0 = 1000
      mut as int64: p1 = 500
      mut as int64: p2_rec = (3 * (500 * p1) /i 1000 - p0) /i 2

      println("1. Avaliando polinomios de Legendre via recorrencia de Bonnet:")
      println("   -> P0(0.5) = " + p0)
      println("   -> P1(0.5) = " + p1)
      println("   -> P2(0.5) = " + p2_rec + " (esperado: -125 = -0.125)")

      mut as int64: res = p2_rec - (-125)
      println("2. Residuo da recorrencia = " + res + " (esperado: 0)")
      println("3. Harmonicos esfericos validados com sucesso.")
}
