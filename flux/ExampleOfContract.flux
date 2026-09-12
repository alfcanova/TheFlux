use AgentOfCalculadora as CA

program (ExampleOfContract) {
      print("=== Contract + Impl: Calculadora ===")
      mut as int64: r1 = CA::somar(10, 5)
      print(r1)
      mut as int64: r2 = CA::subtrair(10, 5)
      print(r2)
      mut as int64: r3 = CA::multiplicar(3, 7)
      print(r3)
}
