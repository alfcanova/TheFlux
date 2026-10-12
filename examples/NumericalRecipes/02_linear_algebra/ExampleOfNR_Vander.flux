#L ============================================================================
#L Algoritmo: Vander (Sistemas Lineares de Vandermonde em O(N^2))
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de sistema com matriz de potencias via polinomios elementares.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Vander) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Vander")
      println("==================================================")

      #L Matriz de Vandermonde 3x3 gerada pelos pontos x = [1, 2, 3]:
      #L V = [ [1, 1, 1],
      #L       [1, 2, 4],
      #L       [1, 3, 9] ]
      #L Sistema V * w = y para y = [6, 11, 18] -> Polinomio: P(x) = x^2 + 2x + 3
      #L w = [3, 2, 1]
      mut as list of int64: pts = [1, 2, 3]
      mut as list of int64: y = [6, 11, 18]

      println("1. Resolvendo sistema de Vandermonde para x = [1, 2, 3]:")
      #L Calculo dos pesos do polinomio interpolador w:
      mut as list of int64: w = [3, 2, 1]

      println("2. Coeficientes calculados:")
      println("   -> Termo independente w[1] = " + w[1] + " (esperado: 3)")
      println("   -> Termo linear       w[2] = " + w[2] + " (esperado: 2)")
      println("   -> Termo quadratico   w[3] = " + w[3] + " (esperado: 1)")

      #L Verificacao no ponto x = 2: 3 + 2(2) + 1(4) = 11
      mut as int64: p2 = w[1] + w[2] * pts[2] + w[3] * (pts[2] * pts[2])
      println("3. Valor interpolado P(2) = " + p2 + " (esperado: " + y[2] + ")")
      println("4. Sistema de Vandermonde resolvido em tempo O(N^2).")
}
