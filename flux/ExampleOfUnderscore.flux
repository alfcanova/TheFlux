#L Exemplo do Token Wildcard / Underscore (_) na linguagem TheFlux

#D
- Programa: ExampleOfUnderscore
- Descricao: Demonstracao do uso do curinga (_) em rotas, casamento de padroes e descarte
- Autor: TheFlux
- Versao: 0.5
D#
program (ExampleOfUnderscore) {
      print("=== 1. Wildcard (_) em Route ===")
      mut as string: status = "ativo"
      route {
            status == "inativo" ==> { print("Status inativo") }
            status == "ativo"   ==> { print("Conexao ativa") }
            _                   ==> { print("Status desconhecido") }
      }

      print("=== 2. Wildcard (_) em Match ===")
      mut as int64: codigo = 999
      match (codigo) {
            200 ==> print("Sucesso")
            404 ==> print("Nao encontrado")
            _   ==> print("Outro codigo: padrao curinga")
      }

      print("=== 3. Wildcard (_) em Registro ===")
      mut as data: info = {.tipo: "sensor", .leitura: 42}
      match (info) {
            {
                  .tipo: "sensor"
                  .leitura: val
            } ==> print("Sensor ativo com leitura: " + val)
            _ ==> print("Registro nao reconhecido")
      }
}
