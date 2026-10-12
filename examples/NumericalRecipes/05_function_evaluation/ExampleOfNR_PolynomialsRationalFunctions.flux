#L ============================================================================
#L Algoritmo: Polynomials and Rational Functions (Metodo de Horner)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N) multiplicacoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Avaliacao sintetica de polinomios P(x) = sum c_k x^k em tempo linear.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PolynomialsRationalFunctions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PolynomialsRationalFunctions")
      println("==================================================")

      #L Polinomio: P(x) = 2 x^3 - 4 x^2 + 3 x - 5
      #L Coeficientes em ordem decrescente: c = [2, -4, 3, -5]
      #L Avaliacao em x = 2: P(2) = 2(8) - 4(4) + 3(2) - 5 = 16 - 16 + 6 - 5 = 1
      mut as list of int64: c = [2, -4, 3, -5]
      mut as int64: x = 2

      println("1. Avaliando P(x) = 2x^3 - 4x^2 + 3x - 5 em x = 2 via Horner:")
      mut as int64: p = c[1] #L p = 2
      mut as int64: i = 2
      infinite (i <= 4) {
            p = p * x + c[i]
            i = i + 1
      }

      println("2. Valor polinomial calculado:")
      println("   -> P(2) = " + p + " (esperado: 1)")

      mut as int64: res = p - 1
      println("3. Residuo do metodo de Horner = " + res + " (esperado: 0)")
      println("4. Avaliacao de polinomios concluida com exito.")
}
