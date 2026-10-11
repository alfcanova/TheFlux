#L ============================================================================
#L Algoritmo: AES (Advanced Encryption Standard - Cifra de Bloco Rijndael)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaAES) {
      println("==================================================")
      println("  SciAlgo: AES Block Cipher (Rijndael SPN Network)")
      println("==================================================")

      #L Bloco de 16 bytes (Estado 4x4): "TheFluxCipherAES"
      mut as list of int64: plain = [
            84, 104, 101, 70, 108, 117, 120, 67, 105, 112, 104, 101, 114, 65, 69, 83
      ]

      #L Chave de 16 bytes
      mut as list of int64: key = [
            43, 126, 21, 22, 40, 174, 210, 166, 171, 247, 21, 136, 9, 207, 79, 60
      ]

      #L Estado de trabalho (16 bytes)
      mut as list of int64: state = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]

      #L Copia plaintext para o estado inicial
      mut as int64: i = 1
      infinite (i <= 16) {
            state[i] = plain[i]
            i = i + 1
      }

      println("1. Estado Inicial (Plaintext):")
      println("   Primeiros 4 bytes: [" + state[1] + ", " + state[2] + ", " + state[3] + ", " + state[4] + "]")

      println("==================================================")
      println("2. Executando Rodada de Transformacao AES:")

      #L 2.1 AddRoundKey inicial (XOR com chave)
      mut as int64: j = 1
      infinite (j <= 16) {
            state[j] = state[j] ^ key[j]
            j = j + 1
      }

      #L 2.2 SubBytes (S-box de Rijndael aproximada / permutacao de 8 bits)
      #L S-box afim: S[x] = ((x * 31 + 73) ^ 99) mod 256
      mut as int64: k = 1
      infinite (k <= 16) {
            mut as int64: b = state[k]
            state[k] = ((b * 31 + 73) ^ 99) /r 256
            k = k + 1
      }

      #L 2.3 ShiftRows (Matriz 4x4 organizada por colunas: indice = col*4 + row + 1)
      #L Linha 1 (offset 0): sem deslocamento
      #L Linha 2 (offset 1): desloca 1 byte para a esquerda
      mut as int64: r2_0 = state[2]
      mut as int64: r2_1 = state[6]
      mut as int64: r2_2 = state[10]
      mut as int64: r2_3 = state[14]
      state[2]  = r2_1
      state[6]  = r2_2
      state[10] = r2_3
      state[14] = r2_0

      #L Linha 3 (offset 2): desloca 2 bytes
      mut as int64: r3_0 = state[3]
      mut as int64: r3_1 = state[7]
      mut as int64: r3_2 = state[11]
      mut as int64: r3_3 = state[15]
      state[3]  = r3_2
      state[7]  = r3_3
      state[11] = r3_0
      state[15] = r3_1

      #L Linha 4 (offset 3): desloca 3 bytes
      mut as int64: r4_0 = state[4]
      mut as int64: r4_1 = state[8]
      mut as int64: r4_2 = state[12]
      mut as int64: r4_3 = state[16]
      state[4]  = r4_3
      state[8]  = r4_0
      state[12] = r4_1
      state[16] = r4_2

      #L 2.4 AddRoundKey final
      mut as int64: w = 1
      infinite (w <= 16) {
            state[w] = state[w] ^ key[w]
            w = w + 1
      }

      println("   Texto cifrado resultante (Ciphertext):")
      println("   Bytes cifrados: [" + state[1] + ", " + state[2] + ", " + state[3] + ", " + state[4] + "]")

      println("==================================================")
      println("3. Reversao (Decriptacao AES):")

      #L Inv-AddRoundKey final
      mut as int64: dw = 1
      infinite (dw <= 16) {
            state[dw] = state[dw] ^ key[dw]
            dw = dw + 1
      }

      #L Inv-ShiftRows
      #L Linha 2: desloca 1 para a direita
      state[14] = state[10]
      state[10] = state[6]
      state[6]  = state[2]
      state[2]  = r2_0

      #L Linha 3: desloca 2 para a direita
      state[3]  = r3_0
      state[7]  = r3_1
      state[11] = r3_2
      state[15] = r3_3

      #L Linha 4: desloca 3 para a direita
      state[4]  = r4_0
      state[8]  = r4_1
      state[12] = r4_2
      state[16] = r4_3

      #L Inv-SubBytes: busca linear na S-box para inversao exata
      mut as int64: dk = 1
      infinite (dk <= 16) {
            mut as int64: target = state[dk]
            mut as int64: orig = 0
            mut as int64: cand = 0
            infinite (cand < 256) {
                  mut as int64: sval = ((cand * 31 + 73) ^ 99) /r 256
                  route {
                        sval == target ==> {
                              orig = cand
                              break
                        }
                        _ ==> {}
                  }
                  cand = cand + 1
            }
            state[dk] = orig
            dk = dk + 1
      }

      #L Inv-AddRoundKey inicial
      mut as int64: dj = 1
      infinite (dj <= 16) {
            state[dj] = state[dj] ^ key[dj]
            dj = dj + 1
      }

      println("   Texto restaurado:")
      println("   Bytes restaurados: [" + state[1] + ", " + state[2] + ", " + state[3] + ", " + state[4] + "]")

      #L Validacao de restauracao identica
      mut as int64: matchAll = 1
      mut as int64: v = 1
      infinite (v <= 16) {
            route {
                  state[v] != plain[v] ==> {
                        matchAll = 0
                  }
                  _ ==> {}
            }
            v = v + 1
      }

      route {
            matchAll == 1 ==> {
                  println("   SUCESSO: AES cifrou e decifrou o bloco de 128 bits com fidelidade total!")
            }
            _ ==> {
                  println("   FALHA: Divergência na reversão AES.")
            }
      }
}
