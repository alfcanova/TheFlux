use FinStdLib

program (ExampleOfUseFinStdLib_FinFormatContract) {
      println("==================================================")
      println("  Exemplo: FinFormatContract (Formatacao Monetaria)")
      println("==================================================")

      mut as FinDecimal: v1 = (finCreateDecimal("1234.56")).val
      mut as FinDecimal: v2 = (finCreateDecimal("-99.90")).val

      #L 1. Formatacao em BRL (pt-BR)
      mut as string: f_br1 = (finFormatCurrency(v1, "pt-BR")).val
      mut as string: f_br2 = (finFormatCurrency(v2, "pt-BR")).val
      println("1. Formatacao BRL:")
      println("   Positivo: " + f_br1)
      println("   Negativo: " + f_br2)

      #L 2. Formatacao em USD / Padrao Internacional
      mut as string: f_us1 = (finFormatCurrency(v1, "en-US")).val
      mut as string: f_us2 = (finFormatCurrency(v2, "en-US")).val
      println("2. Formatacao USD:")
      println("   Positivo: " + f_us1)
      println("   Negativo: " + f_us2)

      #L 3. Parsing de Moeda Textual para FinDecimal
      mut as FinDecimal: p1 = (finParseCurrency("R$ 2500,75")).val
      mut as FinDecimal: p2 = (finParseCurrency("-$ 50.25")).val
      println("3. Parsing de Moeda:")
      println("   Parsed 'R$ 2500,75': " + (finDecimalToString(p1)).val)
      println("   Parsed '-$ 50.25': " + (finDecimalToString(p2)).val)

      #L 4. Formatacao de Taxas Percentuais (finFormatPercent)
      mut as string: pct1 = (finFormatPercent(0.126825, 2)).val
      mut as string: pct2 = (finFormatPercent(0.0003316, 4)).val
      mut as string: pct3 = (finFormatPercent(-0.05, 1)).val
      println("4. Formatacao Percentual:")
      println("   Taxa 0.126825 (2 dec): " + pct1)
      println("   Taxa 0.0003316 (4 dec): " + pct2)
      println("   Taxa -0.05 (1 dec): " + pct3)
}
