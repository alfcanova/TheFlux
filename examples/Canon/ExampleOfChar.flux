mut as char: letra = 'A'
mut as char: digito = '7'
mut as char: espaco = ' '
mut as char: nova_linha = '\n'
mut as char: tabulacao = '\t'
mut as char: omega = '\u{03A9}'
mut as char: acento = 'ê'
mut as char: emoji = '\u{1F600}'

program (ExampleOfChar) {
      print("=== Char: caractere simples ===")
      print("letra: ", letra)
      print("digito: ", digito)

      print("=== Char: espaco ===")
      print("espaco: [", espaco, "]")

      print("=== Char: escapes ===")
      print("nova_linha: [", nova_linha, "]")
      print("tabulacao: [", tabulacao, "]")

      print("=== Char: code point unicode ===")
      print("omega: ", omega)
      print("acento: ", acento)
      print("emoji: ", emoji)

      print("=== Char: comparacao e concat ===")
      print("A == A: ", letra == 'A')
      print("A == emoji: ", letra == emoji)
      print("concat: ", "letra: " + letra)
      print("concat acento: ", "acento: " + acento)
      print("concat emoji: ", "emoji: " + emoji)
}