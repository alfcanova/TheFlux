#L ============================================================================
#L Algoritmo: Criptossistema ElGamal (Cifra e Acordo sobre Grupo Ciclico)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaElGamal) {
      println("==================================================")
      println("  SciAlgo: ElGamal Asymmetric Cryptosystem")
      println("==================================================")

      #L Parametros de Grupo Ciclico Z_p*:
      mut as int64: p = 467 #L Primo seguro
      mut as int64: g = 2   #L Gerador

      #L Chave privada de Alice (x)
      mut as int64: x = 127

      #L Chave publica de Alice: y = g^x mod p
      mut as int64: y = 1
      mut as int64: basePub = g
      mut as int64: expPub = x
      infinite (expPub > 0) {
            route {
                  expPub /r 2 == 1 ==> {
                        y = (y * basePub) /r p
                  }
                  _ ==> {}
            }
            basePub = (basePub * basePub) /r p
            expPub = expPub /i 2
      }

      println("1. Parametros do Sistema:")
      println("   Primo p: " + p)
      println("   Gerador g: " + g)
      println("   Chave privada Alice (x): " + x)
      println("   Chave publica Alice (y = g^x mod p): " + y)

      #L Mensagem a cifrar: m = 89
      mut as int64: m = 89
      #L Segredo efemero de Bob: k = 211
      mut as int64: k = 211

      println("==================================================")
      println("2. Encriptacao por Bob:")
      println("   Mensagem original: " + m)
      println("   Chave efemera k: " + k)

      #L c1 = g^k mod p
      mut as int64: c1 = 1
      mut as int64: baseC1 = g
      mut as int64: expC1 = k
      infinite (expC1 > 0) {
            route {
                  expC1 /r 2 == 1 ==> {
                        c1 = (c1 * baseC1) /r p
                  }
                  _ ==> {}
            }
            baseC1 = (baseC1 * baseC1) /r p
            expC1 = expC1 /i 2
      }

      #L s = y^k mod p (segredo compartilhado efemero)
      mut as int64: sShared = 1
      mut as int64: baseS = y
      mut as int64: expS = k
      infinite (expS > 0) {
            route {
                  expS /r 2 == 1 ==> {
                        sShared = (sShared * baseS) /r p
                  }
                  _ ==> {}
            }
            baseS = (baseS * baseS) /r p
            expS = expS /i 2
      }

      #L c2 = (m * sShared) mod p
      mut as int64: c2 = (m * sShared) /r p

      println("   Texto cifrado par (c1, c2): (" + c1 + ", " + c2 + ")")

      println("==================================================")
      println("3. Decriptacao por Alice:")

      #L Alice calcula s = c1^x mod p
      mut as int64: sAlice = 1
      mut as int64: baseSA = c1
      mut as int64: expSA = x
      infinite (expSA > 0) {
            route {
                  expSA /r 2 == 1 ==> {
                        sAlice = (sAlice * baseSA) /r p
                  }
                  _ ==> {}
            }
            baseSA = (baseSA * baseSA) /r p
            expSA = expSA /i 2
      }

      #L Inverso modular de sAlice: sInv = sAlice^(p - 2) mod p (Pequeno Teorema de Fermat)
      mut as int64: sInv = 1
      mut as int64: baseInv = sAlice
      mut as int64: expInv = p - 2
      infinite (expInv > 0) {
            route {
                  expInv /r 2 == 1 ==> {
                        sInv = (sInv * baseInv) /r p
                  }
                  _ ==> {}
            }
            baseInv = (baseInv * baseInv) /r p
            expInv = expInv /i 2
      }

      #L Mensagem recuperada: m' = (c2 * sInv) mod p
      mut as int64: mDec = (c2 * sInv) /r p
      println("   Mensagem decriptada (m'): " + mDec)

      route {
            mDec == m and sAlice == sShared ==> {
                  println("   SUCESSO: ElGamal cifrou e decifrou perfeitamente!")
            }
            _ ==> {
                  println("   FALHA: Divergência na decifracao ElGamal.")
            }
      }
}
