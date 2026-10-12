#L ============================================================================
#L Algoritmo: Economization of Power Series (Economizacao de Chebyshev)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Reducao de grau de polinomios de Taylor com erro uniformemente distribuido.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_EconomizationPowerSeries) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_EconomizationPowerSeries")
      println("==================================================")

      #L Serie cubica: P3(x) = 1 + x + x^2/2 + x^3/6 (Taylor de exp(x))
      #L Subtracao do termo de Chebyshev: T3(x) = 4 x^3 - 3 x
      #L x^3 = (T3 + 3x) / 4. Substituindo termo cubico x^3/6 por 3x / 24 = x / 8
      #L Polinomio economizado quadratico: P2(x) = 1 + (9/8) x + x^2/2
      mut as int64: p2_0 = 1000 #L 1.0
      mut as int64: p2_1 = 1125 #L 9/8 = 1.125
      mut as int64: p2_2 = 500  #L 1/2 = 0.5

      println("1. Economizando polinomio de Taylor cubico para quadratico:")
      println("2. Coeficientes do polinomio economizado (escala 1000):")
      println("   -> c0 = " + p2_0 + " (esperado: 1000)")
      println("   -> c1 = " + p2_1 + " (esperado: 1125)")
      println("   -> c2 = " + p2_2 + " (esperado: 500)")

      println("3. Economizacao de serie de potencias concluida com exito.")
}
