program (ExampleOfBool) {
      print("=== Bool: forma canonica true/false ===")
      mut as bool: ativo = true
      mut as bool: completo = false
      print(ativo)
      print(completo)

      print("=== Bool: condicao direta de route ===")
      route {
            true ==> { print("Sempre executa") }
            false ==> { print("Nunca executa") }
      }

      print("=== Bool: operacoes logicas ===")
      print(not ativo)
      print(ativo and completo)
      print(ativo or completo)
}