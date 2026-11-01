function (fibonacci) (as int64: n) as int64 {
      route {
            n <= 1 ==> {
                  emit(nice, n, "base")
            }
            _ ==> {
                  mut as int64: a = fibonacci(n - 1)
                  mut as int64: b = fibonacci(n - 2)
                  mut as int64: result = a + b
                  emit(nice, result, "recursivo")
            }
      }
}

program (ExampleOfFibonacci) {
      infinite (posicao in 1 .. 10) {
            print("Fibonacci posicao: " + posicao + " = " + fibonacci(posicao))
      }
}