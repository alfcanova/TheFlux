mut as int64: a = 10
mut as float64: b = 5.5
mut as int64: dados = 7

function (preverTendencia) (as int64: valor) as int64 {
      mut as int64: res = valor + 1
      emit(nice, res, "ok")
}

program (ExampleOfSpy) {
      print("=== 1. Espiando Operando Especifico ===")
      spy(a)
      mut as float64: sum_op = spy(a) + b
      print("Resultado com spy no operando: " + sum_op)

      print("=== 2. Espiando Resultado de Operacao ===")
      mut as float64: sum_expr = spy(a + b)
      print("Resultado da soma espiada: " + sum_expr)

      print("=== 3. Metricas de Topologia e Tempo de Vida em Dataflow ===")
      dados --> preverTendencia --> spy --> print
}
