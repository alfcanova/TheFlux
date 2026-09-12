mut as list of int64: valores = [10, 20, 30, 40, 50]
mut as string(4): texto = "flux"

program (ExampleOfSlices) {
      print("Slice [ .. ]")
      print(valores[ .. ])

      print("Slice [ .. 3 ]")
      print(valores[ .. 3])

      print("Slice [ 2 .. ]")
      print(valores[2 .. ])

      print("Slice [ 2 .. 4 ]")
      print(valores[2 .. 4])

      print("Slice string( .. )")
      print(texto( .. ))

      print("Slice string(2 .. 3)")
      print(texto(2 .. 3))

      print("Slice string( .. 3)")
      print(texto( .. 3))
}
