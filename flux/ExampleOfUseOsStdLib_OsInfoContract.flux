use OsStdLib

program (ExampleOfUseOsStdLib_OsInfoContract) {
      println("==================================================")
      println("  Exemplo: OsInfoContract (Informacoes do Sistema)")
      println("==================================================")

      println("1. Plataforma: " + osPlatform())
      println("2. Arquitetura: " + osArch())
      println("3. Familia do SO: " + osFamily())
      println("4. Hostname: " + osHostname())
      mut as string: lsep = "LF"
      route {
            osLineSeparator() == "\r\n" ==> {
                  lsep = "CRLF"
            }
      }
      println("5. Separador de Linha: " + lsep)
      println("6. Separador de Path: " + osPathSeparator())
      println("7. Separador de Diretorio: " + osDirSeparator())
      println("8. Resumo do Sistema: " + osInfoSummary())
      println("9. E Windows: " + osIsWindows())
      println("10. E Linux: " + osIsLinux())
      println("11. E Darwin: " + osIsDarwin())
}
