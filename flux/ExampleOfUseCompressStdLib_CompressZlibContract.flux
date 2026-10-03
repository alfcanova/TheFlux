use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressZlibContract) {
      println("==================================================")
      println("  Exemplo: CompressZlibContract (6 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib Zlib RFC 1950 Test!"

      #L 1. Compress Zlib
      mut as string: compressed = compressZlib(original)
      println("1. compressZlib ok")

      #L 2. Compress Zlib Level
      mut as string: comp_lvl = compressZlibLevel(original, 9)
      println("2. compressZlibLevel 9 ok")

      #L 3. Is Zlib
      mut as bool: is_zl = compressIsZlib(compressed)
      println("3. compressIsZlib: " + is_zl)

      #L 4. Adler-32
      mut as int64: adler = compressZlibAdler32(compressed)
      println("4. compressZlibAdler32: " + (adler > 0))

      #L 5. Decompress Zlib
      mut as string: decomp = decompressZlib(compressed)
      println("5. decompressZlib confere: " + (decomp == original))

      #L 6. Decompress Safe com Quota
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_safe = decompressZlibSafe(compressed, q)
      println("6. decompressZlibSafe confere: " + (decomp_safe == original))
}
