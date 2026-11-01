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

function (dividir) (as int64: dividendo, as int64: divisor) as int64 {
      mut as int64: resultado = (dividendo /i divisor) ? {
            ==> emit(fail, divisor, "divisao por zero")
            ==> emit(nice, resultado, "divisao executada")
      }
}

program (ExampleOfFail) {
      print("=== Fail: emit(fail) explicito ===")
      mut as int64: r = validar(15)
      print(r.sta)
      print(r.val)
      print(r.msg)

      print("=== Fail: gerado automaticamente (divisao por zero) ===")
      print(dividir(10, 0))

      print("=== Fail: propagado pelo operador ? ===")
      mut as int64: r2 = dividir(10, 2)
      print(r2.sta)
      print(r2.val)
      print(r2.msg)
}