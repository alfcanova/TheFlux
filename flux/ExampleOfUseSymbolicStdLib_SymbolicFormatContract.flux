use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicFormatContract) {
      println("==================================================")
      println("  Exemplo: SymbolicFormatContract (Fase 1 e Fase 2)")
      println("==================================================")

      #L 1. Conversao de expressao analitica para codigo-fonte TheFlux
      mut as string: e1 = "x ^e 2 + (2 * x) / y"
      mut as string: fcode1 = SymbolicStdLib.symbolicToTheFluxCode(e1)
      println("1. symbolicToTheFluxCode('x ^e 2 + (2 * x) / y'): " + fcode1)

      #L 2. Contagem de variaveis simbolicas unicas
      mut as string: e2 = "x ^e 2 + y ^e 2 + z"
      mut as int64: n_v = SymbolicStdLib.symbolicVariablesCount(e2)
      println("2. symbolicVariablesCount('x ^e 2 + y ^e 2 + z'): " + n_v)

      #L 3. Metricas e estatisticas analiticas da expressao (SymbolicStats)
      mut as string: e3 = "x ^e 2 + 2 * x + 1"
      mut as SymbolicStats: st3 = SymbolicStdLib.symbolicStats(e3)
      println("3. symbolicStats('x ^e 2 + 2 * x + 1'):")
      println("   Total de nós: " + st3.node_count)
      println("   Profundidade estimada: " + st3.depth)
      println("   Variaveis unicas: " + st3.variable_count)
      println("   Forma canonica normal: " + st3.is_canonical)

      #L 4. Emissor LaTeX oficial
      println("4. symbolicToLaTeX('x ^e 2 / (y + 1)'): " + SymbolicStdLib.symbolicToLaTeX("x ^e 2 / (y + 1)"))
      println("5. symbolicToLaTeX('x ^e 2 - 4 = 0'): " + SymbolicStdLib.symbolicToLaTeX("x ^e 2 - 4 = 0"))

      #L 5. Emissor AST em formatacao nativa TheFlux
      println("6. symbolicToAST('x ^e 2 + 1'): " + SymbolicStdLib.symbolicToAST("x ^e 2 + 1"))

      #L 6. Parsing nominal tipado da AST (SymbolicNode)
      mut as SymbolicNode: node = SymbolicStdLib.symbolicParseAst("x ^e 2 + 1")
      println("7. symbolicParseAst('x ^e 2 + 1'):")
      println("   Tipo raiz: " + node.type_name)
      println("   Valor raiz: " + node.value)
}
