program (ExampleOfList) {
      println("=== List: declaracao e literais ===")
      mut as list of int64: xs = [10, 20, 30]
      println("Lista inicial: " + xs)

      println("=== List: acesso 1-based ===")
      println("Primeiro item (1): " + xs[1])
      println("Terceiro item (3): " + xs[3])

      println("=== List: atribuicao por indice ===")
      xs[2] = 25
      println("Apos xs[2] = 25: " + xs)

      println("=== List: growth por atribuicao indexada ===")
      xs[4] = 40
      println("Apos xs[4] = 40: " + xs)

      println("=== List: fatias (slices 1-based) ===")
      mut as list of int64: items = [10, 20, 30, 40, 50]
      println("Fatia da posicao 2 ate 3: " + items[2..3])
      println("Fatia do inicio ate 2: " + items[..2])
      println("Fatia de 3 ate fim: " + items[3..])
      println("Fatia completa: " + items[..])

      println("=== List: atribuicao por indice final ===")
      mut as list of int64: finais = [10, 20, 30]
      finais[1] = 15
      finais[3] = 35
      println("List final: " + finais)

      println("=== List: iteracao ===")
      infinite (x in items) {
            println("item: " + x)
      }

      println("=== List: pattern matching ===")
      match (xs) {
            [first, ..rest] ==> {
                  println("primeiro: " + first)
                  println("resto: " + rest)
            }
            _ ==> none
      }
}
