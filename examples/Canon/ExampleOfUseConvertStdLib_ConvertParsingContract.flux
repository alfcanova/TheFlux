use ConvertStdLib

program (ExampleOfUseConvertStdLib_ConvertParsingContract) {
      println("==================================================")
      println("  Exemplo: ConvertParsingContract (Parsing 1-Index)")
      println("==================================================")

      #L 1. Parsing de Inteiros
      println("1. convertParseInt('42'): " + convertParseInt("42"))
      println("   convertParseInt('-123'): " + convertParseInt("-123"))
      println("   convertParseInt('+999'): " + convertParseInt("+999"))
      println("   convertParseIntOrDefault('invalido', -1): " + convertParseIntOrDefault("invalido", -1))

      #L 2. Parsing de Floats
      println("2. convertParseFloat('3.1415'): " + convertParseFloat("3.1415"))
      println("   convertParseFloat('-0.75'): " + convertParseFloat("-0.75"))
      println("   convertParseFloatOrDefault('abc', 0.0): " + convertParseFloatOrDefault("abc", 0.0))

      #L 3. Parsing de Booleanos
      println("3. convertParseBool('true'): " + convertParseBool("true"))
      println("   convertParseBool('sim'): " + convertParseBool("sim"))
      println("   convertParseBool('0'): " + convertParseBool("0"))
      println("   convertParseBool('false'): " + convertParseBool("false"))

      #L 4. Parsing de Hexadecimal, Binario e Octal
      println("4. convertParseHex('0xFF'): " + convertParseHex("0xFF"))
      println("   convertParseHex('1A'): " + convertParseHex("1A"))
      println("   convertParseBinary('0b1011'): " + convertParseBinary("0b1011"))
      println("   convertParseOctal('0o77'): " + convertParseOctal("0o77"))
}
