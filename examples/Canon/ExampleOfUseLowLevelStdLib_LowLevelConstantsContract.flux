#L Exemplo de Uso: LowLevelConstantsContract (Constantes de Baixo Nivel)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelConstantsContract) {
      println("==================================================")
      println("  Exemplo: LowLevelConstantsContract              ")
      println("==================================================")

      #L 1. Mascaras de Bits
      println("1. Mascaras:")
      println("   mask8: " + mask8())
      println("   mask16: " + mask16())
      println("   mask32: " + mask32())
      println("   mask64: " + mask64())

      #L 2. Limites de Inteiros com Sinal
      println("2. Limites com sinal:")
      println("   int8: [" + int8Min() + ", " + int8Max() + "]")
      println("   int16: [" + int16Min() + ", " + int16Max() + "]")
      println("   int32: [" + int32Min() + ", " + int32Max() + "]")
      println("   int64: [" + int64Min() + ", " + int64Max() + "]")

      #L 3. Limites de Inteiros Sem Sinal (Max)
      println("3. Limites sem sinal:")
      println("   uint8Max: " + uint8Max())
      println("   uint16Max: " + uint16Max())
      println("   uint32Max: " + uint32Max())

      #L 4. Tamanhos em Bytes e Bits
      println("4. Tamanhos:")
      println("   Byte: " + sizeByte() + " bytes (" + bitsByte() + " bits)")
      println("   HWord: " + sizeHWord() + " bytes (" + bitsHWord() + " bits)")
      println("   Word: " + sizeWord() + " bytes (" + bitsWord() + " bits)")
      println("   DWord: " + sizeDWord() + " bytes (" + bitsDWord() + " bits)")

      #L 5. Arquitetura e Endianness
      println("5. Arquitetura:")
      println("   pageSize4K: " + pageSize4K())
      println("   pageSizeHuge2M: " + pageSizeHuge2M())
      println("   cacheLineSize: " + cacheLineSize())
      println("   endianLittle: " + endianLittle())
      println("   endianBig: " + endianBig())
}
