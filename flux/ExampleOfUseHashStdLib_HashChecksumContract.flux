use HashStdLib

program (ExampleOfUseHashStdLib_HashChecksumContract) {
      println("==================================================")
      println("  Exemplo: HashChecksumContract (Checksums e Luhn)")
      println("==================================================")

      mut as string: texto = "The Flux Programming Language"
      mut as string: vazio = ""

      #L 1. CRC16, CRC32 e CRC64
      println("1. CRC16(texto): " + hashCrc16(texto))
      println("   CRC16(vazio): " + hashCrc16(vazio))
      println("   CRC32(texto): " + hashCrc32(texto))
      println("   CRC32(vazio): " + hashCrc32(vazio))
      println("   CRC64(texto): " + hashCrc64(texto))

      #L 2. Adler32 e Fletcher16
      println("2. Adler32(texto): " + hashAdler32(texto))
      println("   Adler32(vazio): " + hashAdler32(vazio))
      println("   Fletcher16(texto): " + hashFletcher16(texto))

      #L 3. BSD Sum e System V Checksums
      println("3. BSD Sum: " + hashBsdChecksum(texto))
      println("   System V: " + hashSysVChecksum(texto))

      #L 4. Algoritmo de Luhn (Validacao de Payload e Cartoes)
      println("4. Luhn('79927398713') [valido]: " + hashLuhn("79927398713"))
      println("   Luhn('79927398714') [invalido]: " + hashLuhn("79927398714"))
}
