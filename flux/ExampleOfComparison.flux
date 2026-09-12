program (ExampleOfComparison) {
      print("=== Comparison: operadores relacionais ===")
      print(1 == 1)
      print(1 != 2)
      print(1 < 2)
      print(2 > 1)
      print(2 <= 2)
      print(2 >= 3)

      print("=== Comparison: igualdade com sujeito em route ===")
      mut as string: comando = "start"
      route (comando) {
            "start" ==> { print("Iniciando...") }
            "stop" ==> { print("Parando...") }
            _ ==> { print("Desconhecido") }
      }

      print("=== Comparison: em expressao booleana ===")
      mut as float64: nota = 8.5
      mut as float64: frequencia = 80.0
      route {
            nota >= 7.0 and frequencia >= 75.0 ==> { print("Aprovado") }
            _ ==> { print("Reprovado") }
      }
}