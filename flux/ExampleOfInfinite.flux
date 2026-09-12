program (ExampleOfInfinite) {
      print("=== Infinite: loop com break ===")
      infinite {
            print("executou")
            break
      }

      print("=== Infinite: loop com condicao ===")
      mut as bool: flag = true
      infinite (flag) {
            print("rodando")
            flag = false
      }

      print("=== Infinite: break apos acao ===")
      infinite {
            print("Uma vez")
            break
      }
      print("Depois do loop")
}