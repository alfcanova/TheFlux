use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicSubstitutionContract) {
      println("==================================================")
      println("  Exemplo: SymbolicSubstitutionContract (Fase 1)")
      println("==================================================")

      #L 1. Substituicao de variavel por monomio
      mut as string: e1 = "x ^e 2 + x"
      mut as string: sub1 = symbolicSubstitute(e1, "x", "2 * t")
      println("1. symbolicSubstitute('x ^e 2 + x', 'x', '2 * t'): " + sub1)

      #L 2. Substituicao multipla simultanea
      mut as string: e2 = "x + y"
      mut as map: reps = map{"x": "a", "y": "b"}
      mut as string: sub2 = symbolicSubstituteAll(e2, reps)
      println("2. symbolicSubstituteAll('x + y', {'x': 'a', 'y': 'b'}): " + sub2)

      #L 3. Avaliacao numerica de expressao quadratica
      mut as string: e3 = "x ^e 2 + 3 * x + 2"
      mut as map: vals3 = map{"x": 2.0}
      mut as float64: eval3 = symbolicEvaluate(e3, vals3)
      println("3. symbolicEvaluate('x ^e 2 + 3 * x + 2', {'x': 2.0}): " + eval3)

      #L 4. Avaliacao numerica multivariada com operacoes aritmeticas
      mut as string: e4 = "2 * x + 3 * y"
      mut as map: vals4 = map{"x": 3.0, "y": 4.0}
      mut as float64: eval4 = symbolicEvaluate(e4, vals4)
      println("4. symbolicEvaluate('2 * x + 3 * y', {'x': 3.0, 'y': 4.0}): " + eval4)

      #L 5. Inspecao e extracao de variaveis unicas ordenadas
      mut as string: e5 = "x ^e 2 + y * z - w"
      mut as list of data: v5 = symbolicGetVariables(e5)
      println("5. symbolicGetVariables('x ^e 2 + y * z - w'): " + v5[1] + ", " + v5[2] + ", " + v5[3] + ", " + v5[4])
}
