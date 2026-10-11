#L ============================================================================
#L Algoritmo: RC4 (Rivest Cipher 4 - Cifra de Fluxo de Bytes com KSA e PRGA)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaRC4) {
      println("==================================================")
      println("  SciAlgo: RC4 Stream Cipher (KSA + PRGA)")
      println("==================================================")

      #L Chave de 8 bytes (chave secreta)
      mut as list of int64: key = [1, 35, 69, 103, 137, 171, 205, 239]
      mut as int64: keyLen = 8

      #L Vetor de estado S-Box de 256 bytes (1-indexed: 1 a 256)
      mut as list of int64: sBox = [
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
            16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
            32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
            48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
            64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
            80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
            96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
            112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127,
            128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
            144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
            160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
            176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191,
            192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
            208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223,
            224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
            240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255
      ]

      println("1. Executando Algoritmo de Agendamento de Chave (KSA):")

      #L KSA: permuta S-Box usando a chave
      mut as int64: j = 0
      mut as int64: i = 1
      infinite (i <= 256) {
            mut as int64: keyOffset = (i - 1) /r keyLen + 1
            j = (j + sBox[i] + key[keyOffset]) /r 256
            mut as int64: jIdx = j + 1

            mut as int64: tmp = sBox[i]
            sBox[i] = sBox[jIdx]
            sBox[jIdx] = tmp

            i = i + 1
      }
      println("   S-Box inicializada e permutada com sucesso.")

      #L Copia o S-Box para decriptacao futura
      mut as list of int64: sBoxDec = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: cp = 1
      infinite (cp <= 256) {
            sBoxDec[cp] = sBox[cp]
            cp = cp + 1
      }

      println("==================================================")
      println("2. Geracao de Fluxo PRGA e Encriptacao:")

      #L Mensagem em claro: "TheFlux!" (8 bytes)
      mut as list of int64: plain = [84, 104, 101, 70, 108, 117, 120, 33]
      mut as list of int64: cipher = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: decrypted = [0, 0, 0, 0, 0, 0, 0, 0]

      #L PRGA Encriptacao:
      mut as int64: prgaI = 0
      mut as int64: prgaJ = 0
      mut as int64: b = 1
      infinite (b <= 8) {
            prgaI = (prgaI + 1) /r 256
            mut as int64: iIdx = prgaI + 1
            prgaJ = (prgaJ + sBox[iIdx]) /r 256
            mut as int64: jIdx = prgaJ + 1

            mut as int64: tmp = sBox[iIdx]
            sBox[iIdx] = sBox[jIdx]
            sBox[jIdx] = tmp

            mut as int64: kIdx = (sBox[iIdx] + sBox[jIdx]) /r 256 + 1
            mut as int64: kByte = sBox[kIdx]

            cipher[b] = plain[b] ^ kByte
            b = b + 1
      }

      println("   Bytes cifrados: [" + cipher[1] + ", " + cipher[2] + ", " + cipher[3] + ", " + cipher[4] + "]")

      println("==================================================")
      println("3. Decriptacao RC4 (PRGA com S-Box Restaurado):")

      mut as int64: decI = 0
      mut as int64: decJ = 0
      mut as int64: db = 1
      infinite (db <= 8) {
            decI = (decI + 1) /r 256
            mut as int64: iIdx = decI + 1
            decJ = (decJ + sBoxDec[iIdx]) /r 256
            mut as int64: jIdx = decJ + 1

            mut as int64: tmp = sBoxDec[iIdx]
            sBoxDec[iIdx] = sBoxDec[jIdx]
            sBoxDec[jIdx] = tmp

            mut as int64: kIdx = (sBoxDec[iIdx] + sBoxDec[jIdx]) /r 256 + 1
            mut as int64: kByte = sBoxDec[kIdx]

            decrypted[db] = cipher[db] ^ kByte
            db = db + 1
      }

      println("   Bytes decifrados: [" + decrypted[1] + ", " + decrypted[2] + ", " + decrypted[3] + ", " + decrypted[4] + "]")

      #L Verificacao de igualdade
      mut as int64: matchOk = 1
      mut as int64: v = 1
      infinite (v <= 8) {
            route {
                  decrypted[v] != plain[v] ==> { matchOk = 0 }
                  _ ==> {}
            }
            v = v + 1
      }

      route {
            matchOk == 1 ==> {
                  println("   SUCESSO: RC4 KSA + PRGA gerou fluxo e recuperou texto perfeitamente!")
            }
            _ ==> {
                  println("   FALHA: Divergência na cifra RC4.")
            }
      }
}
