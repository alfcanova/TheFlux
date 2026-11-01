program (ExampleOfMove) {
      print("=== Move: transfere ownership ===")
      mut as int64: x = 42
      mut as int64: r = move(x)
      print(r)

      print("=== Move: revivificacao ===")
      x = 100
      print(x)

      print("=== Move: move em bloco aninhado ===")
      mut as int64: y = 7
      mut as int64: ry = move(y)
      print(ry)
}
