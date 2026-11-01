use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressBzip2Contract) {
      println("==================================================")
      println("  Exemplo: CompressBzip2Contract (5 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib Bzip2 Test!"

      #L 1. Compress Bzip2
      mut as string: compressed = compressBzip2(original)
      println("1. compressBzip2 ok")

      #L 2. Compress Bzip2 Level
      mut as string: comp_lvl = compressBzip2Level(original, 9)
      println("2. compressBzip2Level 9 ok")

      #L 3. Is Bzip2
      mut as bool: is_bz = compressIsBzip2(compressed)
      println("3. compressIsBzip2: " + is_bz)

      #L 4. Decompress Bzip2
      mut as string: decomp = decompressBzip2(compressed)
      println("4. decompressBzip2 confere: " + (decomp == original))

      #L 5. Decompress Safe com Quota
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_safe = decompressBzip2Safe(compressed, q)
      println("5. decompressBzip2Safe confere: " + (decomp_safe == original))
}
