use FileSignatureStdLib

program (ExampleOfUseFileSignatureStdLib_FileAuthSignatureContract) {
      println("==================================================")
      println("  Exemplo: FileAuthSignatureContract (3 Operacoes)")
      println("==================================================")

      mut as string: path = "io_stdlib_fixture.txt"
      mut as string: key = "chave_secreta"

      #L 1. Assinaturas HMAC com Chave Secreta
      mut as string: hmac_sha = fileHmacSha256(path, key)
      println("1. fileHmacSha256: " + hmac_sha)

      mut as string: hmac_md5 = fileHmacMd5(path, key)
      println("2. fileHmacMd5: " + hmac_md5)

      #L 2. Verificacao da Assinatura HMAC
      println("3. fileVerifyHmac: " + fileVerifyHmac(path, key, hmac_sha))
}
