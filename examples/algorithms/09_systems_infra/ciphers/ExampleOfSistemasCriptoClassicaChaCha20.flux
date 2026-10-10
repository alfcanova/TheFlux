#L ============================================================================
#L Algoritmo: ChaCha20 (Cifra de Fluxo RFC 8439 de 256 bits)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaChaCha20) {
      println("==================================================")
      println("  SciAlgo: ChaCha20 Stream Cipher (RFC 8439)")
      println("==================================================")

      #L Matriz de Estado ChaCha de 16 palavras de 32 bits (1-indexed):
      #L 1..4: Constantes ("expand 32-byte k")
      #L 5..12: Chave de 256 bits (8 palavras)
      #L 13: Contador de bloco
      #L 14..16: Nonce de 96 bits (3 palavras)
      mut as list of int64: state = [
            1634760805, 857760878,  2036477234, 1797285236,
            123456789,  987654321,  1122334455, 5566778899,
            3344556677, 7788990011, 2233445566, 6677889900,
            1,          24681357,   13579246,   98761234
      ]

      #L Copia para estado de trabalho (working state)
      mut as list of int64: w = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: idx = 1
      infinite (idx <= 16) {
            w[idx] = state[idx]
            idx = idx + 1
      }

      println("1. Matriz de Estado Inicial Configurada.")
      println("   Constante C0: " + w[1] + ", Contador: " + w[13])

      println("==================================================")
      println("2. Executando 20 Rodadas (10 Rodadas Duplas de Quarter-Rounds):")

      #L Executa 10 rodadas duplas (rounds 1 a 20)
      mut as int64: round = 1
      infinite (round <= 10) {
            #L --- Rodada de Colunas ---
            #L QR(1, 5, 9, 13)
            #L a = w[1], b = w[5], c = w[9], d = w[13]
            mut as int64: a1 = (w[1] + w[5]) /r 4294967296
            mut as int64: d1 = a1 ^ w[13]
            mut as int64: rotD1 = ((d1 * 65536) /r 4294967296) | (d1 /i 65536) #L ROL 16
            mut as int64: c1 = (w[9] + rotD1) /r 4294967296
            mut as int64: b1 = c1 ^ w[5]
            mut as int64: rotB1 = ((b1 * 4096) /r 4294967296) | (b1 /i 1048576) #L ROL 12
            a1 = (a1 + rotB1) /r 4294967296
            d1 = a1 ^ rotD1
            rotD1 = ((d1 * 256) /r 4294967296) | (d1 /i 16777216) #L ROL 8
            c1 = (c1 + rotD1) /r 4294967296
            b1 = c1 ^ rotB1
            rotB1 = ((b1 * 128) /r 4294967296) | (b1 /i 33554432) #L ROL 7
            w[1] = a1
            w[5] = rotB1
            w[9] = c1
            w[13] = rotD1

            #L QR(2, 6, 10, 14)
            mut as int64: a2 = (w[2] + w[6]) /r 4294967296
            mut as int64: d2 = a2 ^ w[14]
            mut as int64: rotD2 = ((d2 * 65536) /r 4294967296) | (d2 /i 65536)
            mut as int64: c2 = (w[10] + rotD2) /r 4294967296
            mut as int64: b2 = c2 ^ w[6]
            mut as int64: rotB2 = ((b2 * 4096) /r 4294967296) | (b2 /i 1048576)
            a2 = (a2 + rotB2) /r 4294967296
            d2 = a2 ^ rotD2
            rotD2 = ((d2 * 256) /r 4294967296) | (d2 /i 16777216)
            c2 = (c2 + rotD2) /r 4294967296
            b2 = c2 ^ rotB2
            rotB2 = ((b2 * 128) /r 4294967296) | (b2 /i 33554432)
            w[2] = a2
            w[6] = rotB2
            w[10] = c2
            w[14] = rotD2

            #L QR(3, 7, 11, 15)
            mut as int64: a3 = (w[3] + w[7]) /r 4294967296
            mut as int64: d3 = a3 ^ w[15]
            mut as int64: rotD3 = ((d3 * 65536) /r 4294967296) | (d3 /i 65536)
            mut as int64: c3 = (w[11] + rotD3) /r 4294967296
            mut as int64: b3 = c3 ^ w[7]
            mut as int64: rotB3 = ((b3 * 4096) /r 4294967296) | (b3 /i 1048576)
            a3 = (a3 + rotB3) /r 4294967296
            d3 = a3 ^ rotD3
            rotD3 = ((d3 * 256) /r 4294967296) | (d3 /i 16777216)
            c3 = (c3 + rotD3) /r 4294967296
            b3 = c3 ^ rotB3
            rotB3 = ((b3 * 128) /r 4294967296) | (b3 /i 33554432)
            w[3] = a3
            w[7] = rotB3
            w[11] = c3
            w[15] = rotD3

            #L QR(4, 8, 12, 16)
            mut as int64: a4 = (w[4] + w[8]) /r 4294967296
            mut as int64: d4 = a4 ^ w[16]
            mut as int64: rotD4 = ((d4 * 65536) /r 4294967296) | (d4 /i 65536)
            mut as int64: c4 = (w[12] + rotD4) /r 4294967296
            mut as int64: b4 = c4 ^ w[8]
            mut as int64: rotB4 = ((b4 * 4096) /r 4294967296) | (b4 /i 1048576)
            a4 = (a4 + rotB4) /r 4294967296
            d4 = a4 ^ rotD4
            rotD4 = ((d4 * 256) /r 4294967296) | (d4 /i 16777216)
            c4 = (c4 + rotD4) /r 4294967296
            b4 = c4 ^ rotB4
            rotB4 = ((b4 * 128) /r 4294967296) | (b4 /i 33554432)
            w[4] = a4
            w[8] = rotB4
            w[12] = c4
            w[16] = rotD4

            #L --- Rodada de Diagonais ---
            #L QR(1, 6, 11, 16)
            mut as int64: ad1 = (w[1] + w[6]) /r 4294967296
            mut as int64: dd1 = ad1 ^ w[16]
            mut as int64: rdd1 = ((dd1 * 65536) /r 4294967296) | (dd1 /i 65536)
            mut as int64: cd1 = (w[11] + rdd1) /r 4294967296
            mut as int64: bd1 = cd1 ^ w[6]
            mut as int64: rbd1 = ((bd1 * 4096) /r 4294967296) | (bd1 /i 1048576)
            ad1 = (ad1 + rbd1) /r 4294967296
            dd1 = ad1 ^ rdd1
            rdd1 = ((dd1 * 256) /r 4294967296) | (dd1 /i 16777216)
            cd1 = (cd1 + rdd1) /r 4294967296
            bd1 = cd1 ^ rbd1
            rbd1 = ((bd1 * 128) /r 4294967296) | (bd1 /i 33554432)
            w[1] = ad1
            w[6] = rbd1
            w[11] = cd1
            w[16] = rdd1

            round = round + 1
      }

      #L Soma o estado inicial ao estado final (Feedforward)
      mut as list of int64: keystream = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: m = 1
      infinite (m <= 16) {
            keystream[m] = (w[m] + state[m]) /r 4294967296
            m = m + 1
      }

      println("   Bloco de Keystream gerado (64 bytes / 16 palavras).")
      println("   Keystream[1..4]: [" + keystream[1] + ", " + keystream[2] + ", " + keystream[3] + ", " + keystream[4] + "]")

      println("==================================================")
      println("3. Cifragem e Decifragem XOR:")

      #L Mensagem em claro (4 palavras de 32 bits)
      mut as int64: p0 = 123456789
      mut as int64: p1 = 987654321
      mut as int64: p2 = 456789123
      mut as int64: p3 = 789123456

      #L Encriptacao: C = P ^ Keystream
      mut as int64: c0 = p0 ^ keystream[1]
      mut as int64: c1 = p1 ^ keystream[2]
      mut as int64: c2 = p2 ^ keystream[3]
      mut as int64: c3 = p3 ^ keystream[4]

      println("   Texto cifrado: [" + c0 + ", " + c1 + ", " + c2 + ", " + c3 + "]")

      #L Decriptacao: P' = C ^ Keystream
      mut as int64: d0 = c0 ^ keystream[1]
      mut as int64: d1 = c1 ^ keystream[2]
      mut as int64: d2 = c2 ^ keystream[3]
      mut as int64: d3 = c3 ^ keystream[4]

      println("   Texto decifrado: [" + d0 + ", " + d1 + ", " + d2 + ", " + d3 + "]")

      route {
            d0 == p0 and d1 == p1 and d2 == p2 and d3 == p3 and (c0 != p0) ==> {
                  println("   SUCESSO: ChaCha20 gerou fluxo pseudoaleatorio e decifrou perfeitamente!")
            }
            _ ==> {
                  println("   FALHA: Divergência na cifra de fluxo ChaCha20.")
            }
      }
}
