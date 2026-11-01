#L ============================================================================
#L Algoritmo: Ephemeral Diffie-Hellman Key Exchange (DHE com Exponenciacao Modular)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaDiffieHellman) {
      println("==================================================")
      println("  SciAlgo: Ephemeral Diffie-Hellman Key Exchange (DHE)")
      println("==================================================")

      #L Parametros publicos de dominio (Grupo ciclico primo)
      mut as int64: p = 10007
      mut as int64: g = 5

      println("1. Parametros Publicos de Dominio:")
      println("   Modulo Primo p = " + p)
      println("   Gerador g      = " + g)

      println("==================================================")
      println("2. Geracao de Chaves Efemeras por Alice e Bob:")
      #L Alice escolhe expoente secreto 'a' e calcula chave publica A = g^a mod p
      mut as int64: alicePriv = 1423
      mut as int64: alicePub = 1
      mut as int64: bExp = g
      mut as int64: eExp = alicePriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        alicePub = (alicePub * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Alice: Priv a = " + alicePriv + " -> Pub A (g^a mod p) = " + alicePub)

      #L Bob escolhe expoente secreto 'b' e calcula chave publica B = g^b mod p
      mut as int64: bobPriv = 2876
      mut as int64: bobPub = 1
      bExp = g
      eExp = bobPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        bobPub = (bobPub * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Bob:   Priv b = " + bobPriv + " -> Pub B (g^b mod p) = " + bobPub)

      println("==================================================")
      println("3. Acordo de Chaves Segredo Compartilhado:")
      #L Alice calcula K_A = B^a mod p
      mut as int64: aliceKey = 1
      bExp = bobPub
      eExp = alicePriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        aliceKey = (aliceKey * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Bob calcula K_B = A^b mod p
      mut as int64: bobKey = 1
      bExp = alicePub
      eExp = bobPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        bobKey = (bobKey * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      println("   Chave calculada por Alice (B^a mod p): " + aliceKey)
      println("   Chave calculada por Bob   (A^b mod p): " + bobKey)

      route {
            aliceKey == bobKey ==> {
                  println("   SUCESSO: Chave de sessao identica acordada! K = " + aliceKey)
            }
            _ ==> {
                  println("   FALHA: Divergencia entre as chaves de Alice e Bob.")
            }
      }

      println("==================================================")
      println("4. Vulnerabilidade a Man-In-The-Middle (MITM) sem Autenticacao:")
      #L Um atacante Eva intercepta os canais e injeta seu expoente 'e'
      mut as int64: evePriv = 777
      mut as int64: evePub = 1
      bExp = g
      eExp = evePriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        evePub = (evePub * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Alice negocia com Eva pensando ser Bob: K_AE = (evePub)^alicePriv
      mut as int64: keyAliceEve = 1
      bExp = evePub
      eExp = alicePriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        keyAliceEve = (keyAliceEve * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Bob negocia com Eva pensando ser Alice: K_EB = (evePub)^bobPriv
      mut as int64: keyBobEve = 1
      bExp = evePub
      eExp = bobPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        keyBobEve = (keyBobEve * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      println("   Chave Alice-Eva: " + keyAliceEve)
      println("   Chave Bob-Eva:   " + keyBobEve)
      route {
            keyAliceEve != aliceKey ==> {
                  println("   SUCESSO DIDATICO: DHE puro necessita de assinaturas (como TLS/DHE-RSA) para evitar MITM.")
            }
            _ ==> {}
      }
}
