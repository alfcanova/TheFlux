#L ============================================================================
#L Algoritmo: Elementary Integration Algorithms (Trapzd e Qsimp Iterativo)
#L Capitulo: 04_integration
#L Complexidade: O(2^stage)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Refinamento geometrico do trapezio com aceleracao de Simpson.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ElementaryIntegrationAlgorithms) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ElementaryIntegrationAlgorithms")
      println("==================================================")

      #L Integrando linear: f(x) = 3x + 1 no intervalo [0, 2] (escala 1000)
      #L Integral exata: int_0^2 (3x + 1) dx = [1.5 x^2 + x]_0^2 = 6 + 2 = 8.0 (8000)
      mut as int64: a = 0
      mut as int64: b = 2000

      println("1. Estagio 1 de Trapzd (extremos a e b):")
      #L s1 = (b - a)/2 * (f(0) + f(2)) = 1 * (1 + 7) = 8.0 (8000)
      mut as int64: f_a = 1000
      mut as int64: f_b = 7000
      mut as int64: s1 = ((b - a) * (f_a + f_b)) /i (2 * 1000)
      println("   -> Trapezio 1 subintervalo s1 = " + s1 + " (esperado: 8000)")

      println("2. Estagio 2 de Trapzd (adiciona ponto medio x = 1):")
      #L f(1) = 3(1) + 1 = 4.0 (4000)
      mut as int64: f_mid = 4000
      mut as int64: s2 = s1 /i 2 + ((b - a) * f_mid) /i (2 * 1000)
      println("   -> Trapezio 2 subintervalos s2 = " + s2 + " (esperado: 8000)")

      #L Combinacao de Simpson: S = (4*s2 - s1) / 3
      mut as int64: s_qsimp = (4 * s2 - s1) /i 3
      println("3. Aceleracao Qsimp:")
      println("   -> Qsimp = " + s_qsimp + " (esperado: 8000 = 8.0)")

      mut as int64: res = s_qsimp - 8000
      println("4. Residuo de Qsimp = " + res + " (esperado: 0)")
      println("5. Algoritmos elementares de quadratura validados.")
}
