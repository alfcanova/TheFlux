#L Exemplo de Uso: LowLevelMemoryAccessContract (Acesso e Manipulacao de Memoria / MMIO)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelMemoryAccessContract) {
      println("==================================================")
      println("  Exemplo: LowLevelMemoryAccessContract           ")
      println("==================================================")

      mut as map: mem = lowMemoryInit(1024)

      #L 1. Leitura e Escrita de Inteiros em Memoria Virtual (Little-Endian)
      mem = lowMemoryPokeByte(mem, 100, 250)
      println("1. Byte em 100: " + lowMemoryPeekByte(mem, 100))

      mem = lowMemoryPokeHWord(mem, 104, 4660) #L 0x1234
      println("2. HWord em 104: " + lowMemoryPeekHWord(mem, 104))

      mem = lowMemoryPokeWord(mem, 108, 305419896) #L 0x12345678
      println("3. Word em 108: " + lowMemoryPeekWord(mem, 108))

      #L 4. Extracao e Montagem de Componentes
      mut as int64: packed = 305419896 #L 0x12345678
      println("4. Byte 1 (LSB): " + lowByteGet(packed, 1))
      println("   Byte 4 (MSB): " + lowByteGet(packed, 4))
      println("   HWord 1: " + lowHWordGet(packed, 1))
      println("   HWord 2: " + lowHWordGet(packed, 2))
      println("   Word 1: " + lowWordGet(packed, 1))

      #L 5. Montagem de Primitivos a partir de Partes
      mut as int64: hw = lowMakeHWord(18, 52)
      println("5. lowMakeHWord: " + hw)

      mut as int64: w = lowMakeWord(1, 2, 3, 4)
      println("   lowMakeWord: " + w)

      mut as int64: dw = lowMakeDWord(100, 200)
      println("   lowMakeDWord: " + dw)
}
