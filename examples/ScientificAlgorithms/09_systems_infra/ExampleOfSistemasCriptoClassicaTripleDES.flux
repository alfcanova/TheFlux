#L ============================================================================
#L Algoritmo: Triple DES (3DES em Modo EDE: Encrypt-Decrypt-Encrypt)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaTripleDES) {
      println("==================================================")
      println("  SciAlgo: Triple DES (3DES EDE Mode)")
      println("==================================================")

      #L Bloco original de 64 bits: L0 e R0
      mut as int64: plainL = 305419896 #L 0x12345678
      mut as int64: plainR = 259606910 #L 0x0F7945FE

      #L 3 Chaves de 64 bits distintas para 3DES (K1, K2, K3)
      mut as int64: k1 = 123456789
      mut as int64: k2 = 987654321
      mut as int64: k3 = 555666777

      println("1. Entrada e Chaves 3DES:")
      println("   Plaintext (L0, R0): (" + plainL + ", " + plainR + ")")
      println("   K1 = " + k1 + ", K2 = " + k2 + ", K3 = " + k3)

      println("==================================================")
      println("2. Encriptacao 3DES-EDE: C = E_K3(D_K2(E_K1(P))):")

      #L Estagio 1: Encripta com K1 (4 rodadas Feistel)
      mut as int64: c1L = plainL
      mut as int64: c1R = plainR
      mut as int64: r1 = 1
      infinite (r1 <= 4) {
            mut as int64: fVal = ((c1R * 5 + k1 + r1 * 17) ^ (c1R /i 8)) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }
            mut as int64: nL = c1R
            mut as int64: nR = c1L ^ fVal
            c1L = nL
            c1R = nR
            r1 = r1 + 1
      }
      mut as int64: mid1L = c1R
      mut as int64: mid1R = c1L

      #L Estagio 2: Decripta com K2 (4 rodadas Feistel reversas)
      mut as int64: c2L = mid1L
      mut as int64: c2R = mid1R
      mut as int64: r2 = 4
      infinite (r2 >= 1) {
            mut as int64: fVal = ((c2R * 5 + k2 + r2 * 17) ^ (c2R /i 8)) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }
            mut as int64: nL = c2R
            mut as int64: nR = c2L ^ fVal
            c2L = nL
            c2R = nR
            r2 = r2 - 1
      }
      mut as int64: mid2L = c2R
      mut as int64: mid2R = c2L

      #L Estagio 3: Encripta com K3 (4 rodadas Feistel)
      mut as int64: c3L = mid2L
      mut as int64: c3R = mid2R
      mut as int64: r3 = 1
      infinite (r3 <= 4) {
            mut as int64: fVal = ((c3R * 5 + k3 + r3 * 17) ^ (c3R /i 8)) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }
            mut as int64: nL = c3R
            mut as int64: nR = c3L ^ fVal
            c3L = nL
            c3R = nR
            r3 = r3 + 1
      }
      mut as int64: cipherL = c3R
      mut as int64: cipherR = c3L

      println("   Texto cifrado 3DES (Cipher L, R): (" + cipherL + ", " + cipherR + ")")

      println("==================================================")
      println("3. Decriptacao 3DES-EDE: P = D_K1(E_K2(D_K3(C))):")

      #L Estagio 1 Dec: Decripta com K3
      mut as int64: d1L = cipherL
      mut as int64: d1R = cipherR
      mut as int64: dr1 = 4
      infinite (dr1 >= 1) {
            mut as int64: fVal = ((d1R * 5 + k3 + dr1 * 17) ^ (d1R /i 8)) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }
            mut as int64: nL = d1R
            mut as int64: nR = d1L ^ fVal
            d1L = nL
            d1R = nR
            dr1 = dr1 - 1
      }
      mut as int64: dMid1L = d1R
      mut as int64: dMid1R = d1L

      #L Estagio 2 Dec: Encripta com K2
      mut as int64: d2L = dMid1L
      mut as int64: d2R = dMid1R
      mut as int64: dr2 = 1
      infinite (dr2 <= 4) {
            mut as int64: fVal = ((d2R * 5 + k2 + dr2 * 17) ^ (d2R /i 8)) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }
            mut as int64: nL = d2R
            mut as int64: nR = d2L ^ fVal
            d2L = nL
            d2R = nR
            dr2 = dr2 + 1
      }
      mut as int64: dMid2L = d2R
      mut as int64: dMid2R = d2L

      #L Estagio 3 Dec: Decripta com K1
      mut as int64: d3L = dMid2L
      mut as int64: d3R = dMid2R
      mut as int64: dr3 = 4
      infinite (dr3 >= 1) {
            mut as int64: fVal = ((d3R * 5 + k1 + dr3 * 17) ^ (d3R /i 8)) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }
            mut as int64: nL = d3R
            mut as int64: nR = d3L ^ fVal
            d3L = nL
            d3R = nR
            dr3 = dr3 - 1
      }
      mut as int64: restL = d3R
      mut as int64: restR = d3L

      println("   Texto restaurado (L, R): (" + restL + ", " + restR + ")")

      route {
            restL == plainL and restR == plainR and (cipherL != plainL or cipherR != plainR) ==> {
                  println("   SUCESSO: 3DES EDE completou ciclo de encriptacao e decriptacao com exito!")
            }
            _ ==> {
                  println("   FALHA: Divergência na decriptacao 3DES.")
            }
      }
}
