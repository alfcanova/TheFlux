function (calc) (as int64: x) as int64 {
      mut as int64: resultado = x * 2
      emit(nice, resultado, "dobro ok")
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

program (ExampleOfFunction) {
      print("=== Function: retorno e campos do resultado ===")
      imut as int64: r = calc(5)
      print(r.sta)
      print(r.val)
      print(r.msg)

      print("=== Function: valor direto ===")
      print(calc(3))

      print("=== Function: caminho de erro ===")
      imut as int64: r2 = validar(15)
      print(r2.sta)
      print(r2.val)
      print(r2.msg)
}