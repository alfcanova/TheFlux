use FileSignatureStdLib

program (ExampleOfUseFileSignatureStdLib_FileFormatSignatureContract) {
      println("==================================================")
      println("  Exemplo: FileFormatSignatureContract (3 Operacoes)")
      println("==================================================")

      mut as string: path = "io_stdlib_fixture.txt"

      #L 1. Magic Bytes e Formato
      println("1. fileMagicBytes (4 bytes): " + fileMagicBytes(path, 4))
      println("2. fileDetectType: " + fileDetectType(path))
      println("3. fileIsBinary: " + fileIsBinary(path))
}
