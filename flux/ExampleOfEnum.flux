enum (Estado) {
      Aberto
      Fechado
      Suspenso
}

enum (Resultado) {
      Ok(
            .valor: int64
      )
      Erro(
            .mensagem: string
      )
}

program (ExampleOfEnum) {
      print("=== Enum: variante unitaria ===")
      mut as Estado: estado = Estado::Aberto
      print(estado)

      print("=== Enum: variante com payload ===")
      mut as Resultado: resposta = Resultado::Ok(
            .valor: 42
      )
      print(resposta)

      print("=== Enum: pattern matching ===")
      match (resposta) {
            Resultado::Ok(
                  .valor: valor
            ) ==> print("Ok com valor: " + valor)
            Resultado::Erro(
                  .mensagem: mensagem
            ) ==> print("Erro: " + mensagem)
      }

      mut as Resultado: erro = Resultado::Erro(
            .mensagem: "falhou"
      )
      match (erro) {
            Resultado::Ok(
                  .valor: valor
            ) ==> print("Ok com valor: " + valor)
            Resultado::Erro(
                  .mensagem: mensagem
            ) ==> print("Erro: " + mensagem)
      }
}