#L ============================================================================
#L Algoritmo: Schnorr Signature Scheme (Assinatura Digital com Verificacao Linear)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaSchnorrSignature) {
      println("==================================================")
      println("  SciAlgo: Schnorr Digital Signature Scheme")
      println("==================================================")

      #L Parametros de corpo primo p=10007 e gerador g=5
      mut as int64: p = 10007
      mut as int64: g = 5

      #L 1. Geracao do Par de Chaves: x (privada), y = g^x mod p (publica)
      mut as int64: privX = 1234
      mut as int64: pubY = 1
      mut as int64: bExp = g
      mut as int64: eExp = privX
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        pubY = (pubY * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("1. Par de Chaves:")
      println("   Chave Privada x = " + privX)
      println("   Chave Publica y (g^x mod p) = " + pubY)

      println("==================================================")
      println("2. Geracao da Assinatura Schnorr (r, s):")
      mut as int64: msg = 998877

      #L Nonce efêmero k e compromisso r = g^k mod p
      mut as int64: nonceK = 456
      mut as int64: commR = 1
      bExp = g
      eExp = nonceK
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        commR = (commR * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Compromisso r = g^k mod p: " + commR)

      #L Desafio de Fiat-Shamir: e = H(r || y || msg)
      mut as int64: challengeE = ((commR * 31 + pubY * 7 + msg * 3) /r 100) + 1
      println("   Desafio e = H(r, y, msg):  " + challengeE)

      #L Resposta linear s = k + e * x
      mut as int64: sigS = nonceK + challengeE * privX
      println("   Assinatura Schnorr (r=" + commR + ", s=" + sigS + ")")

      println("==================================================")
      println("3. Verificacao da Assinatura (Check: g^s == r * y^e mod p):")
      #L LHS = g^s mod p
      mut as int64: lhs = 1
      bExp = g
      eExp = sigS
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        lhs = (lhs * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L y^e mod p
      mut as int64: ye = 1
      bExp = pubY
      eExp = challengeE
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        ye = (ye * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: rhs = (commR * ye) /r p

      println("   LHS (g^s mod p):     " + lhs)
      println("   RHS (r * y^e mod p): " + rhs)

      route {
            lhs == rhs ==> {
                  println("   SUCESSO: Assinatura Schnorr verificada com sucesso!")
            }
            _ ==> {
                  println("   FALHA: Assinatura rejeitada.")
            }
      }

      println("==================================================")
      println("4. Deteccao de Falsificacao (Mensagem Adulterada):")
      mut as int64: badMsg = msg + 1
      mut as int64: badE = ((commR * 31 + pubY * 7 + badMsg * 3) /r 100) + 1
      mut as int64: badYe = 1
      bExp = pubY
      eExp = badE
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        badYe = (badYe * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: badRhs = (commR * badYe) /r p

      route {
            lhs == badRhs ==> {
                  println("   FALHA: Falsificacao aceita.")
            }
            _ ==> {
                  println("   SUCESSO: Assinatura rejeitada para mensagem adulterada (LHS != badRHS).")
            }
      }
}
