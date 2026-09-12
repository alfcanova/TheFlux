program (ExampleOfRangeSlice) {
      print("=== RangeSlice: range inclusivo ===")
      infinite (i in 1 .. 5) {
            print(i)
      }

      print("=== RangeSlice: range descendente ===")
      infinite (i in 3 .. 1) {
            print(i)
      }

      print("=== RangeSlice: slices de lista ===")
      mut as list of int64: valores = [10, 20, 30, 40, 50]
      print(valores[..])
      print(valores[..3])
      print(valores[2..])
      print(valores[2..4])
}