use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugLoggingContract) {
      println("==================================================")
      println("  Exemplo: DebugLoggingContract (Logs e Rastreio)")
      println("==================================================")

      #L 1. Banner formatado
      println(debugBanner("INICIANDO SUBSISTEMA DE DADOS", 45))

      #L 2. Logs por nivel
      println("1. Log Info:  " + debugLogInfo("AUTH", "Usuario autenticado com sucesso"))
      println("2. Log Warn:  " + debugLogWarn("CACHE", "Tempo limite proximo de expirar"))
      println("3. Log Error: " + debugLogError("DB", "Conexao recusada na porta 5432"))
      println("4. Log Debug: " + debugLogDebug("PARSER", "Token [ID: x] identificado na linha 14"))

      #L 3. Rastreamento de fluxo (Trace)
      println("5. Rastro 1:  " + debugTrace("PipelineIngestao", "Etapa 1: Leitura CSV"))
      println("6. Rastro 2:  " + debugTrace("PipelineIngestao", "Etapa 2: Transformacao"))
      println("7. Rastro 3:  " + debugTrace("PipelineIngestao", "Etapa 3: Carga BD"))
}
