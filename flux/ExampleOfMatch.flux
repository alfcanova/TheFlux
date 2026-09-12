struct (Evento) {
      mut: .nome: string
      mut: .quando: datetime
      mut: .contador: int64
}

enum (Resultado) {
      Ok(
            .valor: int64
      )
      Erro(
            .mensagem: string
      )
}

program (ExampleOfMatch) {
      print("=== Match: literais ===")
      mut as int64: valor = 1
      match (valor) {
            1 ==> print("um")
            2 ==> print("dois")
            _ ==> print("outro")
      }

      print("=== Match: struct ===")
      mut as Evento: evento = Evento(
            .nome: "inicio"
            .quando: 1970-01-01T00:00:00.000000000Z
            .contador: 1
      )
      match (evento) {
            Evento(
                  .nome: nome
                  .quando: quando
                  .contador: contador
            ) ==> print(nome + " / " + contador)
      }

      print("=== Match: enum com guard ===")
      mut as Resultado: resposta = Resultado::Ok(
            .valor: 5
      )
      match (resposta) {
            Resultado::Ok(
                  .valor: val
            ) (val >= 0) ==> print("positivo: " + val)
            Resultado::Ok(
                  .valor: val
            ) ==> print("negativo: " + val)
            Resultado::Erro(
                  .mensagem: msg
            ) ==> print(msg)
      }

      print("=== Match: registro ===")
      mut as data: registro = {.tipo: "sensor", .valor: 9}
      match (registro) {
            {
                  .tipo: "sensor"
                  .valor: val
            } ==> print("sensor valor: " + val)
            _ ==> print("desconhecido")
      }
}