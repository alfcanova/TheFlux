use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugProfileContract) {
      println("==================================================")
      println("  Exemplo: DebugProfileContract (Metricas e Perfil)")
      println("==================================================")

      #L 1. Contadores
      mut as int64: contador = debugCounterNew()
      println("1. Contador inicial: " + contador)
      contador = debugCounterIncrement(contador, 5)
      println("   Contador (+5):   " + contador)
      contador = debugCounterIncrement(contador, 10)
      println("   Contador (+10):  " + contador)

      #L 2. Registros de Metricas com Unidades
      println("2. Metrica Latencia: " + debugMetricRecord("latencia_requisicao", 42, "ms"))
      println("   Metrica Memoria:  " + debugMetricRecord("alocacao_heap", 1024, "KB"))
      println("   Metrica TPS:      " + debugMetricRecord("taxa_transacoes", 3500, "ops/s"))

      #L 3. Barras de Progresso ASCII
      println("3. Progresso 0%:   " + debugProgress(0, 100, 20))
      println("   Progresso 25%:  " + debugProgress(25, 100, 20))
      println("   Progresso 50%:  " + debugProgress(50, 100, 20))
      println("   Progresso 75%:  " + debugProgress(75, 100, 20))
      println("   Progresso 100%: " + debugProgress(100, 100, 20))
}
