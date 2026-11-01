program (ExampleOfKeep) {
      print("=== Keep: preserva variavel apos ultimo uso ===")
      mut as int64: x = 10
      mut as int64: r = x + 5
      print(r)
      keep(x)
      print(x)

      print("=== Keep: idempotente ===")
      keep(x)
      keep(x)
      print(x)
}
