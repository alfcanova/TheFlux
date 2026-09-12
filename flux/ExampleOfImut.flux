program (ExampleOfImut) {
      print("=== Imut: constante com valor inicial ===")
      imut as int64: MAX_TENTATIVAS = 10
      imut as string: NOME_APP = "TheFlux"
      print(MAX_TENTATIVAS)
      print(NOME_APP)

      print("=== Imut: declaracao multipla em linha ===")
      imut as float64: PI1, PI2 = 3.14159
      print(PI1)
      print(PI2)
}