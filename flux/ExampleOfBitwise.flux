program (ExampleOfBitwise) {
      print("=== Bitwise: and, or, xor ===")
      mut as int64: a = 12
      mut as int64: b = 10
      print("a & b: " + (a & b))
      print("a | b: " + (a | b))
      print("a ^ b: " + (a ^ b))

      print("=== Bitwise: not (complemento) ===")
      print("~(-5): " + ~(-5))

      print("=== Bitwise: shifts ===")
      print("a << 2: " + (a << 2))
      print("a >> 2: " + (a >> 2))
      print("(-8) >>> 1: " + ((-8) >>> 1))
}