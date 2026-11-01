use FormatStdLib

program (ExampleOfUseFormatStdLib_FormatJsonContract) {
      println("==================================================")
      println("  Exemplo: FormatJsonContract (JSON RFC 8259)")
      println("==================================================")

      mut as string: json_str = "{\"nome\": \"Flux\", \"versao\": 1, \"ativo\": true}"
      mut as data: parsed = formatParseJson(json_str)
      println("1. Parse JSON: " + parsed)
      println("2. Stringify JSON: " + formatStringifyJson(parsed))
      println("3. Valido (json_str): " + formatIsValidJson(json_str))
      println("4. Invalido: " + formatIsValidJson("{invalido}"))

      mut as string: raw_fmt = "{\n  \"a\": 10,\n  \"b\": 20\n}"
      println("5. Minify: " + formatMinifyJson(raw_fmt))
      println("6. Pretty: " + formatPrettyJson(json_str, 2))
}
