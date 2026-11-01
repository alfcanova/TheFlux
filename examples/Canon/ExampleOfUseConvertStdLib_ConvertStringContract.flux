use ConvertStdLib

enum (Estado) {
      Ativo
      Inativo
}

program (ExampleOfUseConvertStdLib_ConvertStringContract) {
      println("==================================================")
      println("  Exemplo: ConvertStringContract (Formatacao Textual)")
      println("==================================================")

      #L 1. Valores primitivos para String
      println("1. convertIntToString(42): [" + convertIntToString(42) + "]")
      println("   convertFloatToString(3.1415): [" + convertFloatToString(3.1415) + "]")
      println("   convertBoolToString(true): [" + convertBoolToString(true) + "]")

      #L 2. Colecoes e Enums para String
      mut as list of int64: lista = [1, 2, 3]
      mut as Estado: est = Estado::Ativo
      println("2. convertToString([1, 2, 3]): " + convertToString(lista))
      println("   convertEnumToString(Estado::Ativo): " + convertEnumToString(est))
}
