use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressXzContract) {
      println("==================================================")
      println("  Exemplo: CompressXzContract (9 Operacoes)")
      println("==================================================")

      mut as string: original = "Hello TheFlux CompressStdLib LZMA2 and XZ Test!"

      #L 1. Compress LZMA2
      mut as string: comp_lz2 = compressLzma2(original)
      println("1. compressLzma2 ok")

      #L 2. Compress LZMA2 Level
      mut as string: comp_lz2_lvl = compressLzma2Level(original, 9)
      println("2. compressLzma2Level 9 ok")

      #L 3. Decompress LZMA2
      mut as string: decomp_lz2 = decompressLzma2(comp_lz2)
      println("3. decompressLzma2 confere: " + (decomp_lz2 == original))

      #L 4. Decompress LZMA2 Safe
      mut as DecompressQuota: q = DecompressQuota(
            .max_bytes: 10000
            .strict_abort: true
      )
      mut as string: decomp_lz2_safe = decompressLzma2Safe(comp_lz2, q)
      println("4. decompressLzma2Safe confere: " + (decomp_lz2_safe == original))

      #L 5. Compress XZ
      mut as string: comp_xz = compressXz(original)
      println("5. compressXz ok")

      #L 6. Compress XZ Level
      mut as string: comp_xz_lvl = compressXzLevel(original, 9)
      println("6. compressXzLevel 9 ok")

      #L 7. Is XZ
      mut as bool: is_xz = compressIsXz(comp_xz)
      println("7. compressIsXz: " + is_xz)

      #L 8. Decompress XZ
      mut as string: decomp_xz = decompressXz(comp_xz)
      println("8. decompressXz confere: " + (decomp_xz == original))

      #L 9. Decompress XZ Safe
      mut as string: decomp_xz_safe = decompressXzSafe(comp_xz, q)
      println("9. decompressXzSafe confere: " + (decomp_xz_safe == original))
}
