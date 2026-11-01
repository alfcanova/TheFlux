#L ============================================================================
#L Algoritmo: Zero-Knowledge Proof (Schnorr Sigma-Protocol for Discrete Log Knowledge)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaZeroKnowledgeProof) {
      println("==================================================")
      println("  SciAlgo: Schnorr Zero-Knowledge Proof (Sigma Protocol)")
      println("==================================================")

      #L Parametros de corpo primo p=10007 e gerador g=5
      mut as int64: p = 10007
      mut as int64: g = 5

      #L Segredo privado da testemunha: x
      mut as int64: secretX = 1234

      #L Chave publica / Declaracao a provar: y = g^x mod p
      mut as int64: pubY = 1
      mut as int64: bExp = g
      mut as int64: eExp = secretX
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

      println("1. Declaracao Publica (Instancia):")
      println("   Primo p = " + p + ", Gerador g = " + g)
      println("   Segredo x (conhecido apenas pelo Provador) = " + secretX)
      println("   Chave Publica y (g^x mod p) = " + pubY)

      println("==================================================")
      println("2. Execucao do Sigma-Protocol (Commitment, Challenge, Response):")
      #L Passo 1: Provador escolhe nonce v e envia Compromisso t = g^v mod p
      mut as int64: nonceV = 456
      mut as int64: commT = 1
      bExp = g
      eExp = nonceV
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        commT = (commT * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Passo 1 (Commitment): t = g^v mod p = " + commT)

      #L Passo 2: Verificador emite Desafio c
      mut as int64: challengeC = 78
      println("   Passo 2 (Challenge):  c = " + challengeC)

      #L Passo 3: Provador calcula Resposta s = v + c * x
      mut as int64: respS = nonceV + challengeC * secretX
      println("   Passo 3 (Response):   s = v + c * x = " + respS)

      println("==================================================")
      println("3. Verificacao de Completude (Check: g^s == t * y^c mod p):")
      #L LHS = g^s mod p
      mut as int64: lhs = 1
      bExp = g
      eExp = respS
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

      #L y^c mod p
      mut as int64: yc = 1
      bExp = pubY
      eExp = challengeC
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        yc = (yc * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: rhs = (commT * yc) /r p

      println("   LHS (g^s mod p):     " + lhs)
      println("   RHS (t * y^c mod p): " + rhs)

      route {
            lhs == rhs ==> {
                  println("   SUCESSO: Prova ZK aceita pelo Verificador!")
            }
            _ ==> {
                  println("   FALHA: Prova rejeitada.")
            }
      }

      println("==================================================")
      println("4. Propriedade Zero-Knowledge (Simulador HVZK sem a testemunha x):")
      #L O Simulador escolhe c' e s' arbitrariamente primeiro:
      mut as int64: simC = 99
      mut as int64: simS = 5544

      #L Calcula g^s' mod p
      mut as int64: simGs = 1
      bExp = g
      eExp = simS
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        simGs = (simGs * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Calcula y^c' mod p
      mut as int64: simYc = 1
      bExp = pubY
      eExp = simC
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        simYc = (simYc * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Inverso de y^c' mod p
      mut as int64: invSimYc = 1
      bExp = simYc
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        invSimYc = (invSimYc * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      #L O Simulador fabrica t' = g^s' * (y^c')^(-1) mod p
      mut as int64: simT = (simGs * invSimYc) /r p
      println("   Transcricao Simulada (t'=" + simT + ", c'=" + simC + ", s'=" + simS + ")")

      #L Testa se a transcricao simulada satisfaz a verificacao:
      mut as int64: simCheckRhs = (simT * simYc) /r p
      route {
            simGs == simCheckRhs ==> {
                  println("   SUCESSO: Simulacao perfeita! Prova que nenhum bit de x vazou.")
            }
            _ ==> {
                  println("   FALHA na simulacao.")
            }
      }
}
