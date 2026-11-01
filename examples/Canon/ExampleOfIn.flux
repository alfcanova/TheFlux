program (ExampleOfIn) {
      print("=== In: iteracao sobre range ===")
      infinite (i in 1 .. 5) {
            print("Numero: " + i)
      }

      print("=== In: iteracao sobre lista ===")
      infinite (fruta in ["uva", "banana", "cereja"]) {
            print("Fruta: " + fruta)
      }

      print("=== In: iteracao sobre set ===")
      infinite (item in {"a", "b", "c"}) {
            print("Item: " + item)
      }
}