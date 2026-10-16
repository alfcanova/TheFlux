#L Teste de Erro de Execucao: RT701 - DIVISION_BY_ZERO
use MathStdLib as M

program (ExampleOfError_RT701_DivisionByZero) {
      print("--- Divisao Inteira por Zero (MathStdLib) ---")
      print((divideInt64(10, 0)).sta)
      print((divideInt64(10, 0)).msg)

      print("--- Divisao Decimal por Zero (MathStdLib) ---")
      print((divideFloat64(10.0, 0.0)).sta)
      print((divideFloat64(10.0, 0.0)).msg)

      print("--- Operadores Aritmeticos Infixos por Zero ---")
      mut as int64: q = 10 /i 0
      print(q)
      mut as int64: rem = 10 /r 0
      print(rem)
}
