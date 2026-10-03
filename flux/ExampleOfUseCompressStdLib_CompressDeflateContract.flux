use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressDeflateContract) {
      println("==================================================")
      println("  Exemplo: CompressDeflateContract (5 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib Deflate Test!"

      #L 1. Compress Deflate
      mut as string: compressed = compressDeflate(original)
      println("1. compressDeflate ok")

      #L 2. Compress Deflate Level
      mut as string: comp_lvl = compressDeflateLevel(original, 9)
      println("2. compressDeflateLevel 9 ok")

      #L 3. Is Deflate
      mut as bool: is_def = compressIsDeflate(compressed)
      println("3. compressIsDeflate: " + is_def)

      #L 4. Decompress Deflate
      mut as string: decomp = decompressDeflate(compressed)
      println("4. decompressDeflate confere: " + (decomp == original))

      #L 5. Decompress Safe com Quota
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_safe = decompressDeflateSafe(compressed, q)
      println("5. decompressDeflateSafe confere: " + (decomp_safe == original))
}
