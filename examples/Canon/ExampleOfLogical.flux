program (ExampleOfLogical) {
      print("=== Logical: and / or / not ===")
      print(true and false)
      print(true or false)
      print(not true)
      print(!true)

      print("=== Logical: composicao de condicoes ===")
      mut as float64: nota = 9.5
      mut as float64: frequencia = 96.0
      route {
            nota >= 9.0 and frequencia >= 95.0 ==> { print("Excelente!") }
            nota >= 7.0 and frequencia >= 75.0 ==> { print("Aprovado") }
            nota >= 5.0 or frequencia >= 75.0 ==> { print("Recuperacao") }
            _ ==> { print("Reprovado") }
      }

      print("=== Logical: negacao ===")
      route {
            not (nota >= 5.0 or frequencia >= 75.0) ==> { print("Reprovado") }
            _ ==> { print("Passou") }
      }
}