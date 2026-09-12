use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugFilterContract) {
      println("==================================================")
      println("  Exemplo: DebugFilterContract (Niveis e Filtros)")
      println("==================================================")

      #L Niveis: 1=ERROR, 2=WARN, 3=INFO, 4=DEBUG
      mut as int64: nivel_ativo = 3

      println("1. Nome nivel 1: " + debugLevelName(1))
      println("   Nome nivel 2: " + debugLevelName(2))
      println("   Nome nivel 3: " + debugLevelName(3))
      println("   Nome nivel 4: " + debugLevelName(4))

      #L 2. Verificacao se deve logar com nivel_ativo = 3 (INFO)
      println("2. Deve logar ERROR (1) com INFO (3)? " + debugLevelShouldLog(nivel_ativo, 1))
      println("   Deve logar WARN  (2) com INFO (3)? " + debugLevelShouldLog(nivel_ativo, 2))
      println("   Deve logar INFO  (3) com INFO (3)? " + debugLevelShouldLog(nivel_ativo, 3))
      println("   Deve logar DEBUG (4) com INFO (3)? " + debugLevelShouldLog(nivel_ativo, 4))

      #L 3. Filtros de Tags
      println("3. Tag 'AUTH' bate com wildcard '*'?     " + debugTagMatches("*", "AUTH"))
      println("   Tag 'AUTH' bate com filtro 'AUTH'?    " + debugTagMatches("AUTH", "AUTH"))
      println("   Tag 'DB' bate com filtro 'AUTH'?      " + debugTagMatches("AUTH", "DB"))
}
