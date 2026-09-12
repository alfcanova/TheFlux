program (ExampleOfMut) {
      print("=== Mut: com tipo e valor inicial ===")
      mut as int64: contador = 0
      mut as string: nome = "TheFlux"
      print(contador)
      print(nome)

      print("=== Mut: valor padrao do tipo ===")
      mut as int64: sem_valor
      mut as string: sem_texto
      print(sem_valor)
      print("[" + sem_texto + "]")

      print("=== Mut: reatribuicao ===")
      contador = 5
      print(contador)

      print("=== Mut: declaracao multipla em linha ===")
      mut as int64: a, b = 42
      print(a)
      print(b)
}