program (ExampleOfArithmetic) {
      print("=== Arithmetic: soma, subtracao, multiplicacao ===")
      mut as int64: soma = 2 + 3
      mut as int64: sub = 10 - 4
      mut as int64: mult = 6 * 7
      print(soma)
      print(sub)
      print(mult)

      print("=== Arithmetic: divisoes especializadas ===")
      mut as int64: div_int = 7 /i 2
      mut as float64: div_dec = 7 /f 2
      mut as int64: resto = 7 /r 2
      print(div_int)
      print(div_dec)
      print(resto)

      print("=== Arithmetic: potencia e raiz ===")
      mut as int64: pot = 2 ^e 3
      mut as float64: raiz = 27 ^r 3
      print(pot)
      print(raiz)
}