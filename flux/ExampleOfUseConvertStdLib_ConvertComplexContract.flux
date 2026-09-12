use ConvertStdLib

program (ExampleOfUseConvertStdLib_ConvertComplexContract) {
      println("==================================================")
      println("  Exemplo: ConvertComplexContract (Numeros Complexos)")
      println("==================================================")

      #L 1. Criacao de complexos com diferentes componentes de float
      mut as complex64: c64 = convertToComplex(1.5, -2.5)
      mut as complex32: c32 = convertToComplex32(3.14, 2.71)
      mut as complex128: c128 = convertToComplex128(10.5, 20.25)
      println("1. convertToComplex(1.5, -2.5) [complex64]: " + c64)
      println("   convertToComplex32(3.14, 2.71) [complex32]: " + c32)
      println("   convertToComplex128(10.5, 20.25) [complex128]: " + c128)

      #L 2. Operacoes Aritmeticas com Complexos
      mut as complex64: soma = c64 + convertToComplex(0.5, 2.5)
      println("2. Soma de complexos: " + soma)

      #L 3. Complexo para Lista
      mut as list of data: l = convertComplexToList(c64)
      println("3. convertComplexToList(c64): " + l)
}
