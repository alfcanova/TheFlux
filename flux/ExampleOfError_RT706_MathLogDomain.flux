#L Teste de Erro de Execucao: RT706 - MATH_DOMAIN_LOG
use MathStdLib as M

program (ExampleOfError_RT706_MathLogDomain) {
      print("--- Logaritmo Natural com Argumento Zero ---")
      print((log64(0.0)).sta)
      print((log64(0.0)).msg)

      print("--- Logaritmo Natural com Argumento Negativo ---")
      print((log64(-5.0)).sta)
      print((log64(-5.0)).msg)

      print("--- Logaritmo Base 10 com Argumento Zero ---")
      print((log10_64(0.0)).sta)
      print((log10_64(0.0)).msg)

      print("--- Logaritmo Base 2 com Argumento Negativo ---")
      print((log2_64(-1.0)).sta)
      print((log2_64(-1.0)).msg)
}
