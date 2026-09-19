#L Exemplo de Uso: LowLevelBitInspectionContract (Inspeccao de Bits)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelBitInspectionContract) {
      println("==================================================")
      println("  Exemplo: LowLevelBitInspectionContract          ")
      println("==================================================")

      mut as int64: v = 9 #L 1001 em binario: bit 1 e bit 4 ativos

      #L 1. Verificacao de Bits (1-indexado)
      println("1. lowBitCheck:")
      println("   lowBitCheck(9, 1): " + lowBitCheck(v, 1))
      println("   lowBitCheck(9, 2): " + lowBitCheck(v, 2))
      println("   lowBitCheck(9, 4): " + lowBitCheck(v, 4))

      #L 2. Manipulacao de Bits
      println("2. Set, Clear, Toggle:")
      println("   lowBitSet(9, 2): " + lowBitSet(v, 2))
      println("   lowBitClear(9, 1): " + lowBitClear(v, 1))
      println("   lowBitToggle(9, 1): " + lowBitToggle(v, 1))
      println("   lowBitWrite(9, 2, true): " + lowBitWrite(v, 2, true))

      #L 3. Contagem de Bits (PopCount, Zeros, Paridade)
      println("3. Contagens:")
      println("   lowPopCount(9): " + lowPopCount(v))
      println("   lowPopCount(255): " + lowPopCount(255))
      println("   lowParity(9): " + lowParity(v))
      println("   lowCountLeadingZeros(9, 8): " + lowCountLeadingZeros(v, 8))
      println("   lowCountTrailingZeros(8): " + lowCountTrailingZeros(8))

      #L 4. Extracao e Insercao de Campos de Bits (Bitfield)
      mut as int64: packed = 180 #L 10110100 em binario
      println("4. Campos de bits:")
      println("   lowBitExtract(180, 3, 4): " + lowBitExtract(packed, 3, 4))
      println("   lowBitInsert(0, 13, 3, 4): " + lowBitInsert(0, 13, 3, 4))
      println("   lowReverseBits(9, 4): " + lowReverseBits(v, 4))
}
