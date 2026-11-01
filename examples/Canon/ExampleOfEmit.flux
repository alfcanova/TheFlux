function (dividir) (as int64: dividendo, as int64: divisor) as int64 {
      route {
            divisor == 0 ==> {
                  print("divisao proibida")
                  emit(fail, divisor, "divisao por zero")
            }
            _ ==> {
                  mut as int64: resultado = dividendo /i divisor
                  print("divisao realizada")
                  emit(nice, resultado, "divisao executada")
            }
      }
}

function (validar) (as int64: idade) as int64 {
      route {
            idade < 18 ==> {
                  emit(fail, idade, "menor de idade")
            }
            _ ==> {
                  emit(nice, idade, "validacao concluida")
            }
      }
}

function (desconto) (as int64: preco, as int64: percentual) as int64 {
      route {
            percentual > 100 ==> {
                  emit(fail, percentual, "percentual invalido")
            }
            _ ==> {
                  mut as int64: valor = preco - (preco * percentual /i 100)
                  emit(nice, valor, "desconto aplicado")
            }
      }
}

program (ExampleOfEmit) {
      print("=== Emit: emit(nice) com retorno ===")
      print(dividir(10, 2))

      print("=== Emit: emit(fail) em caminho de erro ===")
      print(dividir(10, 0))

      print("=== Emit: campos do struct de resultado ===")
      mut as int64: r = validar(15)
      print(r.sta)
      print(r.val)
      print(r.msg)

      print("=== Emit: outro caminho de erro ===")
      print(desconto(200, 150))
}