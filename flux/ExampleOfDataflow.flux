program (ExampleOfDataflow) {
      print("=== Dataflow: pipeline com --> ===")
      10 --> print
      5 --> (as float64) --> print

      print("=== Dataflow: lambda ==> com binding it ===")
      mut as int64: resultado = 10 ==> it * 2
      print(resultado)

      print("=== Dataflow: split bifurca o fluxo ===")
      mut as list of int64: rotas = 100 split 200 split 300
      rotas --> print
      rotas[2] --> print

      print("=== Dataflow: join consolida fluxos ===")
      mut as list of int64: fluxo = 10 join 20 join 30
      fluxo --> print
      fluxo[1] --> print

      print("=== Dataflow: split e join combinados ===")
      (1 split 2) join (3 split 4) --> print
}