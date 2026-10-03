use IoStdLib

program (ExampleOfUseIoStdLib_IoBinaryFileContract) {
      println("==================================================")
      println("  Exemplo: IoBinaryFileContract (6 Operacoes)")
      println("==================================================")

      mut as string: raw_bin = "Binary \u{0000}\u{0001}\u{0002} Content"
      mut as string: bin_path = "io_test_bin.dat"

      #L 1. Write / Read Binary File
      writeBinaryFile(bin_path, raw_bin)
      mut as string: read_bin = readBinaryFile(bin_path)
      println("1. readBinaryFile confere: " + (read_bin == raw_bin))

      #L 2. Write / Read Hex File
      mut as string: hex_path = "io_test_hex.dat"
      writeHexFile(hex_path, "48656c6c6f")
      mut as string: read_hex = readHexFile(hex_path)
      println("2. readHexFile confere: " + (read_hex == "48656c6c6f"))

      #L 3. Write / Read Base64 File
      mut as string: b64_path = "io_test_b64.dat"
      writeBase64File(b64_path, "SGVsbG8gVGhlRmx1eCE=")
      mut as string: read_b64 = readBase64File(b64_path)
      println("3. readBase64File confere: " + (read_b64 == "SGVsbG8gVGhlRmx1eCE="))

      #L Limpeza
      deleteFile(bin_path)
      deleteFile(hex_path)
      deleteFile(b64_path)
}
