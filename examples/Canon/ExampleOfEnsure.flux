function (calcular) (as int64: x) as int64 {
      mut as int64: r = (x + 2) ensure {
            print("cleanup executado")
      }
      emit(nice, r, "ok")
}

function (calcularNegativo) (as int64: x) as int64 {
      mut as int64: r = (x - 2) ensure {
            print("Ensure sempre executado")
      }
      emit(nice, r, "ok")
}

program (ExampleOfEnsure) {
      print("=== Ensure: preserva o valor do alvo ===")
      print(calcular(10))

      print("=== Ensure: bloco sempre executa ===")
      print(calcularNegativo(5))
}