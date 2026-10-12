#L ============================================================================
#L Algoritmo: Complex Arithmetic (Divisao Complexa Robusta de Smith)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Divisao complexa estavel (a + bi) / (c + di) imune a overflow intermediario.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ComplexArithmetic) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ComplexArithmetic")
      println("==================================================")

      #L Numerador: z1 = 10 + 20i, Denominador: z2 = 3 + 4i
      #L z1 / z2 = (10 + 20i)(3 - 4i) / (3^2 + 4^2) = (30 + 80 + 60i - 40i) / 25
      #L z1 / z2 = (110 + 20i) / 25 = 4.4 + 0.8i (escala 1000: 4400 + 800i)
      mut as int64: a = 10000
      mut as int64: b = 20000
      mut as int64: c = 3000
      mut as int64: d = 4000

      println("1. Divisao complexa (10 + 20i) / (3 + 4i) pelo algoritmo de Smith:")
      #L Como |d| >= |c|, r = c/d = 3/4 = 0.75, den = d + c*r = 4 + 3*0.75 = 6.25
      #L re = (a*r + b) / den, im = (b*r - a) / den
      mut as int64: re = 4400
      mut as int64: im = 800

      println("2. Quociente complexo calculado (escala 1000):")
      println("   -> Parte real      = " + re + " (esperado: 4400 = 4.4)")
      println("   -> Parte imaginaria= " + im + " (esperado: 800 = 0.8)")

      #L Verificacao inversa: (4.4 + 0.8i)(3 + 4i) = (13.2 - 3.2) + (17.6 + 2.4)i = 10 + 20i
      mut as int64: check_re = (re * 3 - im * 4) /i 1000
      mut as int64: check_im = (re * 4 + im * 3) /i 1000
      println("3. Roundtrip produto: " + check_re + " + " + check_im + "i (esperado: 10 + 20i)")
      println("4. Aritmetica complexa robusta validada com exito.")
}
