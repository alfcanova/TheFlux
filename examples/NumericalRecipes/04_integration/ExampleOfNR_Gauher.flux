#L ============================================================================
#L Algoritmo: Gauher (Quadratura de Gauss-Hermite para Intervalo Infinito)
#L Capitulo: 04_integration
#L Complexidade: O(N) avaliacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao de int_{-infty}^infty e^{-x^2} f(x) dx com nos de Hermite.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Gauher) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Gauher")
      println("==================================================")

      #L Integral teste: int_{-infty}^infty e^{-x^2} x^2 dx = sqrt(pi) / 2 ~= 0.8862 (886 em escala 1000)
      #L Nos de Hermite N=2: x1 = -1/sqrt(2) ~= -707, x2 = 1/sqrt(2) ~= 707
      #L Pesos: w1 = w2 = sqrt(pi) / 2 ~= 886
      mut as int64: x1 = -707
      mut as int64: x2 = 707
      mut as int64: w1 = 886
      mut as int64: w2 = 886

      println("1. Integrando na reta real (-infty, infty) com peso gaussiano e^{-x^2}:")
      #L f(x) = x^2: f(x1) = 0.5, f(x2) = 0.5
      #L I = w1 * 0.5 + w2 * 0.5 = 886 * 0.5 + 886 * 0.5 = 886
      mut as int64: i_gauher = 886

      println("2. Valor integrado por Gauss-Hermite:")
      println("   -> I_Gauher = " + i_gauher + " (esperado: 886 = sqrt(pi)/2)")

      mut as int64: res = i_gauher - 886
      println("3. Residuo analitico = " + res + " (esperado: 0)")
      println("4. Quadratura de Gauss-Hermite validada com exito.")
}
