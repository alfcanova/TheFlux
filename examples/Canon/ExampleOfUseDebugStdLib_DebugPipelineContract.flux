use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugPipelineContract) {
      println("==================================================")
      println("  Exemplo: DebugPipelineContract (Interceptacao)")
      println("==================================================")

      #L 1. Tap simples de valor
      mut as int64: dado = 42
      mut as int64: resultado = debugTap(dado, "EtapaEntrada")
      println("Resultado apos Tap: " + resultado)

      #L 2. Tap condicional
      mut as int64: v1 = 150
      mut as int64: r1 = debugTapIf(v1, v1 > 100, "AlertaLimite")
      println("Resultado v1: " + r1)

      mut as int64: v2 = 50
      mut as int64: r2 = debugTapIf(v2, v2 > 100, "AlertaLimite")
      println("Resultado v2: " + r2)

      #L 3. Contador de passagem em pipeline
      mut as int64: contador_fluxo = 0
      contador_fluxo = debugCounterTap(10, contador_fluxo)
      contador_fluxo = debugCounterTap(20, contador_fluxo)
      contador_fluxo = debugCounterTap(30, contador_fluxo)
      println("Total de itens processados no pipeline: " + contador_fluxo)
}
