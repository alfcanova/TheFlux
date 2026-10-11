#L ============================================================================
#L Algoritmo: Authenticated Encryption - SIV Mode (Synthetic IV / Deterministic AEAD)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaAuthenticatedEncryption) {
      println("==================================================")
      println("  SciAlgo: Authenticated Encryption (SIV / AEAD)")
      println("==================================================")

      #L Chaves mestras: K1 (Autenticacao / S2V) e K2 (Cifragem CTR)
      mut as int64: k1 = 3735928559 #L 0xDEADBEEF
      mut as int64: k2 = 3405691582 #L 0xCAFEBABE
      mut as int64: mask32 = 4294967295

      #L Dados Associados (AAD) e Texto Claro
      mut as list of int64: aad = [11, 22]
      mut as int64: aadLen = 2

      mut as list of int64: plaintext = [70, 71, 72, 73]
      mut as int64: ptLen = 4

      println("1. Entradas:")
      println("   AAD:       [" + aad[1] + ", " + aad[2] + "]")
      println("   Plaintext: [" + plaintext[1] + ", " + plaintext[2] + ", " + plaintext[3] + ", " + plaintext[4] + "]")

      println("==================================================")
      println("2. Derivacao do Vetor Sintetico (S2V / Synthetic IV):")
      #L O IV sintetico e derivado pelo PRF sobre AAD e Plaintext
      mut as int64: prfState = k1
      mut as int64: i = 1
      infinite (i <= aadLen) {
            prfState = ((prfState ^ aad[i]) * 16777619 + 2166136261) & mask32
            i = i + 1
      }
      i = 1
      infinite (i <= ptLen) {
            prfState = ((prfState ^ plaintext[i]) * 16777619 + 2166136261) & mask32
            i = i + 1
      }
      mut as int64: synthIv = prfState
      println("   Vetor de Inicializacao Sintetico (IV): " + synthIv)

      println("==================================================")
      println("3. Cifragem CTR usando Synthetic IV:")
      mut as list of int64: ciphertext = [0, 0, 0, 0]
      i = 1
      infinite (i <= ptLen) {
            mut as int64: counter = (synthIv + i) & mask32
            mut as int64: ks = ((counter ^ k2) * 1664525 + 1013904223) & 255
            ciphertext[i] = plaintext[i] ^ ks
            println("   Bloco " + i + ": Claro=" + plaintext[i] + " -> Cifrado=" + ciphertext[i])
            i = i + 1
      }

      println("==================================================")
      println("4. Decifragem Autenticada e Verificacao SIV:")
      #L Receptor primeiro decifra provisoriamente com CTR
      mut as list of int64: candidatePt = [0, 0, 0, 0]
      i = 1
      infinite (i <= ptLen) {
            mut as int64: counter = (synthIv + i) & mask32
            mut as int64: ks = ((counter ^ k2) * 1664525 + 1013904223) & 255
            candidatePt[i] = ciphertext[i] ^ ks
            i = i + 1
      }

      #L Receptor recalcula o Synthetic IV sobre os dados recuperados
      mut as int64: rxPrfState = k1
      i = 1
      infinite (i <= aadLen) {
            rxPrfState = ((rxPrfState ^ aad[i]) * 16777619 + 2166136261) & mask32
            i = i + 1
      }
      i = 1
      infinite (i <= ptLen) {
            rxPrfState = ((rxPrfState ^ candidatePt[i]) * 16777619 + 2166136261) & mask32
            i = i + 1
      }
      mut as int64: verifyIv = rxPrfState
      println("   IV Verificado: " + verifyIv + " (Esperado: " + synthIv + ")")

      route {
            verifyIv == synthIv ==> {
                  println("   SUCESSO: Autenticidade e integridade confirmadas no modo SIV!")
                  println("   Texto recuperado: [" + candidatePt[1] + ", " + candidatePt[2] + ", " + candidatePt[3] + ", " + candidatePt[4] + "]")
            }
            _ ==> {
                  println("   FALHA: IV invalido! Dados adulterados.")
            }
      }

      println("==================================================")
      println("5. Teste de Deteccao de Adulteracao do Cifrado:")
      ciphertext[1] = ciphertext[1] ^ 255
      i = 1
      infinite (i <= ptLen) {
            mut as int64: counter = (synthIv + i) & mask32
            mut as int64: ks = ((counter ^ k2) * 1664525 + 1013904223) & 255
            candidatePt[i] = ciphertext[i] ^ ks
            i = i + 1
      }
      rxPrfState = k1
      i = 1
      infinite (i <= aadLen) {
            rxPrfState = ((rxPrfState ^ aad[i]) * 16777619 + 2166136261) & mask32
            i = i + 1
      }
      i = 1
      infinite (i <= ptLen) {
            rxPrfState = ((rxPrfState ^ candidatePt[i]) * 16777619 + 2166136261) & mask32
            i = i + 1
      }
      mut as int64: badVerifyIv = rxPrfState

      route {
            badVerifyIv == synthIv ==> {
                  println("   FALHA: Adulteracao aceita.")
            }
            _ ==> {
                  println("   SUCESSO: Adulteracao detectada com precisao! IV sintetico divergiu.")
            }
      }
}
