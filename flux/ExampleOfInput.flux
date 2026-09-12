program (ExampleOfInput) {
      mut as string: nome = input("Introduza o seu nome: ")
      print("Bem-vindo, " + nome)

      mut as int64: idade = input("Introduza a sua idade: ")
      print("Idade: " + idade)

      mut as float64: preco = input("Preco: ")
      print("Preco: " + preco)

      mut as bool: ativo = input("Ativo? ")
      print("Ativo: " + ativo)

      mut as char: ch = input("Caractere: ")
      print("Char: " + ch)

      mut as complex128: c = input("Numero complexo: ")
      print("Complex: ", c)

      mut as datetime: dt = input("Data: ")
      print("Data: ", dt)
}
