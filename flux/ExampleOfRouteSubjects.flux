program (ExampleOfRouteSubjects) {
      #L Exemplo de route com sujeito unico
      mut as string: status = "ativo"
      mut as float64: latencia = 30.0
      mut as int64: tentativas = 2

      #L Route com sujeito: status
      route (status) {
            "manutencao" ==> { print("Acesso bloqueado") }
            "ativo" ==> { print("Conexao ativa") }
            _ ==> { print("Estado desconhecido") }
      }

      #L Route com sujeito: latencia
      route (latencia) {
            latencia < 50 ==> { print("Latencia excelente") }
            latencia < 100 ==> { print("Latencia moderada") }
            _ ==> { print("Latencia alta") }
      }

      #L Route com sujeito: tentativas
      route (tentativas) {
            tentativas < 3 ==> { print("Poucas tentativas") }
            tentativas < 5 ==> { print("Tentativas moderadas") }
            _ ==> { print("Muitas tentativas") }
      }

      #L Route sem sujeito (expressao completa)
      route {
            status == "manutencao" or tentativas >= 10 ==> {
                  print("Acesso bloqueado (expressao)")
            }
            status == "ativo" and latencia < 50 and tentativas < 3 ==> {
                  print("Conexao excelente (expressao)")
            }
            _ ==> {
                  print("Estado desconhecido (expressao)")
            }
      }

      #L Exemplo com 2 sujeitos (usando expressao completa)
      mut as float64: temperatura = 38.5
      mut as string: pressao = "normal"

      route {
            temperatura > 40 and pressao == "alta" ==> { print("PERIGO: Urgencia!") }
            temperatura > 37.5 ==> { print("Atencao: Febre") }
            temperatura >= 36 and pressao == "normal" ==> { print("Tudo normal") }
            _ ==> { print("Verificar paciente") }
      }
}
