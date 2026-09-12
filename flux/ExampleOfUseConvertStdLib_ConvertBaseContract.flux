use ConvertStdLib

program (ExampleOfUseConvertStdLib_ConvertBaseContract) {
      println("==================================================")
      println("  Exemplo: ConvertBaseContract (Bases, Radix e Padding)")
      println("==================================================")

      #L 1. Hexadecimal Padrao e Padded
      println("1. convertIntToHex(255): " + convertIntToHex(255))
      println("   convertIntToHexPadded(255, 4): " + convertIntToHexPadded(255, 4))
      println("   convertIntToHexPadded(255, 8): " + convertIntToHexPadded(255, 8))
      println("   convertIntToHex(-42): " + convertIntToHex(-42))

      #L 2. Binario Padrao e Padded
      println("2. convertIntToBinary(11): " + convertIntToBinary(11))
      println("   convertIntToBinaryPadded(11, 8): " + convertIntToBinaryPadded(11, 8))
      println("   convertIntToBinary(255): " + convertIntToBinary(255))
      println("   convertIntToBinaryPadded(255, 16): " + convertIntToBinaryPadded(255, 16))

      #L 3. Octal Padrao e Padded
      println("3. convertIntToOctal(64): " + convertIntToOctal(64))
      println("   convertIntToOctalPadded(64, 4): " + convertIntToOctalPadded(64, 4))
      println("   convertIntToOctal(511): " + convertIntToOctal(511))
      println("   convertIntToOctalPadded(511, 6): " + convertIntToOctalPadded(511, 6))

      #L 4. Radix Generico (Base 2 ate 36)
      println("4. convertIntToRadix(255, 16): " + convertIntToRadix(255, 16))
      println("   convertIntToRadix(11, 2): " + convertIntToRadix(11, 2))
      println("   convertIntToRadix(35, 36): " + convertIntToRadix(35, 36))
      println("   convertIntToRadix(100, 36): " + convertIntToRadix(100, 36))

      #L 5. Parsing com Radix Generico
      println("5. convertParseRadix('FF', 16): " + convertParseRadix("FF", 16))
      println("   convertParseRadix('1011', 2): " + convertParseRadix("1011", 2))
      println("   convertParseRadix('Z', 36): " + convertParseRadix("Z", 36))
      println("   convertParseRadixOrDefault('invalido', 16, -1): " + convertParseRadixOrDefault("invalido", 16, -1))
}
