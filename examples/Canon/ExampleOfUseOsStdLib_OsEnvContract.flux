use OsStdLib

program (ExampleOfUseOsStdLib_OsEnvContract) {
      println("==================================================")
      println("  Exemplo: OsEnvContract (Variaveis de Ambiente)")
      println("==================================================")

      #L 1. Leitura de variavel existente do SO ou com fallback
      println("1. Variavel 'OS': " + osGetEnvOrDefault("OS", "Windows_NT"))

      #L 2. Definicao e obtencao de nova variavel
      mut as bool: set_ok = osSetEnv("FLUX_APP_ENV", "Producao")
      println("2. osSetEnv('FLUX_APP_ENV', 'Producao'): " + set_ok)
      println("3. osGetEnv('FLUX_APP_ENV'): " + osGetEnv("FLUX_APP_ENV"))
      println("4. osHasEnv('FLUX_APP_ENV'): " + osHasEnv("FLUX_APP_ENV"))

      #L 3. Leitura com valor padrao
      println("5. osGetEnvOrDefault (inexistente): " + osGetEnvOrDefault("FLUX_VAR_INEXISTENTE", "ValorPadrao"))

      #L 4. Remocao de variavel
      mut as bool: unset_ok = osUnsetEnv("FLUX_APP_ENV")
      println("6. osUnsetEnv: " + unset_ok)
      println("7. osHasEnv apos unset: " + osHasEnv("FLUX_APP_ENV"))

      #L 5. Listagem de variaveis
      mut as list of data: envs = osListEnv()
      println("8. Total de Variaveis no Ambiente >= 1: " + (envs[1] != ""))
      println("9. Primeira Chave Nao Vazia: " + (envs[1] != ""))
}
