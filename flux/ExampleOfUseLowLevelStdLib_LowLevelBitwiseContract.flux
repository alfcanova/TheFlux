#L Exemplo de Uso: LowLevelBitwiseContract (Logica Bitwise)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelBitwiseContract) {
      println("==================================================")
      println("  Exemplo: LowLevelBitwiseContract                ")
      println("==================================================")

      mut as int64: a = 12   #L 1100 em binario
      mut as int64: b = 10   #L 1010 em binario

      #L 1. AND, OR, XOR
      println("1. Operacoes basicas (a=12, b=10):")
      println("   lowBitAnd(12, 10): " + lowBitAnd(a, b))
      println("   lowBitOr(12, 10): " + lowBitOr(a, b))
      println("   lowBitXor(12, 10): " + lowBitXor(a, b))

      #L 2. NOT (Complemento de um)
      println("2. lowBitNot(12): " + lowBitNot(a))
      println("   lowBitNot(0): " + lowBitNot(0))

      #L 3. NAND, NOR, XNOR
      println("3. Portas logicas universais:")
      println("   lowBitNand(12, 10): " + lowBitNand(a, b))
      println("   lowBitNor(12, 10): " + lowBitNor(a, b))
      println("   lowBitXnor(12, 10): " + lowBitXnor(a, b))
}
