#L Exemplo de Uso: LowLevelAlignmentContract (Alinhamento e Aritmetica de Enderecos)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelAlignmentContract) {
      println("==================================================")
      println("  Exemplo: LowLevelAlignmentContract              ")
      println("==================================================")

      mut as int64: addr = 4099 #L 4096 + 3

      #L 1. Checagem de Alinhamento
      println("1. Checagem de Alinhamento:")
      println("   lowIsAligned(4096, 4096): " + lowIsAligned(4096, 4096))
      println("   lowIsAligned(4099, 4): " + lowIsAligned(addr, 4))
      println("   lowIsAligned(4100, 4): " + lowIsAligned(4100, 4))

      #L 2. Arredondamento para Cima e para Baixo
      println("2. Arredondamento de Enderecos:")
      println("   lowAlignForward(4099, 8): " + lowAlignForward(addr, 8))
      println("   lowAlignBackward(4099, 8): " + lowAlignBackward(addr, 8))
      println("   lowAlignmentPadding(4099, 8): " + lowAlignmentPadding(addr, 8))

      #L 3. Aritmetica de Ponteiros / Enderecos
      println("3. Aritmetica de Enderecos:")
      mut as int64: base_addr = 65536
      mut as int64: new_addr = lowAddressOffset(base_addr, 128)
      println("   lowAddressOffset(65536, 128): " + new_addr)
      println("   lowAddressDifference(new_addr, base_addr): " + lowAddressDifference(new_addr, base_addr))
}
