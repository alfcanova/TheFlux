#L ============================================================================
#L Algoritmo: ChaCha20-Poly1305 (RFC 8439 Authenticated Encryption)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaChaCha20Poly1305) {
      println("==================================================")
      println("  SciAlgo: ChaCha20-Poly1305 (RFC 8439 AEAD)")
      println("==================================================")

      #L Estado inicial de 4 palavras de 32 bits (a, b, c, d)
      mut as int64: a = 1633837924 #L Constante "expa"
      mut as int64: b = 3735928559 #L Chave
      mut as int64: c = 2863311530 #L Nonce / Contador
      mut as int64: d = 1414743535 #L Constante "nd 3"
      mut as int64: mask = 4294967295

      println("1. ChaCha20 Quarter-Round:")
      println("   Estado inicial: a=" + a + ", b=" + b + ", c=" + c + ", d=" + d)

      #L Quarter-round ChaCha20
      #L 1. a += b; d ^= a; d <<<= 16
      a = (a + b) & mask
      d = d ^ a
      d = ((d << 16) & mask) | ((d >>> 16) & mask)

      #L 2. c += d; b ^= c; b <<<= 12
      c = (c + d) & mask
      b = b ^ c
      b = ((b << 12) & mask) | ((b >>> 20) & mask)

      #L 3. a += b; d ^= a; d <<<= 8
      a = (a + b) & mask
      d = d ^ a
      d = ((d << 8) & mask) | ((d >>> 24) & mask)

      #L 4. c += d; b ^= c; b <<<= 7
      c = (c + d) & mask
      b = b ^ c
      b = ((b << 7) & mask) | ((b >>> 25) & mask)

      println("   Apos Quarter-Round: a=" + a + ", b=" + b + ", c=" + c + ", d=" + d)

      #L Subchaves de uso unico para Poly1305 (r clampado e s)
      mut as int64: polyR = (a & 268435455) /r 2147483647
      mut as int64: polyS = b & 65535
      mut as int64: primePoly = 2147483647 #L 2^31 - 1

      #L Texto claro de teste
      mut as list of int64: plaintext = [105, 110, 102, 114, 97]
      mut as int64: ptLen = 5

      println("==================================================")
      println("2. Cifragem com Keystream ChaCha20:")
      mut as list of int64: ciphertext = [0, 0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= ptLen) {
            mut as int64: ksByte = (c + i * 53) & 255
            ciphertext[i] = plaintext[i] ^ ksByte
            println("   Byte " + i + ": Claro=" + plaintext[i] + " -> Cifrado=" + ciphertext[i])
            i = i + 1
      }

      println("==================================================")
      println("3. Avaliacao Polinomial Poly1305 (MAC Tag):")
      mut as int64: acc = 0
      i = 1
      infinite (i <= ptLen) {
            acc = (acc + ciphertext[i]) /r primePoly
            acc = (acc * polyR) /r primePoly
            i = i + 1
      }
      mut as int64: authTag = (acc + polyS) /r primePoly
      println("   Tag de Autenticacao Poly1305: " + authTag)

      println("==================================================")
      println("4. Verificacao de Autenticidade e Decifragem:")
      mut as int64: rxAcc = 0
      i = 1
      infinite (i <= ptLen) {
            rxAcc = (rxAcc + ciphertext[i]) /r primePoly
            rxAcc = (rxAcc * polyR) /r primePoly
            i = i + 1
      }
      mut as int64: rxAuthTag = (rxAcc + polyS) /r primePoly

      route {
            rxAuthTag == authTag ==> {
                  println("   Tag valida! Procedendo com a decifragem:")
                  mut as list of int64: decrypted = [0, 0, 0, 0, 0]
                  i = 1
                  infinite (i <= ptLen) {
                        mut as int64: ksByte = (c + i * 53) & 255
                        decrypted[i] = ciphertext[i] ^ ksByte
                        i = i + 1
                  }
                  println("   Texto recuperado: [" + decrypted[1] + ", " + decrypted[2] + ", " + decrypted[3] + ", " + decrypted[4] + ", " + decrypted[5] + "]")
            }
            _ ==> {
                  println("   FALHA: Autenticacao rejeitada!")
            }
      }

      println("==================================================")
      println("5. Deteccao de Falsificacao:")
      ciphertext[1] = ciphertext[1] ^ 1
      rxAcc = 0
      i = 1
      infinite (i <= ptLen) {
            rxAcc = (rxAcc + ciphertext[i]) /r primePoly
            rxAcc = (rxAcc * polyR) /r primePoly
            i = i + 1
      }
      rxAuthTag = (rxAcc + polyS) /r primePoly
      route {
            rxAuthTag == authTag ==> {
                  println("   FALHA: Falsificacao passou despercebida.")
            }
            _ ==> {
                  println("   SUCESSO: Falsificacao detectada! Tag alterada=" + rxAuthTag + " != esperada=" + authTag)
            }
      }
}
