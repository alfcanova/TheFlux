program (ExampleOfOf) {
      print("=== Of: list of tipo ===")
      mut as list of int64: xs = [10, 20, 30]
      print(xs)

      print("=== Of: set of tipo ===")
      mut as set of string: sensores = {"temp", "pressao"}
      print(sensores)

      print("=== Of: tensor of tipo ===")
      mut as tensor[2, 2] of int32: t = [[1, 2], [3, 4]]
      print(t)

      print("=== Of: map com chave e valor tipados ===")
      mut as map: codigos = map{.1 of uint8: "Norte" of string, .2 of uint8: "Sul" of string}
      print(codigos["1"])
      print(codigos["2"])
}