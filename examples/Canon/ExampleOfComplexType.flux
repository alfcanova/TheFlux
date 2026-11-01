program (ExampleOfComplex) {
      print("=== Complex: partes real e imaginaria ===")
      mut as complex32: c32 = -1.5 + -2.5i
      mut as complex64: c64 = 64.125 + -8.5i
      mut as complex128: c128 = 1.5 + 2.5i
      print(c32)
      print(c64)
      print(c128)

      print("=== Complex: parte imaginaria pura ===")
      mut as complex64: imag = 2i
      mut as complex64: negativo = -3.5i
      print(imag)
      print(negativo)
}