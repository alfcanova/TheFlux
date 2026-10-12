#L ============================================================================
#L Algoritmo: Classical Equally Spaced Formulas (Regras de Trapezio e Simpson)
#L Capitulo: 04_integration
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Formulas fechadas de Newton-Cotes para integracao numerica regular.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ClassicalEquallySpacedFormulas) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ClassicalEquallySpacedFormulas")
      println("==================================================")

      #L Integrando: f(x) = x^2 no intervalo [0, 3] (escala 1000)
      #L Integral exata: int_0^3 x^2 dx = [x^3 / 3]_0^3 = 9.0 (9000 em escala 1000)
      mut as int64: a = 0
      mut as int64: b = 3000
      mut as int64: h = 1500 #L passo de 1.5 para 2 subintervalos de Simpson

      #L Valores de f nos pontos x = 0, 1.5, 3:
      #L f(0) = 0
      #L f(1.5) = 1.5^2 = 2.25 (2250)
      #L f(3) = 3^2 = 9 (9000)
      mut as int64: f0 = 0
      mut as int64: f1 = 2250
      mut as int64: f2 = 9000

      println("1. Avaliando integral int_0^3 x^2 dx pela Regra de Simpson 1/3:")
      #L Formula de Simpson: I = (h / 3) * (f0 + 4*f1 + f2)
      #L I = (1.5 / 3) * (0 + 4*2.25 + 9) = 0.5 * (9 + 9) = 9.0 (9000)
      mut as int64: simp_int = (h * (f0 + 4 * f1 + f2)) /i (3 * 1000)

      println("2. Valor integrado por Simpson:")
      println("   -> I_Simpson = " + simp_int + " (esperado: 9000 = 9.0)")

      mut as int64: res = simp_int - 9000
      println("3. Residuo analitico da quadratura = " + res + " (esperado: 0)")
      println("4. Formula de Simpson concluida com sucesso.")
}
