use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressZstdContract) {
      println("==================================================")
      println("  Exemplo: CompressZstdContract (6 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib Zstandard RFC 8878 Test!"

      #L 1. Compress Zstd
      mut as string: compressed = compressZstd(original)
      println("1. compressZstd ok")

      #L 2. Compress Zstd Level
      mut as string: comp_lvl = compressZstdLevel(original, 5)
      println("2. compressZstdLevel 5 ok")

      #L 3. Is Zstd
      mut as bool: is_zs = compressIsZstd(compressed)
      println("3. compressIsZstd: " + is_zs)

      #L 4. Zstd Frame Size
      mut as int64: fsz = compressZstdFrameSize(compressed)
      println("4. compressZstdFrameSize: " + (fsz > 0))

      #L 5. Decompress Zstd
      mut as string: decomp = decompressZstd(compressed)
      println("5. decompressZstd confere: " + (decomp == original))

      #L 6. Decompress Safe com Quota
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_safe = decompressZstdSafe(compressed, q)
      println("6. decompressZstdSafe confere: " + (decomp_safe == original))
}
