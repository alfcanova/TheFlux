#L ============================================================================
#L Algoritmo: 1-out-of-2 Oblivious Transfer Protocol (Even-Goldreich-Lempel)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaObliviousTransfer) {
      println("==================================================")
      println("  SciAlgo: 1-out-of-2 Oblivious Transfer (1-2 OT)")
      println("==================================================")

      #L Parametros de corpo primo e gerador
      mut as int64: p = 10007
      mut as int64: g = 5

      #L Remetente (Alice) possui duas mensagens secretas: M0 e M1
      mut as int64: m0 = 4455
      mut as int64: m1 = 8899
      println("1. Mensagens do Remetente (Alice):")
      println("   M0 = " + m0)
      println("   M1 = " + m1)

      #L Alice publica uma constante de grupo aleatoria C
      mut as int64: cConst = 3719
      println("   Constante publica C = " + cConst)

      println("==================================================")
      println("2. Escolha e Chaves do Receptor (Bob):")
      #L Bob deseja obter apenas M_b para o bit de escolha b = 1
      #L sem que Alice saiba qual bit Bob escolheu (Privacidade do Receptor)
      mut as int64: choiceBit = 1
      mut as int64: bobK = 239 #L Segredo efemero de Bob

      #L g^k mod p
      mut as int64: gk = 1
      mut as int64: bExp = g
      mut as int64: eExp = bobK
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        gk = (gk * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Se choiceBit == 1, Bob define PK1 = g^k e PK0 = C * (PK1)^(-1)
      mut as int64: pk1 = gk
      #L Inverso de PK1
      mut as int64: invPk1 = 1
      bExp = pk1
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        invPk1 = (invPk1 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: pk0 = (cConst * invPk1) /r p

      println("   Bit de Escolha de Bob: b = " + choiceBit)
      println("   Bob envia chave publica PK0 = " + pk0)

      println("==================================================")
      println("3. Cifragem Dupla por Alice:")
      #L Alice recebe PK0 e deriva PK1 = C * (PK0)^(-1) mod p
      mut as int64: invPk0 = 1
      bExp = pk0
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        invPk0 = (invPk0 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: alicePk1 = (cConst * invPk0) /r p

      #L Alice cifra M0 usando segredo r0
      mut as int64: r0 = 412
      mut as int64: gr0 = 1
      bExp = g
      eExp = r0
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        gr0 = (gr0 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: key0 = 1
      bExp = pk0
      eExp = r0
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        key0 = (key0 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: ct0 = m0 ^ key0

      #L Alice cifra M1 usando segredo r1
      mut as int64: r1 = 655
      mut as int64: gr1 = 1
      bExp = g
      eExp = r1
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        gr1 = (gr1 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: key1 = 1
      bExp = alicePk1
      eExp = r1
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        key1 = (key1 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: ct1 = m1 ^ key1

      println("   Alice envia (gr0=" + gr0 + ", ct0=" + ct0 + ") e (gr1=" + gr1 + ", ct1=" + ct1 + ")")

      println("==================================================")
      println("4. Decifragem Oblíqua por Bob:")
      #L Como Bob conhece k para PK1 (b=1), Bob calcula keyBob = (gr1)^k mod p
      mut as int64: keyBob = 1
      bExp = gr1
      eExp = bobK
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        keyBob = (keyBob * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: recoveredM1 = ct1 ^ keyBob
      println("   Mensagem decifrada por Bob (M1): " + recoveredM1)

      route {
            recoveredM1 == m1 ==> {
                  println("   SUCESSO: Bob obteve a mensagem escolhida M1!")
            }
            _ ==> {
                  println("   FALHA: Erro na recuperacao da mensagem escolhida.")
            }
      }

      #L Bob tenta decifrar M0 usando k (mas k nao e log discreto de PK0)
      mut as int64: falseKey0 = 1
      bExp = gr0
      eExp = bobK
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        falseKey0 = (falseKey0 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: falseM0 = ct0 ^ falseKey0
      println("   Tentativa de Bob decifrar M0: " + falseM0)

      route {
            falseM0 != m0 ==> {
                  println("   SUCESSO: Seguranca do Remetente garantida (Bob aprendeu ZERO sobre M0).")
            }
            _ ==> {
                  println("   FALHA DE SEGURANCA: Bob decifrou M0 indevidamente.")
            }
      }
}
