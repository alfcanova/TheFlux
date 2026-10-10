#L ============================================================================
#L Algoritmo: Blowfish (Cifra de Bloco Feistel com P-Array e S-Boxes)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaBlowfish) {
      println("==================================================")
      println("  SciAlgo: Blowfish Block Cipher")
      println("==================================================")

      #L Bloco de 64 bits em duas metades de 32 bits: L e R
      mut as int64: plainL = 305419896 #L 0x12345678
      mut as int64: plainR = 259606910 #L 0x0F7945FE

      #L P-Array inicial (18 subchaves de 32 bits derivadas da expansao de chave)
      mut as list of int64: pArray = [
            606579504, 333644264, 401635467, 127970868,
            242630560, 412586745, 128945673, 893456712,
            567123894, 234891256, 789123456, 345678912,
            912345678, 123789456, 456123789, 789456123,
            234567891, 567891234
      ]

      println("1. Entrada de 64 bits:")
      println("   Plain L: " + plainL + ", Plain R: " + plainR)

      #L Encriptacao Blowfish (16 rodadas)
      mut as int64: curL = plainL
      mut as int64: curR = plainR

      println("==================================================")
      println("2. Executando 16 Rodadas Feistel de Blowfish:")

      mut as int64: i = 1
      infinite (i <= 16) {
            curL = curL ^ pArray[i]

            #L Funcao F(curL): mistura nao-linear de 4 bytes
            mut as int64: b0 = (curL /i 16777216) /r 256
            mut as int64: b1 = (curL /i 65536) /r 256
            mut as int64: b2 = (curL /i 256) /r 256
            mut as int64: b3 = curL /r 256

            #L F = ((S1[b0] + S2[b1]) ^ S3[b2]) + S4[b3] mod 2^32
            mut as int64: s1 = (b0 * 31 + 17) /r 256
            mut as int64: s2 = (b1 * 47 + 29) /r 256
            mut as int64: s3 = (b2 * 53 + 71) /r 256
            mut as int64: s4 = (b3 * 67 + 97) /r 256
            mut as int64: fVal = (((s1 + s2) ^ s3) + s4) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }

            curR = curR ^ fVal

            #L Troca (swap)
            mut as int64: tmp = curL
            curL = curR
            curR = tmp

            i = i + 1
      }

      #L Pos-processamento Blowfish
      mut as int64: tmpSwap = curL
      curL = curR
      curR = tmpSwap

      curR = curR ^ pArray[17]
      curL = curL ^ pArray[18]

      mut as int64: cipherL = curL
      mut as int64: cipherR = curR
      println("   Ciphertext (L, R): (" + cipherL + ", " + cipherR + ")")

      println("==================================================")
      println("3. Decriptacao Blowfish:")

      mut as int64: decL = cipherL
      mut as int64: decR = cipherR

      decL = decL ^ pArray[18]
      decR = decR ^ pArray[17]

      mut as int64: tmpDecSwap = decL
      decL = decR
      decR = tmpDecSwap

      mut as int64: j = 16
      infinite (j >= 1) {
            #L Swap reverso
            mut as int64: tmp = decL
            decL = decR
            decR = tmp

            mut as int64: b0 = (decL /i 16777216) /r 256
            mut as int64: b1 = (decL /i 65536) /r 256
            mut as int64: b2 = (decL /i 256) /r 256
            mut as int64: b3 = decL /r 256

            mut as int64: s1 = (b0 * 31 + 17) /r 256
            mut as int64: s2 = (b1 * 47 + 29) /r 256
            mut as int64: s3 = (b2 * 53 + 71) /r 256
            mut as int64: s4 = (b3 * 67 + 97) /r 256
            mut as int64: fVal = (((s1 + s2) ^ s3) + s4) /r 4294967296
            infinite (fVal < 0) { fVal = fVal + 4294967296 }

            decR = decR ^ fVal
            decL = decL ^ pArray[j]

            j = j - 1
      }

      mut as int64: restL = decL
      mut as int64: restR = decR

      println("   Restaurado (L, R): (" + restL + ", " + restR + ")")

      route {
            restL == plainL and restR == plainR ==> {
                  println("   SUCESSO: Blowfish cifrou e decifrou perfeitamente com P-array e Feistel!")
            }
            _ ==> {
                  println("   FALHA: Divergência na decriptacao Blowfish.")
            }
      }
}
