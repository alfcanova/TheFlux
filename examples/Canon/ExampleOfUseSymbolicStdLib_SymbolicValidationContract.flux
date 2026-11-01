use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicValidationContract) {
      println("==================================================")
      println("  Exemplo: SymbolicValidationContract (Fase 1)")
      println("==================================================")

      #L 1. Equivalencia algebrica analitica de produtos notaveis
      mut as string: e1 = "(x + y) ^e 2"
      mut as string: e2 = "x ^e 2 + 2 * x * y + y ^e 2"
      mut as bool: eq1 = symbolicAreEqual(e1, e2)
      println("1. symbolicAreEqual('(x + y) ^e 2', 'x ^e 2 + 2 * x * y + y ^e 2'): " + eq1)

      #L 2. Equivalencia de diferenca de quadrados
      mut as string: e3 = "(x + 1) * (x - 1)"
      mut as string: e4 = "x ^e 2 - 1"
      mut as bool: eq2 = symbolicAreEqual(e3, e4)
      println("2. symbolicAreEqual('(x + 1) * (x - 1)', 'x ^e 2 - 1'): " + eq2)

      #L 3. Nao-equivalencia algebrica
      mut as bool: eq3 = symbolicAreEqual("x + 1", "x + 2")
      println("3. symbolicAreEqual('x + 1', 'x + 2'): " + eq3)

      #L 4. Predicado de expressao estritamente polinomial
      mut as bool: is_poly1 = symbolicIsPolynomial("x ^e 2 + 3 * x + 1", "x")
      println("4. symbolicIsPolynomial('x ^e 2 + 3 * x + 1', 'x'): " + is_poly1)

      #L 5. Predicado de expressao com variavel em denominador
      mut as bool: is_poly2 = symbolicIsPolynomial("1 / x", "x")
      println("5. symbolicIsPolynomial('1 / x', 'x'): " + is_poly2)

      #L 6. Predicado de linearidade
      mut as bool: is_lin1 = symbolicIsLinear("3 * x + 5", "x")
      mut as bool: is_lin2 = symbolicIsLinear("x ^e 2 + 1", "x")
      println("6. symbolicIsLinear('3 * x + 5', 'x'): " + is_lin1)
      println("   symbolicIsLinear('x ^e 2 + 1', 'x'): " + is_lin2)

      #L 7. Inspecao de presenca de variavel alvo
      mut as bool: has_x = symbolicHasVariable("3 * x + 2 * y", "x")
      mut as bool: has_z = symbolicHasVariable("3 * x + 2 * y", "z")
      println("7. symbolicHasVariable('3 * x + 2 * y', 'x'): " + has_x)
      println("   symbolicHasVariable('3 * x + 2 * y', 'z'): " + has_z)

      #L 8. Validacao sintatica estrita de sintaxe TheFlux (^e mandatorio)
      mut as bool: valid_e = symbolicIsValidExpression("x ^e 2 + 1")
      mut as bool: invalid_hat = symbolicIsValidExpression("x ^ 2 + 1")
      mut as bool: invalid_star = symbolicIsValidExpression("x ** 2 + 1")
      println("8. Validacao sintatica estrita:")
      println("   symbolicIsValidExpression('x ^e 2 + 1'): " + valid_e)
      println("   symbolicIsValidExpression('x ^ 2 + 1'): " + invalid_hat)
      println("   symbolicIsValidExpression('x ** 2 + 1'): " + invalid_star)
}
