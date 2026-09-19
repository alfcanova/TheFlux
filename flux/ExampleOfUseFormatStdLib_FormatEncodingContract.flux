use FormatStdLib

program (ExampleOfUseFormatStdLib_FormatEncodingContract) {
      println("==================================================")
      println("  Exemplo: FormatEncodingContract (Base64 & Query String)")
      println("==================================================")

      mut as string: raw_text = "TheFlux 2026 Standard Library"
      mut as string: b64 = formatEncodeBase64(raw_text)
      println("1. Encode Base64: " + b64)
      println("2. Decode Base64: " + formatDecodeBase64(b64))
      println("3. Valido Base64: " + formatIsValidBase64(b64))
      println("4. Invalido Base64: " + formatIsValidBase64("abcde"))

      mut as string: qs = "page=1&limit=50&sort=desc"
      mut as map: params = formatParseQueryString(qs)
      println("5. Parse Query String: " + params)
      println("6. Stringify Query String: " + formatStringifyQueryString(params))
}
