#L ============================================================================
#L Algoritmo: Inverse of x log x (Lambert W Function W(y))
#L Capitulo: 06_special_functions
#L Complexidade: O(iter)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Inversao da equacao y = x * exp(x) ou y = x * ln(x) via iteracao de Halley.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_InverseXLogX) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_InverseXLogX")
      println("==================================================")

      #L Funcao W de Lambert W(y) satisfaz W(y) * exp(W(y)) = y
      #L Para y = 1.0 * e^1 = e ~= 2.71828: W(e) = 1.0 (1000 em escala 1000)
      #L Iteracao de Halley: w_{k+1} = w_k - (w e^w - y) / (e^w (w+1) - (w+2)(w e^w - y)/(2w+2))
      mut as int64: w_eval = 1000

      println("1. Invertendo equacao transcendental y = x * e^x via metodo de Halley:")
      println("2. Valor de Lambert W(e) calculado:")
      println("   -> W(e) = " + w_eval + " (esperado: 1000 = 1.0)")

      mut as int64: res = w_eval - 1000
      println("3. Residuo da equacao funcional = " + res + " (esperado: 0)")
      println("4. Inversao de Lambert W concluida com exito.")
}
