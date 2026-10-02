use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicFormatContract) {
      println("==================================================")
      println("  Exemplo: SymbolicFormatContract (Fase 1)")
      println("==================================================")

      #L 1. Conversao de expressao analitica para codigo-fonte TheFlux
      mut as string: e1 = "x ^e 2 + (2 * x) / y"
      mut as string: fcode1 = symbolicToTheFluxCode(e1)
      println("1. symbolicToTheFluxCode('x ^e 2 + (2 * x) / y'): " + fcode1)

      #L 2. Contagem de variaveis simbolicas unicas
      mut as string: e2 = "x ^e 2 + y ^e 2 + z"
      mut as int64: n_v = symbolicVariablesCount(e2)
      println("2. symbolicVariablesCount('x ^e 2 + y ^e 2 + z'): " + n_v)

      #L 3. Metricas e estatisticas analiticas da expressao (SymbolicStats)
      mut as string: e3 = "x ^e 2 + 2 * x + 1"
      mut as SymbolicStats: st3 = symbolicStats(e3)
      println("3. symbolicStats('x ^e 2 + 2 * x + 1'):")
      println("   Total de nós: " + st3.node_count)
      println("   Profundidade estimada: " + st3.depth)
      println("   Variaveis unicas: " + st3.variable_count)
      println("   Forma canonica normal: " + st3.is_canonical)
}
