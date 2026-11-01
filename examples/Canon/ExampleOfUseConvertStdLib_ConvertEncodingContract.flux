use ConvertStdLib

program (ExampleOfUseConvertStdLib_ConvertEncodingContract) {
      println("==================================================")
      println("  Exemplo: ConvertEncodingContract (ASCII, Base64, Hex String)")
      println("==================================================")

      #L 1. Caracteres e Tabela ASCII (Ord / Chr / CharToAscii / AsciiToChar)
      println("1. convertOrd('A'): " + convertOrd("A"))
      println("   convertCharToAscii('A'): " + convertCharToAscii("A"))
      println("   convertOrd('z'): " + convertOrd("z"))
      println("   convertOrd('0'): " + convertOrd("0"))
      println("   convertChr(65): " + convertChr(65))
      println("   convertAsciiToChar(65): " + convertAsciiToChar(65))
      println("   convertChr(122): " + convertChr(122))
      println("   convertChr(48): " + convertChr(48))

      #L 2. Codificacao e Decodificacao Base64 (RFC 4648)
      mut as string: b64_1 = convertStringToBase64("Flux")
      mut as string: b64_2 = convertStringToBase64("Hello, TheFlux World!")
      println("2. convertStringToBase64('Flux'): " + b64_1)
      println("   convertBase64ToString('" + b64_1 + "'): " + convertBase64ToString(b64_1))
      println("   convertStringToBase64('Hello, TheFlux World!'): " + b64_2)
      println("   convertBase64ToString('" + b64_2 + "'): " + convertBase64ToString(b64_2))

      #L 3. Codificacao Hex String (Texto <-> Bytes Hex)
      mut as string: hex_str = convertStringToHex("Flux")
      println("3. convertStringToHex('Flux'): " + hex_str)
      println("   convertHexToString('" + hex_str + "'): " + convertHexToString(hex_str))
}
