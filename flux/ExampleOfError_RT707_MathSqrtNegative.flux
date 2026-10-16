#L Teste de Erro de Execucao: RT707 - MATH_DOMAIN_SQRT
use MathStdLib as M

program (ExampleOfError_RT707_MathSqrtNegative) {
      print("--- Raiz Quadrada Float64 de Negativo ---")
      print((squareRoot64(-4.0)).sta)
      print((squareRoot64(-4.0)).msg)

      print("--- Raiz Quadrada Float32 de Negativo ---")
      print((squareRoot32(-9.0 as float32)).sta)
      print((squareRoot32(-9.0 as float32)).msg)

      print("--- Raiz Quadrada Float16 de Negativo ---")
      print((squareRoot16(-16.0 as float16)).sta)
      print((squareRoot16(-16.0 as float16)).msg)
}
