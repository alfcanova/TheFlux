program (ExampleOfRouteMembership) {
      mut as map: dados = map{.nome of string: "Alice", .idade of string: 30, .cidade of string: "Rio"}
      mut as map: mapa = map{.chave1 of string: 100, .chave2 of string: 200, .chave3 of string: 300}
      mut as set of int64: conjunto = { 1, 2, 3, 5, 8, 13 }

      #L Validacao de pertencimento em data (record) via acesso a campo
      route {
            dados["nome"] == "Alice" ==> {
                  print("O registro tem nome 'Alice'")
            }
            dados["cidade"] == "Rio" ==> {
                  print("O registro tem cidade 'Rio'")
            }
            _ ==> {
                  print("Registro nao reconhecido")
            }
      }

      #L Validacao de pertencimento em map via acesso a chave
      route {
            mapa["chave1"] == 100 ==> {
                  print("Mapa tem chave1 com valor 100")
            }
            mapa["chave2"] == 200 ==> {
                  print("Mapa tem chave2 com valor 200")
            }
            _ ==> {
                  mut as int64: val = mapa["chaveX"]
                  print("Valor da chave inexistente: " + val)
            }
      }

      #L Validacao de pertencimento em set via iteracao
      mut as int64: valor = 8
      mut as bool: encontrou = false
      infinite (item in conjunto) {
            route {
                  item == valor ==> {
                        encontrou = true
                  }
            }
      }
      route {
            encontrou == true ==> {
                  print("#{valor} pertence ao conjunto de Fibonacci via iteracao")
            }
            _ ==> {
                  print("#{valor} NAO pertence ao conjunto")
            }
      }
}
