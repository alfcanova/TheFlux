use FormatStdLib

program (ExampleOfUseFormatStdLib_FormatTomlContract) {
      println("==================================================")
      println("  Exemplo: FormatTomlContract (TOML)")
      println("==================================================")

      mut as string: toml_text = "titulo = \"Configuracao Flux\"\nversao = 2\n\n[banco]\nhost = \"localhost\"\nporta = 5432"
      mut as map: parsed_toml = formatParseToml(toml_text)
      println("1. Parse TOML: " + parsed_toml)
      println("2. Stringify TOML: " + formatStringifyToml(parsed_toml))
      println("3. Valido (toml_text): " + formatIsValidToml(toml_text))
      println("4. Invalido: " + formatIsValidToml("isto nao e toml valido"))
}
