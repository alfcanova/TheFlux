program (ExampleOfStringInterpolation) {
      print("=== StringInterpolation: simples ===")
      mut as int64: contador = 3
      print("Contador: #{contador}")

      mut as string: nome = "Ana"
      mut as int64: idade = 30
      print("Nome: #{nome}, Idade: #{idade}")

      print("=== StringInterpolation: com expressao ===")
      mut as int64: a = 10
      mut as int64: b = 5
      print("Soma: #{a + b}")

      print("=== StringInterpolation: multipla ===")
      print("x = #{a}, y = #{b}, total = #{a + b}")
}