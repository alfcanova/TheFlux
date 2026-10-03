use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressLzmaContract) {
      println("==================================================")
      println("  Exemplo: CompressLzmaContract (5 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib LZMA Alone Test!"

      #L 1. Compress LZMA
      mut as string: compressed = compressLzma(original)
      println("1. compressLzma ok")

      #L 2. Compress LZMA Level
      mut as string: comp_lvl = compressLzmaLevel(original, 9)
      println("2. compressLzmaLevel 9 ok")

      #L 3. Is LZMA
      mut as bool: is_lz = compressIsLzma(compressed)
      println("3. compressIsLzma: " + is_lz)

      #L 4. Decompress LZMA
      mut as string: decomp = decompressLzma(compressed)
      println("4. decompressLzma confere: " + (decomp == original))

      #L 5. Decompress Safe com Quota
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_safe = decompressLzmaSafe(compressed, q)
      println("5. decompressLzmaSafe confere: " + (decomp_safe == original))
}
