program (ExampleOfIntType) {
      print("=== IntType: inteiros com sinal ===")
      mut as int8: byte = -8
      mut as int16: small = -1600
      mut as int32: medium = -32000
      mut as int64: large = -64000
      print(byte)
      print(small)
      print(medium)
      print(large)

      print("=== IntType: inteiros sem sinal ===")
      mut as uint8: u_byte = 8
      mut as uint16: u_small = 1600
      mut as uint32: u_medium = 32000
      mut as uint64: u_large = 64000
      print(u_byte)
      print(u_small)
      print(u_medium)
      print(u_large)

      print("=== IntType: aritmetica entre tipos ===")
      mut as int64: total = large + 1000
      print(total)
}