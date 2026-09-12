function (dividir) (as int64: dividendo, as int64: divisor) as int64 {
      mut as int64: resultado = (dividendo /i divisor) ? {
            ==> emit(fail, divisor, "divisao por zero")
            ==> emit(nice, resultado, "divisao executada")
      }
}

function (validar) (as int64: idade) as int64 {
      (idade > 18) ? {
            ==> emit(fail, idade, "menor de idade")
            ==> emit(nice, idade, "maior de idade")
      }
}

function (desconto) (as int64: preco, as int64: percentual) as int64 {
      mut as int64: valor = preco - (preco * percentual /i 100)
      (valor > 0) ? {
            ==> emit(fail, preco, "desconto maior que o preco")
            ==> emit(nice, valor, "desconto aplicado")
      }
}

program (ExampleOfShortCircuit) {
      print("=== ShortCircuit: despacho para o braco fail ===")
      print(dividir(10, 0))

      print("=== ShortCircuit: despacho para o braco nice ===")
      print(dividir(10, 2))

      print("=== ShortCircuit: campos do resultado ===")
      mut as int64: r = validar(15)
      print(r.sta)
      print(r.val)
      print(r.msg)

      print("=== ShortCircuit: outro fail ===")
      print(desconto(200, 150))
}