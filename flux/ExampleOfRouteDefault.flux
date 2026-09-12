program (ExampleOfRouteDefault) {
      #L Exemplo de rota com multiplos padroes e catch-all
      mut as string: comando = "status"

      route (comando) {
            "start" ==> {
                  print("Iniciando servico...")
            }
            "stop" ==> {
                  print("Parando servico...")
            }
            "restart" ==> {
                  print("Reiniciando servico...")
            }
            "status" ==> {
                  print("Servico em execucao")
            }
            _ ==> {
                  print("Comando desconhecido: #{comando}")
                  print("Comandos validos: start, stop, restart, status")
            }
      }

      #L Rota com apenas catch-all (fallback universal)
      route {
            _ ==> {
                  print("Este e um fallback universal - sempre executa")
            }
      }

      #L Rota com atribuicao nos bracos (route nao pode ser expressao)
      mut as string: resultado = "desconhecido"
      mut as int64: nivel = 3
      route (nivel) {
            1 ==> { resultado = "baixo" }
            2 ==> { resultado = "medio" }
            3 ==> { resultado = "alto" }
      }
      print("Nivel: #{resultado}")

      #L Rota aninhada com validacao de fallback
      mut as float64: temperatura = 38.5
      route (temperatura) {
            temperatura > 40.0 ==> {
                  print("PERIGO: Hipertermia!")
            }
            temperatura > 37.5 ==> {
                  print("Atencao: Febre moderada")
                  route (temperatura) {
                        temperatura > 39.0 ==> {
                              print("Recomendado: buscar atendimento medico")
                        }
                        _ ==> {
                              print("Recomendado: repouso e hidratacao")
                        }
                  }
            }
            temperatura >= 36.0 ==> {
                  print("Temperatura normal")
            }
            _ ==> {
                  print("Atencao: Hipotermia!")
            }
      }
}
