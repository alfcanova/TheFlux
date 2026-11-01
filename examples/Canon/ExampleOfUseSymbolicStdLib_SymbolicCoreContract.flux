use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicCoreContract) {
      println("==================================================")
      println("  Exemplo: SymbolicCoreContract (Fase 1)")
      println("==================================================")

      #L 1. Simplificacao de termos redundantes e operadores /i
      mut as string: e1 = "(x * 4) /i 2 + x"
      mut as string: s1 = symbolicSimplify(e1)
      println("1. symbolicSimplify('(x * 4) /i 2 + x'): " + s1)

      #L 2. Cancelamento analitico de variaveis
      mut as string: e2 = "(x + y) + (x - y)"
      mut as string: s2 = symbolicSimplify(e2)
      println("2. symbolicSimplify('(x + y) + (x - y)'): " + s2)

      #L 3. Expansao binomial com operador ^e
      mut as string: e3 = "(x + y) ^e 2"
      mut as string: exp3 = symbolicExpand(e3)
      println("3. symbolicExpand('(x + y) ^e 2'): " + exp3)

      #L 4. Expansao de produto de binomios
      mut as string: e4 = "(x + 1) * (x - 1)"
      mut as string: exp4 = symbolicExpand(e4)
      println("4. symbolicExpand('(x + 1) * (x - 1)'): " + exp4)

      #L 5. Fatoracao de diferenca de quadrados
      mut as string: e5 = "x ^e 2 - 1"
      mut as string: f5 = symbolicFactor(e5)
      println("5. symbolicFactor('x ^e 2 - 1'): " + f5)

      #L 6. Fatoracao de trinomio quadrado perfeito
      mut as string: e6 = "x ^e 2 + 2 * x + 1"
      mut as string: f6 = symbolicFactor(e6)
      println("6. symbolicFactor('x ^e 2 + 2 * x + 1'): " + f6)

      #L 7. Cancelamento de fatores racionais
      mut as string: e7 = "(x ^e 2 - 1) / (x - 1)"
      mut as string: c7 = symbolicCancel(e7)
      println("7. symbolicCancel('(x ^e 2 - 1) / (x - 1)'): " + c7)

      #L 8. Reducao de fracao com together
      mut as string: e8 = "(2 * x) / 2"
      mut as string: t8 = symbolicTogether(e8)
      println("8. symbolicTogether('(2 * x) / 2'): " + t8)
}
