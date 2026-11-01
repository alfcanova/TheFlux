use CompressStdLib

program (ExampleOfUseCompressStdLib_CompressInspectionContract) {
      println("==================================================")
      println("  Exemplo: CompressInspectionContract (6 Operacoes)")
      println("==================================================")

      mut as string: original = "Payload de teste para inspecao automatica do TheFlux! " + "Payload de teste para inspecao automatica do TheFlux! "
      mut as string: comp_gz = compressGzip(original)

      #L 1. Estimate Decompressed Size
      mut as int64: est_sz = compressEstimateDecompressedSize(comp_gz)
      println("1. compressEstimateDecompressedSize: " + (est_sz > 0))

      #L 2. Detect Format
      mut as string: fmt = compressDetectFormat(comp_gz)
      println("2. compressDetectFormat: " + fmt)

      #L 3. Compress Stats (Struct nominal)
      mut as CompressStats: st = compressStats(original, comp_gz)
      println("3. compressStats original_size: " + (st.uncompressed_size > 0))
      println("   compressed_size: " + (st.compressed_size > 0))
      println("   savings_percent: " + (st.savings_percent > 0.0))

      #L 4. Decompress Auto
      mut as string: decomp = decompressAuto(comp_gz)
      println("4. decompressAuto confere: " + (decomp == original))

      #L 5. Is Effective
      mut as bool: is_eff = compressIsEffective(original, comp_gz)
      println("5. compressIsEffective: " + is_eff)

      #L 6. Is Format Supported
      println("6. isFormatSupported GZIP: " + compressIsFormatSupported("GZIP"))
      println("   isFormatSupported ZSTD: " + compressIsFormatSupported("ZSTD"))
      println("   isFormatSupported XZ: " + compressIsFormatSupported("XZ"))
}
