#L Exemplo de Uso: LowLevelEndiannessContract (Conversao de Endianness)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelEndiannessContract) {
      println("==================================================")
      println("  Exemplo: LowLevelEndiannessContract             ")
      println("==================================================")

      #L 1. Inversao de Bytes (Byte Swap)
      println("1. Byte Swapping:")
      mut as int64: v16 = 4660 #L 0x1234
      println("   lowByteSwap16(4660): " + lowByteSwap16(v16))

      mut as int64: v32 = 305419896 #L 0x12345678
      println("   lowByteSwap32(305419896): " + lowByteSwap32(v32))

      mut as int64: v64 = 72623859790382856 #L 0x0102030405060708
      println("   lowByteSwap64: " + lowByteSwap64(v64))

      #L 2. Conversoes de Rede (Host to Network / Network to Host)
      println("2. Network Byte Order (Big Endian):")
      println("   lowHostToNetwork16: " + lowHostToNetwork16(v16))
      println("   lowNetworkToHost16: " + lowNetworkToHost16(lowHostToNetwork16(v16)))
      println("   lowHostToNetwork32: " + lowHostToNetwork32(v32))
      println("   lowNetworkToHost32: " + lowNetworkToHost32(lowHostToNetwork32(v32)))
      println("   lowHostToNetwork64: " + lowHostToNetwork64(v64))
      println("   lowNetworkToHost64: " + lowNetworkToHost64(lowHostToNetwork64(v64)))
}
