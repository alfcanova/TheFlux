use FinStdLib

program (ExampleOfUseFinStdLib_FinComparisonContract) {
      println("==================================================")
      println("  Exemplo: FinComparisonContract (Comparacoes)")
      println("==================================================")

      #L 1. Inicializacao de Decimais
      mut as FinDecimal: a = (finCreateDecimal("150.00")).val
      mut as FinDecimal: b = (finCreateDecimal("200.00")).val
      mut as FinDecimal: c = (finCreateDecimal("150.00")).val
      mut as FinDecimal: zero = (finCreateDecimal("0.00")).val
      mut as FinDecimal: neg = (finCreateDecimal("-50.25")).val

      #L 2. Igualdade e Comparacao Relacional
      mut as bool: eq_ac = (finEquals(a, c)).val
      mut as bool: eq_ab = (finEquals(a, b)).val
      mut as int64: cmp_ab = (finCompare(a, b)).val
      mut as int64: cmp_ba = (finCompare(b, a)).val
      mut as int64: cmp_aa = (finCompare(a, c)).val
      println("1. a == c: " + eq_ac)
      println("   a == b: " + eq_ab)
      println("   Compare(a, b): " + cmp_ab)
      println("   Compare(b, a): " + cmp_ba)
      println("   Compare(a, c): " + cmp_aa)

      #L 3. Operadores Maior / Menor
      mut as bool: gt = (finGt(b, a)).val
      mut as bool: gte = (finGte(a, c)).val
      mut as bool: lt = (finLt(a, b)).val
      mut as bool: lte = (finLte(a, c)).val
      println("2. b > a: " + gt)
      println("   a >= c: " + gte)
      println("   a < b: " + lt)
      println("   a <= c: " + lte)

      #L 4. Checagem de Zero e Sinais
      mut as bool: is_z = (finIsZero(zero)).val
      mut as bool: is_pos = (finIsPositive(a)).val
      mut as bool: is_neg = (finIsNegative(neg)).val
      println("3. zero eh zero: " + is_z)
      println("   a eh positivo: " + is_pos)
      println("   neg eh negativo: " + is_neg)

      #L 5. Intervalo e Saldo Valido
      mut as bool: in_range = (finBetween(a, zero, b)).val
      mut as bool: out_range = (finBetween(neg, zero, b)).val
      mut as bool: valid_bal = (finIsValidBalance(a)).val
      mut as bool: invalid_bal = (finIsValidBalance(neg)).val
      println("4. a entre 0 e b: " + in_range)
      println("   neg entre 0 e b: " + out_range)
      println("   Saldo 'a' eh valido: " + valid_bal)
      println("   Saldo 'neg' eh valido: " + invalid_bal)
}
