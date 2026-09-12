program (ExampleOfRoute) {
      print("=== Route: primeiro arm ===")
      route {
            true ==> { print("Testando saida do primeiro arm") }
            false ==> { print("Nunca executa") }
      }

      print("=== Route: segundo arm ===")
      route {
            false ==> { print("Nunca executa") }
            true ==> { print("Arm2: segundo arm acionado") }
      }

      print("=== Route: nenhum arm acionado ===")
      route {
            false ==> { print("Nunca executa") }
            false ==> { print("Nunca executa 2") }
            _ ==> { print("Nenhum arm foi acionado") }
      }

      print("=== Route: multiplos arms ===")
      route {
            1 == 1 ==> { print("um") }
            2 == 2 ==> { print("dois") }
            _ ==> { print("nenhum") }
      }

      print("=== Route: com sujeitos ===")
      mut as string: status = "ativo"
      route (status) {
            "manutencao" ==> { print("Acesso bloqueado") }
            "ativo" ==> { print("Conexao ativa") }
            _ ==> { print("Estado desconhecido") }
      }

      print("=== Route: aninhado ===")
      mut as int64: x = 5
      route {
            x > 0 ==> {
                  route {
                        x > 10 ==> { print("grande") }
                        _ ==> { print("pequeno") }
                  }
            }
            _ ==> { print("negativo") }
      }
}