use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugAssertContract) {
      println("==================================================")
      println("  Exemplo: DebugAssertContract (Assercoes)")
      println("==================================================")

      #L 1. Assercoes Booleanas
      println("1. Assercao condicao verdadeira: " + debugAssert(10 > 5, "10 deve ser maior que 5"))
      println("   Assercao condicao falsa: " + debugAssert(2 > 5, "2 nao eh maior que 5"))

      #L 2. Assercoes de Igualdade Inteira
      println("2. Assercao Int igual: " + debugAssertEqualInt(100, 100, "TesteSoma"))
      println("   Assercao Int divergente: " + debugAssertEqualInt(50, 100, "TesteTotal"))

      #L 3. Assercoes de Igualdade de Strings
      println("3. Assercao String igual: " + debugAssertEqualString("Flux", "Flux", "ValidaNome"))
      println("   Assercao String divergente: " + debugAssertEqualString("Flux", "Rust", "ValidaLinguagem"))

      #L 4. Assercoes de Igualdade Booleana
      println("4. Assercao Bool igual: " + debugAssertEqualBool(true, true, "ValidaAtivo"))
      println("   Assercao Bool divergente: " + debugAssertEqualBool(true, false, "ValidaStatus"))

      #L 5. Assercoes de Faixa / Intervalo
      println("5. Assercao Em Faixa [10..50]: " + debugAssertInRange(25, 10, 50, "ValidaIdade"))
      println("   Assercao Fora da Faixa [10..50]: " + debugAssertInRange(75, 10, 50, "ValidaLimite"))
}
