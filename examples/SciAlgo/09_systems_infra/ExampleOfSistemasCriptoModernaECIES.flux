#L ============================================================================
#L Algoritmo: ECIES (Elliptic Curve Integrated Encryption Scheme - ISO 18033)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaECIES) {
      println("==================================================")
      println("  SciAlgo: ECIES (Hybrid Elliptic Curve Encryption)")
      println("==================================================")

      #L Parametros do grupo ciclico DHE (simulando corpo da curva eliptica)
      mut as int64: p = 10007
      mut as int64: g = 5

      #L 1. Chaves Estaticas do Destinatario (Bob)
      mut as int64: bobPriv = 456
      mut as int64: bobPub = 1
      mut as int64: bExp = g
      mut as int64: eExp = bobPriv
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
      println("1. Chaves Estaticas de Bob:")
      println("   Chave Privada dB = " + bobPriv)
      println("   Chave Publica QB = " + bobPub)

      println("==================================================")
      println("2. Cifragem ECIES pelo Remetente (Alice):")
      #L Alice deseja enviar mensagem m para Bob
      mut as int64: msg = 7788
      println("   Mensagem Original: " + msg)

      #L Alice gera par efemero (r, R = g^r mod p)
      mut as int64: rNonce = 789
      mut as int64: ephemR = 1
      bExp = g
      eExp = rNonce
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        ephemR = (ephemR * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Chave Efemera R = g^r mod p: " + ephemR)

      #L Alice calcula o segredo compartilhado S = (QB)^r mod p
      mut as int64: aliceSharedS = 1
      bExp = bobPub
      eExp = rNonce
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        aliceSharedS = (aliceSharedS * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Segredo Compartilhado S: " + aliceSharedS)

      #L KDF deriva chave de cifragem Kenc e chave de integridade Kmac
      mut as int64: kEnc = ((aliceSharedS * 31 + 101) * 16777619 + 2166136261) /r 65535
      mut as int64: kMac = ((aliceSharedS * 41 + 202) * 16777619 + 2166136261) /r 65535

      #L Cifragem simetrica do texto claro: c = m ^ Kenc
      mut as int64: ciphertext = msg ^ kEnc

      #L Tag de autenticacao MAC sobre (c || R): tag = HMAC(Kmac, c + R)
      mut as int64: authTag = ((kMac ^ 90) * 16777619 + (ciphertext * 31 + ephemR)) /r 2147483647

      println("   Criptograma ECIES gerado:")
      println("   - Ponto Efemero R: " + ephemR)
      println("   - Texto Cifrado c: " + ciphertext)
      println("   - Tag de Autenticacao: " + authTag)

      println("==================================================")
      println("3. Decifragem ECIES e Verificacao por Bob:")
      #L Bob recupera o segredo compartilhado S = (R)^dB mod p
      mut as int64: bobSharedS = 1
      bExp = ephemR
      eExp = bobPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        bobSharedS = (bobSharedS * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Bob deriva as mesmas chaves Kenc e Kmac
      mut as int64: bobKenc = ((bobSharedS * 31 + 101) * 16777619 + 2166136261) /r 65535
      mut as int64: bobKmac = ((bobSharedS * 41 + 202) * 16777619 + 2166136261) /r 65535

      #L Bob verifica a tag MAC antes de decifrar
      mut as int64: bobVerifyTag = ((bobKmac ^ 90) * 16777619 + (ciphertext * 31 + ephemR)) /r 2147483647
      println("   Tag Recalculada por Bob: " + bobVerifyTag)

      route {
            bobVerifyTag == authTag ==> {
                  println("   Autenticidade confirmada! Procedendo com decifragem:")
                  mut as int64: decryptedMsg = ciphertext ^ bobKenc
                  println("   Mensagem Recuperada por Bob: " + decryptedMsg)
                  route {
                        decryptedMsg == msg ==> {
                              println("   SUCESSO: Esquema Hibrido ECIES validado!")
                        }
                        _ ==> {
                              println("   FALHA: Erro na mensagem recuperada.")
                        }
                  }
            }
            _ ==> {
                  println("   FALHA DE AUTENTICACAO: Tag invalida!")
            }
      }

      println("==================================================")
      println("4. Deteccao de Falsificacao (Tag Alterada):")
      mut as int64: badTag = authTag ^ 1
      route {
            bobVerifyTag == badTag ==> {
                  println("   FALHA: Tag adulterada aceita.")
            }
            _ ==> {
                  println("   SUCESSO: Criptograma adulterado rejeitado sem decifrar.")
            }
      }
}
