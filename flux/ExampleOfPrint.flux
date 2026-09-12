function (calc) (as int64: teste) as int64 {
      emit(nice, teste, "ok")
}

program (ExampleOfPrint) {
      print("=== Print: como instrucao ===")
      print("Hello, World!")
      print(42)

      print("=== Print: concatenacao ===")
      mut as int64: contador = 7
      print("Contador: " + contador)

      print("=== Print: como sink em dataflow ===")
      calc(10) --> print
      mut as list of int64: xs = [1, 2, 3]
      xs --> print

      print("=== Print: string interpolada ===")
      mut as int64: a = 2
      mut as int64: b = 3
      print("soma: #{ a + b }")

      print("=== Print: campos do resultado de funcao ===")
      imut as int64: r = calc(5)
      print(r.sta)
      print(r.val)
      print(r.msg)
}