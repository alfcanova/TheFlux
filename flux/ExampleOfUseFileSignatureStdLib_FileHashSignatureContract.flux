use FileSignatureStdLib

program (ExampleOfUseFileSignatureStdLib_FileHashSignatureContract) {
      println("==================================================")
      println("  Exemplo: FileHashSignatureContract (7 Operacoes)")
      println("==================================================")

      mut as string: path = "io_stdlib_fixture.txt"

      #L 1. Calculo de Hashes e Checksums
      println("1. fileSha256: " + fileSha256(path))
      println("2. fileMd5: " + fileMd5(path))
      println("3. fileSha1: " + fileSha1(path))
      println("4. fileCrc32: " + fileCrc32(path))

      #L 2. Verificacao de Integridade
      mut as string: h_sha = fileSha256(path)
      mut as string: h_md5 = fileMd5(path)

      println("5. fileVerifySha256: " + fileVerifySha256(path, h_sha))
      println("6. fileVerifyMd5: " + fileVerifyMd5(path, h_md5))
      println("7. fileVerifyHash (sha256): " + fileVerifyHash(path, h_sha))
      println("   fileVerifyHash (md5): " + fileVerifyHash(path, h_md5))
}
