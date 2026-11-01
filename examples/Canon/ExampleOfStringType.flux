program (ExampleOfStringType) {
      print("=== StringType: dinamica ===")
      mut as string: nome = "TheFlux"
      mut as string: saudacao = "Olá, " + nome
      print(saudacao)

      print("=== StringType: estatica string(N) ===")
      mut as string(16): codigo = "A1B2"
      print(codigo)

      print("=== StringType: char (code point) ===")
      mut as char: letra = 'A'
      mut as char: omega = '\u{03A9}'
      mut as char: acento = 'ê'
      mut as char: emoji = '\u{1F600}'
      print(letra)
      print(omega)
      print(acento)
      print(emoji)

      print("=== StringType: string + char ===")
      print("letra: " + letra)
      print("emoji: " + emoji)
}