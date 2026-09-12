program (ExampleOfString) {
      println("=== 1. Literais, UTF-8 e Escapes ===")
      mut as string: simples = "TheFlux"
      mut as string: vazia = ""
      mut as string: utf8 = "Olá, mundo! \u{03C0}"
      mut as string: escapes = "Linha 1\nLinha 2\tColuna 2\tC:\\TheFlux"
      println("Simples: " + simples)
      println("Vazia: [" + vazia + "]")
      println("UTF-8: " + utf8)
      println("Escapes:\n" + escapes)

      println("=== 2. Tipagem (Dinamica e Estatica) ===")
      mut as string: dinamica = "Tamanho dinamico"
      mut as string(32): estatica = "Capacidade fixa 32 bytes"
      imut as string: imutavel = "Valor constante imutavel"
      println("Dinamica: " + dinamica)
      println("Estatica: " + estatica)
      println("Imutavel: " + imutavel)

      println("=== 3. Concatenacao e Casts ===")
      mut as string: concat = "Linguagem: " + simples + " (v" + (1 as string) + ")"
      println(concat)
      println("Concat com Int: " + ("Valor = " + 42))
      println("Concat com Float: " + ("Pi approx = " + 3.14))
      println("Concat com Bool: " + ("Status = " + true + " / " + false))

      println("=== 4. Interpolacao de Strings ===")
      mut as int64: x = 10
      mut as int64: y = 25
      println("Valores: x = #{x}, y = #{y}")
      println("Soma calculada: #{x + y}")

      println("=== 5. Comparacoes Nativas ===")
      println("Igualdade: #{"abc" == "abc"}")
      println("Diferenca: #{"abc" != "xyz"}")
      println("Menor que: #{"apple" < "banana"}")
      println("Maior que: #{"zebra" > "apple"}")

      println("=== 6. Indexacao e Fatiamento (1-Index) ===")
      mut as string: alfabeto = "ABCDEFGH"
      println("Primeiro caractere (alfabeto[1]): " + alfabeto[1])
      println("Quarto caractere (alfabeto[4]): " + alfabeto[4])
      println("Fatia 1..4 (alfabeto[1..4]): " + alfabeto[1..4])
      println("Fatia 5..8 (alfabeto[5..8]): " + alfabeto[5..8])
      println("Fatia 3..6 (alfabeto[3..6]): " + alfabeto[3..6])

      println("=== 7. Iteracao e Algoritmos Nativos (Sem StdLib) ===")
      mut as string: palavra = "TheFlux"
      mut as int64: contagem = 0
      mut as string: reversa = ""
      infinite (c in palavra) {
            contagem = contagem + 1
            reversa = c + reversa
      }
      println("Palavra: " + palavra)
      println("Comprimento nativo: #{contagem}")
      println("Reversao nativa: " + reversa)
}
