program (ExampleOfScalar) {
      print("=== Scalar: tipo char ===")
      mut as char: letra = 'A'
      mut as char: escape = '\n'
      mut as char: acento = 'é'
      mut as char: emoji = '\u{1F600}'
      print("letra: ", letra)
      print("escape: [", escape, "]")
      print("acento: ", acento)
      print("emoji: ", emoji)
      print("char == char: ", letra == 'A')

      print("=== Scalar: tipo bool ===")
      mut as bool: ativo = true
      mut as bool: completo = false
      print(ativo)
      print(completo)

      print("=== Scalar: tipo datetime ===")
      mut as datetime: momento = 1970-01-01T00:00:00.000000000Z
      mut as datetime: local = 2024-01-01T12:30:00.123456789-03:00
      print(momento)
      print(local)

      print("=== Scalar: tipo string ===")
      mut as string: nome = "TheFlux"
      mut as string: msg = "Contador: #{ativo}"
      print(nome)
      print(msg)
}