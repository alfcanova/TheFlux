program (ExampleOfBreak) {
      print("=== Break: sai do loop infinito imediatamente ===")
      infinite {
            print("rodei")
            break
      }

      print("=== Break: condicional dentro do loop ===")
      mut as int64: i = 0
      infinite {
            i = i + 1
            route {
                  i == 3 ==> { break }
                  _ ==> { print(i) }
            }
      }
      print("saiu do loop com i = " + i)
}