use FinStdLib

program (ExampleOfUseFinStdLib_FinDecimalContract) {
      println("==================================================")
      println("  Exemplo: FinDecimalContract (Aritmetica FinDecimal)")
      println("==================================================")

      #L 1. Criacao e Conversoes
      mut as FinDecimal: a = (finCreateDecimal("100.50")).val
      mut as FinDecimal: b = (finFromInt(25)).val
      mut as FinDecimal: c = (finFromFloat(10.25)).val
      println("1. FinDecimal a: " + (finDecimalToString(a)).val)
      println("   FinDecimal b: " + (finDecimalToString(b)).val)
      println("   FinDecimal c: " + (finDecimalToString(c)).val)
      println("   Float c: " + (finDecimalToFloat(c)).val)

      #L 2. Operacoes Aritmeticas Basicas
      mut as FinDecimal: soma = (finAdd(a, b)).val
      mut as FinDecimal: sub = (finSubtract(a, b)).val
      mut as FinDecimal: mul = (finMultiply(b, c)).val
      mut as FinDecimal: div = (finDivide(a, b)).val
      println("2. Soma (a + b): " + (finDecimalToString(soma)).val)
      println("   Subtracao (a - b): " + (finDecimalToString(sub)).val)
      println("   Multiplicacao (b * c): " + (finDecimalToString(mul)).val)
      println("   Divisao (a / b): " + (finDecimalToString(div)).val)

      #L 3. Arredondamento Contabil
      mut as FinDecimal: val_arr = (finCreateDecimal("123.456789")).val
      mut as FinDecimal: arr_even = (finRound(val_arr, 2, RoundingMode::FinHalfEven)).val
      mut as FinDecimal: arr_up = (finRound(val_arr, 2, RoundingMode::FinHalfUp)).val
      println("3. Original: " + (finDecimalToString(val_arr)).val)
      println("   FinHalfEven (2 dec): " + (finDecimalToString(arr_even)).val)
      println("   FinHalfUp (2 dec): " + (finDecimalToString(arr_up)).val)

      #L 4. Valor Absoluto e Negacao
      mut as FinDecimal: neg = (finNegate(a)).val
      mut as FinDecimal: abs_val = (finAbs(neg)).val
      println("4. Negacao de a: " + (finDecimalToString(neg)).val)
      println("   Absoluto: " + (finDecimalToString(abs_val)).val)

      #L 5. Minimo, Maximo e Clamp
      mut as FinDecimal: menor = (finMin(a, b)).val
      mut as FinDecimal: maior = (finMax(a, b)).val
      mut as FinDecimal: limitador = (finClamp(a, b, c)).val
      println("5. Menor entre a e b: " + (finDecimalToString(menor)).val)
      println("   Maior entre a e b: " + (finDecimalToString(maior)).val)
      println("   Clamp de a entre b e c: " + (finDecimalToString(limitador)).val)

      #L 6. Divisao de Parcela sem Perda de Centavos
      mut as FinDecimal: total_split = (finCreateDecimal("100.00")).val
      mut as list of data: parcelas = (finSplit(total_split, 3)).val
      println("6. Split de 100.00 em 3 parcelas:")
      println("   Parcela 1: " + parcelas[1])
      println("   Parcela 2: " + parcelas[2])
      println("   Parcela 3: " + parcelas[3])

      #L 7. Alocacao Proporcional com Resto em Centavos
      mut as list of data: pesos = [1, 2]
      mut as list of data: cotas = (finAllocate(total_split, pesos)).val
      println("7. Alocacao de 100.00 por pesos [1, 2]:")
      println("   Cota 1: " + cotas[1])
      println("   Cota 2: " + cotas[2])
}
