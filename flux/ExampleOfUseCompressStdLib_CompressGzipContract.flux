use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressGzipContract) {
      println("==================================================")
      println("  Exemplo: CompressGzipContract (7 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib Gzip RFC 1952 Test!"

      #L 1. Compress Gzip
      mut as string: compressed = compressGzip(original)
      println("1. compressGzip ok")

      #L 2. Compress Gzip Level
      mut as string: comp_lvl = compressGzipLevel(original, 9)
      println("2. compressGzipLevel 9 ok")

      #L 3. Is Gzip
      mut as bool: is_gz = compressIsGzip(compressed)
      println("3. compressIsGzip: " + is_gz)

      #L 4. CRC-32
      mut as int64: crc = compressGzipCrc32(compressed)
      println("4. compressGzipCrc32: " + (crc > 0))

      #L 5. Timestamp
      mut as int64: ts = compressGzipTimestamp(compressed)
      println("5. compressGzipTimestamp: " + (ts >= 0))

      #L 6. Decompress Gzip
      mut as string: decomp = decompressGzip(compressed)
      println("6. decompressGzip confere: " + (decomp == original))

      #L 7. Decompress Safe com Quota
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_safe = decompressGzipSafe(compressed, q)
      println("7. decompressGzipSafe confere: " + (decomp_safe == original))
}
