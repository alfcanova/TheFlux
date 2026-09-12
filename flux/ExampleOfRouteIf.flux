program (ExampleOfRouteIf) {
      print("=== If then ativado (cond falsa) ===")
      mut as int64: x1 = 2
      route { x1 > 5 ==> {
            print("x e maior que 5")
      } }
      print("Fim do teste if then OK")

      print("=== If else ativado ===")
      mut as int64: x2 = 2
      route { x2 > 5 ==> {
            print("x e maior que 5")
            print("Resultado inesperado")
      } _ ==> {
            print("x e menor ou igual a 5")
            print("Resultado esperado")
      } }
      print("Fim do teste if/else OK")

      print("=== If/elsif/else ===")
      mut as int64: x3 = 3
      route { x3 == 1 ==> {
            print("x e um")
      } x3 == 2 ==> {
            print("x e dois")
      } x3 == 3 ==> {
            print("x e tres")
            print("Resultado esperado")
      } _ ==> {
            print("x e outro valor")
      } }
      print("Fim do teste if/then/elsif/else OK")

      print("=== If aninhados ===")
      mut as int64: x4 = 15
      route { x4 > 0 ==> {
            print("#{x4} e positivo")
            route { x4 > 10 ==> {
                  print("#{x4} e maior que 10")
                  route { x4 > 20 ==> {
                        print("#{x4} e maior que 20")
                  } _ ==> {
                        print("#{x4} nao e maior que 20")
                  } }
            } _ ==> {
                  print("#{x4} e menor ou igual a 10")
            } }
      } _ ==> {
            print("#{x4} e negativo ou zero")
      } }
      print("Fim do teste if aninhados OK")

      print("=== If then sem else (cond falsa) ===")
      mut as int64: x5 = 2
      route { x5 > 5 ==> {
            print("x e maior que 5")
      } }
      print("Fim do teste if/else OK")
}
