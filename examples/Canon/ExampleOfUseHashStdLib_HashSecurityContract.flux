use HashStdLib

program (ExampleOfUseHashStdLib_HashSecurityContract) {
      println("==================================================")
      println("  Exemplo: HashSecurityContract (Seguranca e HMAC)")
      println("==================================================")

      mut as string: texto = "The Flux Programming Language"
      mut as string: chave = "chave_secreta_flux_2026"

      #L 1. Formatar inteiro de hash em hexadecimal
      mut as int64: crc = hashCrc32(texto)
      println("1. CRC32 inteiro: " + crc)
      println("   hashHex(CRC32): " + hashHex(crc))

      #L 2. HMAC (Keyed-Hash com SHA-256 e MD5)
      println("2. hashHmacSha256(chave, texto): " + hashHmacSha256(chave, texto))
      println("   hashHmacMd5(chave, texto): " + hashHmacMd5(chave, texto))

      #L 3. PBKDF2 (Derivacao de chave baseada em senha com iteracoes)
      mut as string: senha = "minha_senha_super_segura"
      mut as string: sal = "sal_aleatorio_12345"
      println("3. PBKDF2 (10 iteracoes): " + hashPbkdf2(senha, sal, 10))
      println("   PBKDF2 (50 iteracoes): " + hashPbkdf2(senha, sal, 50))

      #L 4. Verificacao de Integridade
      mut as string: hash_esperado = hashSha256(texto)
      println("4. hashVerify com hash correto: " + hashVerify(texto, hash_esperado))
      println("   hashVerify com texto alterado: " + hashVerify("Outro Texto", hash_esperado))
}
