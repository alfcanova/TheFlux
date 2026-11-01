#L Exemplo de Uso: LowLevelShiftRotateContract (Deslocamento e Rotacao)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelShiftRotateContract) {
      println("==================================================")
      println("  Exemplo: LowLevelShiftRotateContract            ")
      println("==================================================")

      mut as int64: val = 16   #L 0x10
      mut as int64: neg = -8

      #L 1. Deslocamento para Esquerda (Shift Left)
      println("1. lowShiftLeft(16, 2): " + lowShiftLeft(val, 2))

      #L 2. Deslocamento Aritmetico para Direita (Shift Right)
      println("2. Deslocamento aritmetico:")
      println("   lowShiftRight(16, 2): " + lowShiftRight(val, 2))
      println("   lowShiftRight(-8, 1): " + lowShiftRight(neg, 1))

      #L 3. Deslocamento Logico para Direita (Unsigned Shift Right)
      println("3. Deslocamento logico:")
      println("   lowShiftRightLogical(16, 2): " + lowShiftRightLogical(val, 2))
      println("   lowShiftRightLogical(-8, 1): " + lowShiftRightLogical(neg, 1))

      #L 4. Rotacoes de 32 bits
      mut as int64: v32 = 2863311530 #L 0xAAAAAAAA
      println("4. Rotacoes de 32 bits (v=0xAAAAAAAA):")
      println("   lowRotateLeft32(0xAAAAAAAA, 1): " + lowRotateLeft32(v32, 1))
      println("   lowRotateRight32(0xAAAAAAAA, 1): " + lowRotateRight32(v32, 1))

      #L 5. Rotacoes com largura parametrizada (8 bits)
      mut as int64: v8 = 129 #L 10000001 em binario
      println("5. Rotacao em 8 bits (v=129):")
      println("   lowRotateLeft(129, 1, 8): " + lowRotateLeft(v8, 1, 8))
      println("   lowRotateRight(129, 1, 8): " + lowRotateRight(v8, 1, 8))
}
