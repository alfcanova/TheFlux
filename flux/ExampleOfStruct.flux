struct (Evento) {
      mut: .nome: string
      imut: .QUANDO: datetime
      mut: .contador: int64
}

program (ExampleOfStruct) {
      print("=== Struct: inicializacao ===")
      mut as Evento: evento_atual = Evento(
            .nome: "inicio"
            .QUANDO: 1970-01-01T00:00:00.000000000Z
            .contador: 1
      )
      print(evento_atual)

      print("=== Struct: acesso aos campos ===")
      print(evento_atual.nome)
      print(evento_atual.QUANDO)
      print(evento_atual.contador)

      print("=== Struct: atribuicao a campo mutavel ===")
      evento_atual.contador = 2
      print(evento_atual.contador)

      print("=== Struct: pattern matching ===")
      match (evento_atual) {
            Evento(
                  .nome: nome
                  .QUANDO: quando
                  .contador: contador
            ) ==> print(nome + " / " + contador)
      }
}