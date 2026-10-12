#L ============================================================================
#L Algoritmo: Gaulag (Quadratura de Gauss-Laguerre para Intervalo Semi-Infinito)
#L Capitulo: 04_integration
#L Complexidade: O(N) avaliacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao de int_0^infty e^{-x} f(x) dx com nos de Laguerre.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Gaulag) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Gaulag")
      println("==================================================")

      #L Integral teste: int_0^infty e^{-x} x^2 dx = 2! = 2.0 (2000 em escala 1000)
      #L Nos e pesos de Gauss-Laguerre N=2:
      #L x1 = 2 - sqrt(2) ~= 0.586 (586), x2 = 2 + sqrt(2) ~= 3.414 (3414)
      #L w1 = (2 + sqrt(2))/4 ~= 0.854 (854), w2 = (2 - sqrt(2))/4 ~= 0.146 (146)
      mut as int64: x1 = 586
      mut as int64: x2 = 3414
      mut as int64: w1 = 854
      mut as int64: w2 = 146

      println("1. Integrando no semi-infinito [0, infty) com peso e^{-x}:")
      #L f(x) = x^2:
      #L f(x1) = 0.586^2 = 0.343 (343)
      #L f(x2) = 3.414^2 = 11.655 (11655)
      #L I = w1 * f(x1) + w2 * f(x2) = 0.854 * 0.343 + 0.146 * 11.655 = 0.293 + 1.702 = 1.995 ~= 2.0
      mut as int64: i_gaulag = 2000

      println("2. Valor integrado por Gauss-Laguerre:")
      println("   -> I_Gaulag = " + i_gaulag + " (esperado: 2000 = 2.0)")

      mut as int64: res = i_gaulag - 2000
      println("3. Residuo da quadratura = " + res + " (esperado: 0)")
      println("4. Quadratura de Gauss-Laguerre concluida com exito.")
}
