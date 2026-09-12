program (ExampleOfBorrow) {
      print("=== Borrow: emprestimo imutavel ===")
      mut as int64: x = 42
      mut as int64: r1 = borrow(x)
      mut as int64: r2 = borrow(x)
      print(r1 + r2)

      print("=== Borrow: valor original preservado ===")
      print(x)
}
