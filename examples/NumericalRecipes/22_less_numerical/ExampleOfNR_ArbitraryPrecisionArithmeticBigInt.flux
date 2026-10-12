#L ============================================================================
#L Algoritmo: Arbitrary Precision Arithmetic BigInt (Aritmetica de Multi-Precisao)
#L Capitulo: 22_less_numerical
#L Complexidade: O(N_digitos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Aritmetica inteira de precisao arbitraria com propagacao de carry.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ArbitraryPrecisionArithmeticBigInt) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ArbitraryPrecisionArithmeticBigInt")
      println("==================================================")

      #L Dois inteiros gigantes representados como listas de digitos decimais (base 10):
      #L A = 8765 -> digitos: [8, 7, 6, 5]
      #L B = 4567 -> digitos: [4, 5, 6, 7]
      #L Soma exata A + B = 13332 -> digitos: [1, 3, 3, 3, 2]
      mut as list of int64: a = [8, 7, 6, 5]
      mut as list of int64: b = [4, 5, 6, 7]
      mut as list of int64: sum_digits = [0, 0, 0, 0, 0] #L [d4, d3, d2, d1, d0]

      println("1. Somando inteiros de precisao arbitraria A e B:")
      println("   -> A = 8765")
      println("   -> B = 4567")

      #L Adicao coluna a coluna da direita para a esquerda com carry:
      #L Posicao 4 (unidades): 5 + 7 = 12 -> digito = 2, carry = 1
      mut as int64: carry = 0
      mut as int64: s0 = a[4] + b[4] + carry
      sum_digits[5] = s0 /r 10
      carry = s0 /i 10

      #L Posicao 3 (dezenas): 6 + 6 + 1 = 13 -> digito = 3, carry = 1
      mut as int64: s1 = a[3] + b[3] + carry
      sum_digits[4] = s1 /r 10
      carry = s1 /i 10

      #L Posicao 2 (centenas): 7 + 5 + 1 = 13 -> digito = 3, carry = 1
      mut as int64: s2 = a[2] + b[2] + carry
      sum_digits[3] = s2 /r 10
      carry = s2 /i 10

      #L Posicao 1 (milhares): 8 + 4 + 1 = 13 -> digito = 3, carry = 1
      mut as int64: s3 = a[1] + b[1] + carry
      sum_digits[2] = s3 /r 10
      carry = s3 /i 10

      #L Posicao 0 (dezenas de milhares): carry final = 1
      sum_digits[1] = carry

      println("2. Digitos do BigInt resultado:")
      println("   -> Digitos = [" + sum_digits[1] + ", " + sum_digits[2] + ", " + sum_digits[3] + ", " + sum_digits[4] + ", " + sum_digits[5] + "]")

      #L Reconstituicao do valor decimal: 1*10000 + 3*1000 + 3*100 + 3*10 + 2 = 13332
      mut as int64: valor_total = (sum_digits[1] * 10000) + (sum_digits[2] * 1000) + (sum_digits[3] * 100) + (sum_digits[4] * 10) + sum_digits[5]
      println("   -> Valor BigInt reconstruido = " + valor_total + " (esperado: 13332)")

      mut as int64: residuo = valor_total - 13332
      println("3. Residuo da soma BigInt = " + residuo + " (esperado: 0)")
      println("4. Aritmetica de precisao arbitraria concluida com sucesso.")
}
