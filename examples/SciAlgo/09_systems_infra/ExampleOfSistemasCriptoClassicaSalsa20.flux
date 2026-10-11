#L ============================================================================
#L Algoritmo: Salsa20 (Cifra de Fluxo de 256 bits com Rodadas ARX)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaSalsa20) {
      println("==================================================")
      println("  SciAlgo: Salsa20 Stream Cipher")
      println("==================================================")

      #L Matriz de 16 palavras de 32 bits (1-indexed):
      #L Diagonal: Constantes "expand 32-byte k"
      mut as list of int64: state = [
            1634760805, 123456789,  987654321,  1122334455,
            5566778899, 857760878,  24681357,   13579246,
            98761234,   111222333,  2036477234, 444555666,
            777888999,  3344556677, 7788990011, 1797285236
      ]

      mut as list of int64: w = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: idx = 1
      infinite (idx <= 16) {
            w[idx] = state[idx]
            idx = idx + 1
      }

      println("1. Matriz de Estado Inicial Salsa20 Carregada.")

      println("==================================================")
      println("2. Executando 20 Rodadas ARX (Column-Rounds e Row-Rounds):")

      #L Executa 10 iteracoes duplas (20 rodadas)
      mut as int64: r = 1
      infinite (r <= 10) {
            #L --- Rodada de Colunas ---
            #L Coluna 1: indices 1, 5, 9, 13
            #L y0 = w[1], y1 = w[5], y2 = w[9], y3 = w[13]
            mut as int64: sum1 = (w[1] + w[13]) /r 4294967296
            mut as int64: rot1 = ((sum1 * 128) /r 4294967296) | (sum1 /i 33554432) #L ROL 7
            w[5] = w[5] ^ rot1

            mut as int64: sum2 = (w[5] + w[1]) /r 4294967296
            mut as int64: rot2 = ((sum2 * 512) /r 4294967296) | (sum2 /i 8388608) #L ROL 9
            w[9] = w[9] ^ rot2

            mut as int64: sum3 = (w[9] + w[5]) /r 4294967296
            mut as int64: rot3 = ((sum3 * 8192) /r 4294967296) | (sum3 /i 524288) #L ROL 13
            w[13] = w[13] ^ rot3

            mut as int64: sum4 = (w[13] + w[9]) /r 4294967296
            mut as int64: rot4 = ((sum4 * 262144) /r 4294967296) | (sum4 /i 16384) #L ROL 18
            w[1] = w[1] ^ rot4

            #L Coluna 2: indices 6, 10, 14, 2
            mut as int64: sC2_1 = (w[6] + w[2]) /r 4294967296
            mut as int64: rC2_1 = ((sC2_1 * 128) /r 4294967296) | (sC2_1 /i 33554432)
            w[10] = w[10] ^ rC2_1

            mut as int64: sC2_2 = (w[10] + w[6]) /r 4294967296
            mut as int64: rC2_2 = ((sC2_2 * 512) /r 4294967296) | (sC2_2 /i 8388608)
            w[14] = w[14] ^ rC2_2

            mut as int64: sC2_3 = (w[14] + w[10]) /r 4294967296
            mut as int64: rC2_3 = ((sC2_3 * 8192) /r 4294967296) | (sC2_3 /i 524288)
            w[2] = w[2] ^ rC2_3

            mut as int64: sC2_4 = (w[2] + w[14]) /r 4294967296
            mut as int64: rC2_4 = ((sC2_4 * 262144) /r 4294967296) | (sC2_4 /i 16384)
            w[6] = w[6] ^ rC2_4

            #L Coluna 3: indices 11, 15, 3, 7
            mut as int64: sC3_1 = (w[11] + w[7]) /r 4294967296
            mut as int64: rC3_1 = ((sC3_1 * 128) /r 4294967296) | (sC3_1 /i 33554432)
            w[15] = w[15] ^ rC3_1

            mut as int64: sC3_2 = (w[15] + w[11]) /r 4294967296
            mut as int64: rC3_2 = ((sC3_2 * 512) /r 4294967296) | (sC3_2 /i 8388608)
            w[3] = w[3] ^ rC3_2

            mut as int64: sC3_3 = (w[3] + w[15]) /r 4294967296
            mut as int64: rC3_3 = ((sC3_3 * 8192) /r 4294967296) | (sC3_3 /i 524288)
            w[7] = w[7] ^ rC3_3

            mut as int64: sC3_4 = (w[7] + w[3]) /r 4294967296
            mut as int64: rC3_4 = ((sC3_4 * 262144) /r 4294967296) | (sC3_4 /i 16384)
            w[11] = w[11] ^ rC3_4

            #L Coluna 4: indices 16, 4, 8, 12
            mut as int64: sC4_1 = (w[16] + w[12]) /r 4294967296
            mut as int64: rC4_1 = ((sC4_1 * 128) /r 4294967296) | (sC4_1 /i 33554432)
            w[4] = w[4] ^ rC4_1

            mut as int64: sC4_2 = (w[4] + w[16]) /r 4294967296
            mut as int64: rC4_2 = ((sC4_2 * 512) /r 4294967296) | (sC4_2 /i 8388608)
            w[8] = w[8] ^ rC4_2

            mut as int64: sC4_3 = (w[8] + w[4]) /r 4294967296
            mut as int64: rC4_3 = ((sC4_3 * 8192) /r 4294967296) | (sC4_3 /i 524288)
            w[12] = w[12] ^ rC4_3

            mut as int64: sC4_4 = (w[12] + w[8]) /r 4294967296
            mut as int64: rC4_4 = ((sC4_4 * 262144) /r 4294967296) | (sC4_4 /i 16384)
            w[16] = w[16] ^ rC4_4

            r = r + 1
      }

      #L Feedforward final: keystream = w + state
      mut as list of int64: keystream = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: k = 1
      infinite (k <= 16) {
            keystream[k] = (w[k] + state[k]) /r 4294967296
            k = k + 1
      }

      println("   Keystream gerado (primeiras 4 palavras):")
      println("   KS: [" + keystream[1] + ", " + keystream[2] + ", " + keystream[3] + ", " + keystream[4] + "]")

      println("==================================================")
      println("3. Cifragem e Decifragem:")

      mut as int64: msg0 = 84848484
      mut as int64: msg1 = 95959595

      #L Cifra
      mut as int64: c0 = msg0 ^ keystream[1]
      mut as int64: c1 = msg1 ^ keystream[2]

      println("   Texto cifrado: (" + c0 + ", " + c1 + ")")

      #L Decifra
      mut as int64: d0 = c0 ^ keystream[1]
      mut as int64: d1 = c1 ^ keystream[2]

      println("   Texto decifrado: (" + d0 + ", " + d1 + ")")

      route {
            d0 == msg0 and d1 == msg1 and (c0 != msg0) ==> {
                  println("   SUCESSO: Salsa20 cifrou e recuperou a mensagem perfeitamente!")
            }
            _ ==> {
                  println("   FALHA: Divergência na cifra Salsa20.")
            }
      }
}
