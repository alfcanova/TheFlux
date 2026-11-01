#L Exemplo de Uso: LowLevelBufferContract (Buffers Dinamicos e Serializacao Hexadecimal)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelBufferContract) {
      println("==================================================")
      println("  Exemplo: LowLevelBufferContract                 ")
      println("==================================================")

      #L 1. Criacao e Escrita em Buffer Dinamico
      mut as map: buf = lowBufferNew(32)
      println("1. Buffer inicial - len: " + lowBufferLength(buf) + ", cap: " + lowBufferCapacity(buf))

      buf = lowBufferWriteByte(buf, 255) #L 0xFF
      buf = lowBufferWriteHWord(buf, 4660) #L 0x1234 -> 34 12
      buf = lowBufferWriteWord(buf, 305419896) #L 0x12345678 -> 78 56 34 12

      println("2. Tamanho apos escritas: " + lowBufferLength(buf))
      println("3. lowBufferToHex: " + lowBufferToHex(buf))

      #L 4. Leitura a partir do Buffer
      println("4. Leitura de dados:")
      println("   Offset 0 (Byte): " + lowBufferReadByte(buf, 0))
      println("   Offset 1 (HWord): " + lowBufferReadHWord(buf, 1))
      println("   Offset 3 (Word): " + lowBufferReadWord(buf, 3))

      #L 5. Criacao de Buffer a partir de Hexadecimal
      mut as map: hex_buf = lowBufferFromHex("DEADBEEF")
      println("5. Buffer a partir de 'DEADBEEF':")
      println("   Tamanho: " + lowBufferLength(hex_buf))
      println("   lowBufferToHex: " + lowBufferToHex(hex_buf))
      println("   Byte 0: " + lowBufferReadByte(hex_buf, 0))
      println("   Byte 1: " + lowBufferReadByte(hex_buf, 1))
}
