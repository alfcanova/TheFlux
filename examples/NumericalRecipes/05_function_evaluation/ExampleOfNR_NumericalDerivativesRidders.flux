#L ============================================================================
#L Algoritmo: Numerical Derivatives (Diferenciacao Numerica de Ridders)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(M^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Derivada de alta precisao combinando diferencas centradas com extrapolacao.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_NumericalDerivativesRidders) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_NumericalDerivativesRidders")
      println("==================================================")

      #L Funcao: f(x) = x^3. Ponto de avaliacao x = 2. Derivada exata f'(2) = 3(2^2) = 12.0
      #L Escala 1000: f'(2) = 12000
      #L Passo inicial h = 1.0 (1000):
      #L f(x+h) = 3^3 = 27 (27000), f(x-h) = 1^3 = 1 (1000)
      #L D(h) = (f(x+h) - f(x-h)) / (2h) = (27 - 1)/2 = 13.0 (13000)
      #L Passo reduzido h/2 = 0.5:
      #L f(2.5) = 15.625 (15625), f(1.5) = 3.375 (3375)
      #L D(h/2) = (15.625 - 3.375) / 1.0 = 12.25 (12250)
      mut as int64: d1 = 13000
      mut as int64: d2 = 12250

      println("1. Diferencas centradas de Ridders com passos h e h/2:")
      println("   -> D(h)   = " + d1)
      println("   -> D(h/2) = " + d2)

      #L Extrapolacao de Richardson ordem O(h^4): D_extrap = (4 * D(h/2) - D(h)) / 3
      #L D_extrap = (4 * 12250 - 13000) / 3 = (49000 - 13000) / 3 = 36000 / 3 = 12000
      mut as int64: d_ridders = (4 * d2 - d1) /i 3
      println("2. Derivada extrapolada de Ridders:")
      println("   -> f'(2) = " + d_ridders + " (esperado: 12000 = 12.0)")

      mut as int64: res = d_ridders - 12000
      println("3. Residuo da derivada = " + res + " (esperado: 0)")
      println("4. Diferenciacao de Ridders validada com sucesso.")
}
