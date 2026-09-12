program (ExampleOfRouteLogical) {
      mut as float64: nota = 8.5
      mut as float64: frequencia = 90.0

      route {
            nota >= 9.0 and frequencia >= 95.0 ==> {
                  print("Conceito A: Excelente!")
            }
            nota >= 7.0 and frequencia >= 75.0 ==> {
                  print("Conceito B: Aprovado")
            }
            nota >= 5.0 or frequencia >= 75.0 ==> {
                  print("Conceito C: Recuperacao")
            }
            not (nota >= 5.0 or frequencia >= 75.0) ==> {
                  print("Conceito D: Reprovado")
            }
      }
}
