function (calc) (as int64: x) as int64 {
      emit(nice, x, "ok")
}

function (validar) (as int64: idade) as int64 {
      (idade > 18) ? {
            ==> emit(fail, idade, "menor de idade")
            ==> emit(nice, idade, "maior de idade")
      }
}

program (ExampleOfNice) {
      print("=== Nice: emit(nice) e campos do resultado ===")
      imut as int64: r = calc(5)
      print(r.sta)
      print(r.val)
      print(r.msg)

      print("=== Nice: braco nice do operador ? ===")
      imut as int64: r2 = validar(21)
      print(r2.sta)
      print(r2.val)
      print(r2.msg)
}