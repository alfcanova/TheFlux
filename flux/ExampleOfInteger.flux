program (ExampleOfInteger) {
      print("=== Integer: literais basicos ===")
      mut as int8: valor = -8
      mut as int16: contador = -1600
      mut as int32: indice = 32000
      mut as int64: total = 64000
      print(valor)
      print(contador)
      print(indice)
      print(total)

      print("=== Integer: inteiros sem sinal ===")
      mut as uint8: byte = 255
      mut as uint64: endereco = 999999999
      print(byte)
      print(endereco)

      print("=== Integer: inferencia de tipo (int64) ===")
      mut as int64: x = 42
      mut as int64: zero = 0
      print(x)
      print(zero)
}