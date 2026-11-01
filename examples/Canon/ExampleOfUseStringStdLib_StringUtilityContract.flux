use StringStdLib

program (ExampleOfUseStringStdLib_StringUtilityContract) {
      println("==================================================")
      println("  Exemplo: StringUtilityContract (4 Operacoes)")
      println("==================================================")

      println("1. stringCompare(\"abc\", \"abd\"): " + stringCompare("abc", "abd"))
      println("2. stringEqualsIgnoreCase(\"TheFlux\", \"THEFLUX\"): " + stringEqualsIgnoreCase("TheFlux", "THEFLUX"))

      mut as list of data: parts = stringSplit("alpha,beta,gamma", ",")
      println("3. stringSplit(\"alpha,beta,gamma\", \",\"): " + parts)
      println("4. stringJoin(parts, \" -> \"): " + stringJoin(parts, " -> "))
}
