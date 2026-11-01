use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicPolyContract) {
      println("==================================================")
      println("  Exemplo: SymbolicPolyContract (Fase 1)")
      println("==================================================")

      #L 1. Grau de polinomio univariado com ^e
      mut as string: p1 = "4 * x ^e 3 + 2 * x + 1"
      mut as int64: deg1 = symbolicDegree(p1, "x")
      println("1. symbolicDegree('4 * x ^e 3 + 2 * x + 1', 'x'): " + deg1)

      #L 2. Grau de polinomio em variavel ausente
      mut as int64: deg_y = symbolicDegree(p1, "y")
      println("2. symbolicDegree('4 * x ^e 3 + 2 * x + 1', 'y'): " + deg_y)

      #L 3. Extracao de coeficientes polinomiais ordenados
      mut as string: p2 = "4 * x ^e 2 + 3 * x + 5"
      mut as list of data: c2 = symbolicCoefficients(p2, "x")
      println("3. symbolicCoefficients('4 * x ^e 2 + 3 * x + 5', 'x'): " + c2[1] + ", " + c2[2] + ", " + c2[3])

      #L 4. Divisao euclidiana exata de polinomios
      mut as string: num1 = "x ^e 2 - 1"
      mut as string: den1 = "x - 1"
      mut as SymbolicPolyDivideResult: div1 = symbolicPolynomialDivide(num1, den1, "x")
      println("4. Divisao exata de (x ^e 2 - 1) por (x - 1):")
      println("   Quociente: " + div1.quotient)
      println("   Resto: " + div1.remainder)

      #L 5. Divisao euclidiana com resto nao-nulo
      mut as string: num2 = "x ^e 2 + 2 * x + 2"
      mut as string: den2 = "x + 1"
      mut as SymbolicPolyDivideResult: div2 = symbolicPolynomialDivide(num2, den2, "x")
      println("5. Divisao com resto de (x ^e 2 + 2 * x + 2) por (x + 1):")
      println("   Quociente: " + div2.quotient)
      println("   Resto: " + div2.remainder)

      #L 6. Agrupamento de termos polinomiais (collect)
      mut as string: p3 = "(x + 1) * (x + 2)"
      mut as string: col3 = symbolicCollect(p3, "x")
      println("6. symbolicCollect('(x + 1) * (x + 2)', 'x'): " + col3)
}
