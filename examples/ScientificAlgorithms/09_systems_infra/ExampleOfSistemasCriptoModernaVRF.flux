#L ============================================================================
#L Algoritmo: VRF (Verifiable Random Function - Micali-Rabin-Vadhan / ECVRF)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaVRF) {
      println("==================================================")
      println("  SciAlgo: Verifiable Random Function (VRF)")
      println("==================================================")

      #L Parametros de corpo primo p=10007 e gerador g=5
      mut as int64: p = 10007
      mut as int64: g = 5

      #L 1. Geracao do Par de Chaves do Provedor
      #L Chave Secreta SK = x, Chave Publica PK = y = g^x mod p
      mut as int64: sk = 4321
      mut as int64: pk = 1
      mut as int64: bExp = g
      mut as int64: eExp = sk
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        pk = (pk * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("1. Par de Chaves do Provedor:")
      println("   Chave Secreta SK = " + sk)
      println("   Chave Publica PK = " + pk)

      println("==================================================")
      println("2. Avaliacao da VRF sobre Entrada alfa (VRF_Hash):")
      #L Entrada publica alfa (seed / rodada da blockchain)
      mut as int64: alpha = 9876

      #L Ponto de hash h = H1(alpha) no grupo
      mut as int64: hPt = ((alpha * 31 + 17) * 16777619 + 2166136261) /r p
      route {
            hPt == 0 ==> {
                  hPt = 1
            }
            _ ==> {}
      }

      #L Ponto pseudorandomico Gamma = h^SK mod p
      mut as int64: gamma = 1
      bExp = hPt
      eExp = sk
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        gamma = (gamma * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Saida verificavel Y = H2(alpha, Gamma)
      mut as int64: vrfOutputY = ((alpha * 10007 + gamma * 37) * 16777619 + 65537) /r 2147483647
      println("   Entrada alfa: " + alpha)
      println("   Ponto Gamma (h^SK mod p): " + gamma)
      println("   Saida Pseudoaleatoria Verificavel Y: " + vrfOutputY)

      println("==================================================")
      println("3. Geracao da Prova DLEQ pi = (c, s):")
      #L Nonce efêmero k para prova de igualdade de log discreto
      mut as int64: kNonce = 789

      #L Compromissos U = g^k mod p e V = h^k mod p
      mut as int64: uComm = 1
      bExp = g
      eExp = kNonce
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        uComm = (uComm * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      mut as int64: vComm = 1
      bExp = hPt
      eExp = kNonce
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        vComm = (vComm * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Desafio c = H3(g, h, PK, Gamma, U, V)
      mut as int64: challengeC = ((g + hPt * 3 + pk * 7 + gamma * 11 + uComm * 13 + vComm * 17) /r 100) + 1
      #L Resposta s = k + c * sk
      mut as int64: respS = kNonce + challengeC * sk

      println("   Prova gerada pi: (c=" + challengeC + ", s=" + respS + ")")

      println("==================================================")
      println("4. Verificacao Publica da Prova:")
      #L Verificador calcula g^s e U * PK^c mod p
      mut as int64: gs = 1
      bExp = g
      eExp = respS
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        gs = (gs * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      mut as int64: pkC = 1
      bExp = pk
      eExp = challengeC
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        pkC = (pkC * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: checkU = (uComm * pkC) /r p

      #L Verificador calcula h^s e V * Gamma^c mod p
      mut as int64: hs = 1
      bExp = hPt
      eExp = respS
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        hs = (hs * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      mut as int64: gammaC = 1
      bExp = gamma
      eExp = challengeC
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        gammaC = (gammaC * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: checkV = (vComm * gammaC) /r p

      println("   Checagem Base 1 (g^s == U * PK^c): " + gs + " == " + checkU)
      println("   Checagem Base 2 (h^s == V * Gamma^c): " + hs + " == " + checkV)

      route {
            gs == checkU ==> {
                  route {
                        hs == checkV ==> {
                              println("   SUCESSO: Prova VRF valida! O valor Y e genuinamente aleatorio e verificavel.")
                        }
                        _ ==> {
                              println("   FALHA: Base 2 divergiu.")
                        }
                  }
            }
            _ ==> {
                  println("   FALHA: Base 1 divergiu.")
            }
      }

      println("==================================================")
      println("5. Deteccao de Falsificacao (Valor Y Alterado):")
      mut as int64: falseGamma = (gamma + 1) /r p
      mut as int64: falseCheckV = 1
      bExp = falseGamma
      eExp = challengeC
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        falseCheckV = (falseCheckV * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      falseCheckV = (vComm * falseCheckV) /r p

      route {
            hs == falseCheckV ==> {
                  println("   FALHA: Falsificacao de Gamma aceita.")
            }
            _ ==> {
                  println("   SUCESSO: Falsificacao rejeitada com sucesso (hs != falseCheckV).")
            }
      }
}
