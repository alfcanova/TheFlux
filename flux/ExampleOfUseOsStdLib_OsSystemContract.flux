use OsStdLib

program (ExampleOfUseOsStdLib_OsSystemContract) {
      println("==================================================")
      println("  Exemplo: OsSystemContract (Recursos do Sistema)")
      println("==================================================")

      println("1. Usuario Atual: " + osUserName())
      println("2. Diretorio Home: " + osHomeDir())
      println("3. Diretorio Temporario: " + osTempDir())
      println("4. Quantidade de CPUs: " + osCpuCount())
      println("5. Memoria Total (Bytes): " + osMemoryTotal())
      println("6. Memoria Total (GB): " + osMemoryTotalGb())
      println("7. Resumo do Sistema: " + osSystemSummary())
      println("8. Uptime Ativo (> 0): " + (osUptime() > 0))
      println("9. Memoria Livre (> 0): " + (osMemoryFree() > 0))
}
