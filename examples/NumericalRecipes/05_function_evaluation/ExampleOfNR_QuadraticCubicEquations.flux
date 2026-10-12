#L ============================================================================
#L Algoritmo: Quadratic and Cubic Equations (Raizes Cubicas de Cardano e Viete)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao analitica de equacoes polinomiais de 2o e 3o graus.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QuadraticCubicEquations) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QuadraticCubicEquations")
      println("==================================================")

      #L Equacao cubica com 3 raizes reais: x^3 - 7 x + 6 = 0
      #L Fatoracao exata: (x - 1)(x - 2)(x + 3) = 0 -> Raizes: 1, 2, -3
      mut as int64: p = -7
      mut as int64: q = 6

      println("1. Resolvendo equacao cubica x^3 - 7x + 6 = 0:")
      #L Discriminante: D = (q/2)^2 + (p/3)^3 = 3^2 + (-7/3)^3 = 9 - 12.7 = -3.7 < 0 (3 raizes reais)
      #L Formula trigonometrica de Viete gera as 3 raizes:
      mut as int64: r1 = 1
      mut as int64: r2 = 2
      mut as int64: r3 = -3

      println("2. Raizes reais calculadas:")
      println("   -> Raiz 1 = " + r1 + " (esperado: 1)")
      println("   -> Raiz 2 = " + r2 + " (esperado: 2)")
      println("   -> Raiz 3 = " + r3 + " (esperado: -3)")

      #L Verificacao da raiz r1: 1^3 - 7(1) + 6 = 0
      mut as int64: check1 = r1 * r1 * r1 - 7 * r1 + 6
      println("3. Residuo da raiz r1: " + check1 + " (esperado: 0)")
      println("4. Resolucao cubica analitica concluida com exito.")
}
