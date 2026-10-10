#L ============================================================================
#L Algoritmo: Criptossistema RSA (Rivest-Shamir-Adleman)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaRSA) {
      println("==================================================")
      println("  SciAlgo: RSA Public-Key Cryptosystem")
      println("==================================================")

      #L Primos p = 61, q = 53
      mut as int64: p = 61
      mut as int64: q = 53
      mut as int64: n = p * q #L 3233
      mut as int64: phi = (p - 1) * (q - 1) #L 3120

      #L Chave publica e: gcd(e, phi) == 1
      mut as int64: e = 17

      #L Chave privada d: e * d == 1 (mod phi)
      #L Inverso modular de 17 mod 3120 = 2753
      mut as int64: d = 2753

      println("1. Parametros de Chave RSA:")
      println("   Modulo n (p * q): " + n)
      println("   Totiente phi(n): " + phi)
      println("   Expoente publico (e): " + e)
      println("   Expoente privado (d): " + d)

      #L Mensagem a encriptar: m = 65 ('A')
      mut as int64: m = 65
      println("==================================================")
      println("2. Encriptacao RSA: c = m^e mod n")
      println("   Mensagem original: " + m)

      #L Exponenciacao modular: base^exp mod modulus
      mut as int64: c = 1
      mut as int64: baseEnc = m
      mut as int64: expEnc = e
      infinite (expEnc > 0) {
            route {
                  expEnc /r 2 == 1 ==> {
                        c = (c * baseEnc) /r n
                  }
                  _ ==> {}
            }
            baseEnc = (baseEnc * baseEnc) /r n
            expEnc = expEnc /i 2
      }
      println("   Texto cifrado (c): " + c)

      println("==================================================")
      println("3. Decriptacao RSA: m' = c^d mod n")
      mut as int64: mDec = 1
      mut as int64: baseDec = c
      mut as int64: expDec = d
      infinite (expDec > 0) {
            route {
                  expDec /r 2 == 1 ==> {
                        mDec = (mDec * baseDec) /r n
                  }
                  _ ==> {}
            }
            baseDec = (baseDec * baseDec) /r n
            expDec = expDec /i 2
      }
      println("   Mensagem decriptada (m'): " + mDec)

      route {
            mDec == m and c != m ==> {
                  println("   SUCESSO: RSA encriptou e decriptou com perfeicao!")
            }
            _ ==> {
                  println("   FALHA: Divergencia na decriptacao RSA.")
            }
      }
}
