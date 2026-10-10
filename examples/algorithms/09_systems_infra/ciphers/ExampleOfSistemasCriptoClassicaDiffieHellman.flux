#L ============================================================================
#L Algoritmo: Acordo de Chaves Diffie-Hellman Classico
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaDiffieHellman) {
      println("==================================================")
      println("  SciAlgo: Classical Diffie-Hellman Key Exchange")
      println("==================================================")

      #L Parametros publicos do grupo:
      mut as int64: p = 7919 #L Primo de 13 bits
      mut as int64: g = 7    #L Raiz primitiva / gerador

      println("1. Parametros Publicos do Dominio:")
      println("   Modulo primo p: " + p)
      println("   Gerador g: " + g)

      #L Segredos privados:
      mut as int64: aPriv = 2345 #L Segredo de Alice
      mut as int64: bPriv = 6789 #L Segredo de Bob

      println("==================================================")
      println("2. Geracao de Chaves Publicas:")

      #L Alice calcula A = g^a mod p
      mut as int64: aPub = 1
      mut as int64: baseA = g
      mut as int64: expA = aPriv
      infinite (expA > 0) {
            route {
                  expA /r 2 == 1 ==> {
                        aPub = (aPub * baseA) /r p
                  }
                  _ ==> {}
            }
            baseA = (baseA * baseA) /r p
            expA = expA /i 2
      }
      println("   Chave publica de Alice (A = g^a mod p): " + aPub)

      #L Bob calcula B = g^b mod p
      mut as int64: bPub = 1
      mut as int64: baseB = g
      mut as int64: expB = bPriv
      infinite (expB > 0) {
            route {
                  expB /r 2 == 1 ==> {
                        bPub = (bPub * baseB) /r p
                  }
                  _ ==> {}
            }
            baseB = (baseB * baseB) /r p
            expB = expB /i 2
      }
      println("   Chave publica de Bob (B = g^b mod p): " + bPub)

      println("==================================================")
      println("3. Derivacao do Segredo Compartilhado:")

      #L Alice calcula sAlice = B^a mod p
      mut as int64: sAlice = 1
      mut as int64: baseSA = bPub
      mut as int64: expSA = aPriv
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
      println("   Segredo computado por Alice: " + sAlice)

      #L Bob calcula sBob = A^b mod p
      mut as int64: sBob = 1
      mut as int64: baseSB = aPub
      mut as int64: expSB = bPriv
      infinite (expSB > 0) {
            route {
                  expSB /r 2 == 1 ==> {
                        sBob = (sBob * baseSB) /r p
                  }
                  _ ==> {}
            }
            baseSB = (baseSB * baseSB) /r p
            expSB = expSB /i 2
      }
      println("   Segredo computado por Bob:   " + sBob)

      route {
            sAlice == sBob and sAlice > 0 ==> {
                  println("   SUCESSO: Chaves concordantes derivadas com sucesso!")
            }
            _ ==> {
                  println("   FALHA: Divergência nos segredos compartilhados.")
            }
      }
}
