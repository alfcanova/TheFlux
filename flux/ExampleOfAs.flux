use AgentOfPrint::printNome as meuPrint

program (ExampleOfAs) {
      print("=== As: cast de string para int64 ===")
      mut as string: STR_IDADE = "25"
      mut as int64: idade = 0
      route {
            STR_IDADE == "" ==> { idade = 0 }
            _ ==> { idade = STR_IDADE as int64 }
      }
      print("Idade: " + idade)

      print("=== As: cast de string para float64 ===")
      mut as string: STR_VEL = "12.5"
      print(STR_VEL as float64)

      print("=== As: cast em pipeline de dataflow ===")
      "42" --> (as int64) --> print

      print("=== As: alias de operacao importada ===")
      meuPrint()
}