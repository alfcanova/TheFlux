program (ExampleOfUnsafe) {
      print("=== Unsafe: executa corpo normalmente ===")
      unsafe {
            mut as int64: x = 42
            print(x)
      }

      print("=== Unsafe: bypass de ownership ===")
      mut as int64: a = 10
      unsafe {
            print(a)
            a = 20
            print(a)
      }
}
