function (epar) (as int64: dividendo, divisor) as int64 {
      mut as int64: c = dividendo /r divisor
      mut as int64: zero = 0
      route {
            c == 0 ==> {
                  emit(nice, zero, "par")
            }
            _ ==> {
                  emit(fail, c, "impar")
            }
      }
}

program (ExampleOfFunctionReturn) {

      mut as int64: par = epar(4, 2)
      mut as int64: impar = epar(5, 2)

      print("Resto do numero par: " + par)
      print("Resto do numero impar: " + impar)
}
