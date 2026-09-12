use HashStdLib

program (ExampleOfUseHashStdLib_HashCryptoContract) {
      println("==================================================")
      println("  Exemplo: HashCryptoContract (Digests Criptograficos)")
      println("==================================================")

      mut as string: texto = "The Flux Programming Language"
      mut as string: tx_alt = "The Flux Programming Languagf"
      mut as string: vazio = ""

      #L 1. Familia SHA-2 e SHA-3
      println("1. SHA-224: " + hashSha224(texto))
      println("   SHA-256(texto): " + hashSha256(texto))
      println("   SHA-256(vazio): " + hashSha256(vazio))
      println("   SHA-384: " + hashSha384(texto))
      println("   SHA-512(texto): " + hashSha512(texto))
      println("   SHA3-224: " + hashSha3224(texto))
      println("   SHA3-256: " + hashSha3256(texto))
      println("   SHA3-384: " + hashSha3384(texto))
      println("   SHA3-512: " + hashSha3512(texto))

      #L 2. MD5 e SHA-1
      println("2. MD5(texto): " + hashMd5(texto))
      println("   MD5(vazio): " + hashMd5(vazio))
      println("   SHA-1(texto): " + hashSha1(texto))

      #L 3. Outros Digests (BLAKE2s, BLAKE3, Ascon, RIPEMD160)
      println("3. BLAKE2s: " + hashBlake2s(texto))
      println("   BLAKE3: " + hashBlake3(texto))
      println("   Ascon: " + hashAscon(texto))
      println("   RIPEMD-160: " + hashRipemd160(texto))

      #L 4. Testes de Determinismo e Sensibilidade (Avalanche Effect)
      mut as string: s1 = hashSha256(texto)
      mut as string: s2 = hashSha256(texto)
      mut as string: s_alt = hashSha256(tx_alt)
      println("4. Determinismo (s1 == s2): " + (s1 == s2))
      println("   Sensibilidade (s1 != s_alt): " + (s1 != s_alt))
}
