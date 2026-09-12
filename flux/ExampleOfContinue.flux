program (ExampleOfContinue) {
      print("=== Continue: pula a iteracao atual ===")
      mut as int64: i = 0
      infinite {
            i = i + 1
            route {
                  i == 3 ==> { continue }
                  _ ==> { print("ainda: " + i) }
            }
            route {
                  i == 5 ==> { break }
                  _ ==> { print("dentro") }
            }
      }
      print("fim do loop")
}