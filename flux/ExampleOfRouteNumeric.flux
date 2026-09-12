program (ExampleOfRouteNumeric) {
      mut as int64: idade = 25

      route (idade) {
            idade < 0 ==> {
                  print("Erro: idade negativa invalida")
            }
            idade < 12 ==> {
                  print("Crianca")
            }
            idade < 18 ==> {
                  print("Adolescente")
            }
            idade < 60 ==> {
                  print("Adulto")
            }
            idade < 120 ==> {
                  print("Idoso")
            }
            _ ==> {
                  print("Erro: idade fora do intervalo valido")
            }
      }
}
