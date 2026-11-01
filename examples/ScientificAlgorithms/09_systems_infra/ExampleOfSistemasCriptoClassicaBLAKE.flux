#L ==================================================
#L Algoritmo: BLAKE Cryptographic Hash Primitive
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O BLAKE e uma funcao de resumo criptografico projetada por Jean-Philippe
#L Aumasson, Willi Meier, Raphael Phan e Luca Henzen como candidata ao padrao SHA-3.
#L Combina a estrutura HAIFA com o nucleo ARX e a funcao de permutacao da cifra ChaCha.
#L
#L A matriz interna de 16 palavras (4x4) e atualizada pela funcao de compressao G:
#L   G(a, b, c, d, m0, c0, m1, c1):
#L     a = (a + b + (m0 ^ c0)) mod 2^32
#L     d = ROTR(d ^ a, 16)
#L     c = (c + d) mod 2^32
#L     b = ROTR(b ^ c, 12)
#L     a = (a + b + (m1 ^ c1)) mod 2^32
#L     d = ROTR(d ^ a, 8)
#L     c = (c + d) mod 2^32
#L     b = ROTR(b ^ c, 7)
#L ==================================================

#L Mensagem "TheFlux" pré-processada em 16 palavras de 32 bits
mut as list of int64: M = [1416127814, 1819637888, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

println("==================================================")
println("  SciAlgo: BLAKE Hash Primitive (HAIFA Mode + ChaCha Core)")
println("==================================================")
println("1. Mensagem de Entrada:")
println("   M[1..2]: [" + M[1] + ", " + M[2] + "]")

#L Vetor de Inicializacao IV (8 palavras)
mut as list of int64: IV = [1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225]

#L Constantes de dispersao C (16 palavras)
mut as list of int64: C = [608135816, 2242058451, 320436782, 57701188, 2752034850, 698298832, 137296536, 3964529801, 1160258022, 953160567, 3193202383, 887688300, 3232508343, 3380367581, 1065670069, 3041331479]

#L Inicializacao do estado V (16 palavras)
mut as list of int64: V = [1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225, 608135816, 2242058451, 320436782, 57701188, 2752034850, 698298832, 137296536, 3964529801]

#L Contador de bits (t = 56) injetado em V[13] e V[14]
V[13] = V[13] ^ 56
V[14] = V[14] ^ 56

#L Permutacoes Sigma para duas rodadas completas
mut as list of int64: sig1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
mut as list of int64: sig2 = [15, 11, 5, 9, 10, 16, 14, 7, 2, 13, 1, 3, 12, 8, 6, 4]

#L Rodadas de compressao BLAKE
mut as int64: r = 1
infinite (r <= 2) {
      mut as list of int64: s = sig1
      route {
            r == 2 ==> { s = sig2 }
            _ ==> {}
      }

      #L Passos de Coluna: G0, G1, G2, G3
      #L G0: colunas (1, 5, 9, 13)
      mut as int64: m0 = M[s[1]]
      mut as int64: c0 = C[s[2]]
      mut as int64: m1 = M[s[2]]
      mut as int64: c1 = C[s[1]]
      V[1] = (V[1] + V[5] + (m0 ^ c0)) /r 4294967296
      mut as int64: xd0 = (V[13] ^ V[1]) & 4294967295
      V[13] = (xd0 >> 16) | ((xd0 << 16) & 4294967295)
      V[9] = (V[9] + V[13]) /r 4294967296
      mut as int64: xb0 = (V[5] ^ V[9]) & 4294967295
      V[5] = (xb0 >> 12) | ((xb0 << 20) & 4294967295)
      V[1] = (V[1] + V[5] + (m1 ^ c1)) /r 4294967296
      mut as int64: xd0_2 = (V[13] ^ V[1]) & 4294967295
      V[13] = (xd0_2 >> 8) | ((xd0_2 << 24) & 4294967295)
      V[9] = (V[9] + V[13]) /r 4294967296
      mut as int64: xb0_2 = (V[5] ^ V[9]) & 4294967295
      V[5] = (xb0_2 >> 7) | ((xb0_2 << 25) & 4294967295)

      #L G1: colunas (2, 6, 10, 14)
      mut as int64: m2 = M[s[3]]
      mut as int64: c2 = C[s[4]]
      mut as int64: m3 = M[s[4]]
      mut as int64: c3 = C[s[3]]
      V[2] = (V[2] + V[6] + (m2 ^ c2)) /r 4294967296
      mut as int64: xd1 = (V[14] ^ V[2]) & 4294967295
      V[14] = (xd1 >> 16) | ((xd1 << 16) & 4294967295)
      V[10] = (V[10] + V[14]) /r 4294967296
      mut as int64: xb1 = (V[6] ^ V[10]) & 4294967295
      V[6] = (xb1 >> 12) | ((xb1 << 20) & 4294967295)
      V[2] = (V[2] + V[6] + (m3 ^ c3)) /r 4294967296
      mut as int64: xd1_2 = (V[14] ^ V[2]) & 4294967295
      V[14] = (xd1_2 >> 8) | ((xd1_2 << 24) & 4294967295)
      V[10] = (V[10] + V[14]) /r 4294967296
      mut as int64: xb1_2 = (V[6] ^ V[10]) & 4294967295
      V[6] = (xb1_2 >> 7) | ((xb1_2 << 25) & 4294967295)

      #L G2: colunas (3, 7, 11, 15)
      mut as int64: m4 = M[s[5]]
      mut as int64: c4 = C[s[6]]
      mut as int64: m5 = M[s[6]]
      mut as int64: c5 = C[s[5]]
      V[3] = (V[3] + V[7] + (m4 ^ c4)) /r 4294967296
      mut as int64: xd2 = (V[15] ^ V[3]) & 4294967295
      V[15] = (xd2 >> 16) | ((xd2 << 16) & 4294967295)
      V[11] = (V[11] + V[15]) /r 4294967296
      mut as int64: xb2 = (V[7] ^ V[11]) & 4294967295
      V[7] = (xb2 >> 12) | ((xb2 << 20) & 4294967295)
      V[3] = (V[3] + V[7] + (m5 ^ c5)) /r 4294967296
      mut as int64: xd2_2 = (V[15] ^ V[3]) & 4294967295
      V[15] = (xd2_2 >> 8) | ((xd2_2 << 24) & 4294967295)
      V[11] = (V[11] + V[15]) /r 4294967296
      mut as int64: xb2_2 = (V[7] ^ V[11]) & 4294967295
      V[7] = (xb2_2 >> 7) | ((xb2_2 << 25) & 4294967295)

      #L G3: colunas (4, 8, 12, 16)
      mut as int64: m6 = M[s[7]]
      mut as int64: c6 = C[s[8]]
      mut as int64: m7 = M[s[8]]
      mut as int64: c7 = C[s[7]]
      V[4] = (V[4] + V[8] + (m6 ^ c6)) /r 4294967296
      mut as int64: xd3 = (V[16] ^ V[4]) & 4294967295
      V[16] = (xd3 >> 16) | ((xd3 << 16) & 4294967295)
      V[12] = (V[12] + V[16]) /r 4294967296
      mut as int64: xb3 = (V[8] ^ V[12]) & 4294967295
      V[8] = (xb3 >> 12) | ((xb3 << 20) & 4294967295)
      V[4] = (V[4] + V[8] + (m7 ^ c7)) /r 4294967296
      mut as int64: xd3_2 = (V[16] ^ V[4]) & 4294967295
      V[16] = (xd3_2 >> 8) | ((xd3_2 << 24) & 4294967295)
      V[12] = (V[12] + V[16]) /r 4294967296
      mut as int64: xb3_2 = (V[8] ^ V[12]) & 4294967295
      V[8] = (xb3_2 >> 7) | ((xb3_2 << 25) & 4294967295)

      #L Passos Diagonais: G4, G5, G6, G7
      #L G4: diagonais (1, 6, 11, 16)
      mut as int64: m8 = M[s[9]]
      mut as int64: c8 = C[s[10]]
      mut as int64: m9 = M[s[10]]
      mut as int64: c9 = C[s[9]]
      V[1] = (V[1] + V[6] + (m8 ^ c8)) /r 4294967296
      mut as int64: xd4 = (V[16] ^ V[1]) & 4294967295
      V[16] = (xd4 >> 16) | ((xd4 << 16) & 4294967295)
      V[11] = (V[11] + V[16]) /r 4294967296
      mut as int64: xb4 = (V[6] ^ V[11]) & 4294967295
      V[6] = (xb4 >> 12) | ((xb4 << 20) & 4294967295)
      V[1] = (V[1] + V[6] + (m9 ^ c9)) /r 4294967296
      mut as int64: xd4_2 = (V[16] ^ V[1]) & 4294967295
      V[16] = (xd4_2 >> 8) | ((xd4_2 << 24) & 4294967295)
      V[11] = (V[11] + V[16]) /r 4294967296
      mut as int64: xb4_2 = (V[6] ^ V[11]) & 4294967295
      V[6] = (xb4_2 >> 7) | ((xb4_2 << 25) & 4294967295)

      #L G5: diagonais (2, 7, 12, 13)
      mut as int64: m10 = M[s[11]]
      mut as int64: c10 = C[s[12]]
      mut as int64: m11 = M[s[12]]
      mut as int64: c11 = C[s[11]]
      V[2] = (V[2] + V[7] + (m10 ^ c10)) /r 4294967296
      mut as int64: xd5 = (V[13] ^ V[2]) & 4294967295
      V[13] = (xd5 >> 16) | ((xd5 << 16) & 4294967295)
      V[12] = (V[12] + V[13]) /r 4294967296
      mut as int64: xb5 = (V[7] ^ V[12]) & 4294967295
      V[7] = (xb5 >> 12) | ((xb5 << 20) & 4294967295)
      V[2] = (V[2] + V[7] + (m11 ^ c11)) /r 4294967296
      mut as int64: xd5_2 = (V[13] ^ V[2]) & 4294967295
      V[13] = (xd5_2 >> 8) | ((xd5_2 << 24) & 4294967295)
      V[12] = (V[12] + V[13]) /r 4294967296
      mut as int64: xb5_2 = (V[7] ^ V[12]) & 4294967295
      V[7] = (xb5_2 >> 7) | ((xb5_2 << 25) & 4294967295)

      #L G6: diagonais (3, 8, 9, 14)
      mut as int64: m12 = M[s[13]]
      mut as int64: c12 = C[s[14]]
      mut as int64: m13 = M[s[14]]
      mut as int64: c13 = C[s[13]]
      V[3] = (V[3] + V[8] + (m12 ^ c12)) /r 4294967296
      mut as int64: xd6 = (V[14] ^ V[3]) & 4294967295
      V[14] = (xd6 >> 16) | ((xd6 << 16) & 4294967295)
      V[9] = (V[9] + V[14]) /r 4294967296
      mut as int64: xb6 = (V[8] ^ V[9]) & 4294967295
      V[8] = (xb6 >> 12) | ((xb6 << 20) & 4294967295)
      V[3] = (V[3] + V[8] + (m13 ^ c13)) /r 4294967296
      mut as int64: xd6_2 = (V[14] ^ V[3]) & 4294967295
      V[14] = (xd6_2 >> 8) | ((xd6_2 << 24) & 4294967295)
      V[9] = (V[9] + V[14]) /r 4294967296
      mut as int64: xb6_2 = (V[8] ^ V[9]) & 4294967295
      V[8] = (xb6_2 >> 7) | ((xb6_2 << 25) & 4294967295)

      #L G7: diagonais (4, 5, 10, 15)
      mut as int64: m14 = M[s[15]]
      mut as int64: c14 = C[s[16]]
      mut as int64: m15 = M[s[16]]
      mut as int64: c15 = C[s[15]]
      V[4] = (V[4] + V[5] + (m14 ^ c14)) /r 4294967296
      mut as int64: xd7 = (V[15] ^ V[4]) & 4294967295
      V[15] = (xd7 >> 16) | ((xd7 << 16) & 4294967295)
      V[10] = (V[10] + V[15]) /r 4294967296
      mut as int64: xb7 = (V[5] ^ V[10]) & 4294967295
      V[5] = (xb7 >> 12) | ((xb7 << 20) & 4294967295)
      V[4] = (V[4] + V[5] + (m15 ^ c15)) /r 4294967296
      mut as int64: xd7_2 = (V[15] ^ V[4]) & 4294967295
      V[15] = (xd7_2 >> 8) | ((xd7_2 << 24) & 4294967295)
      V[10] = (V[10] + V[15]) /r 4294967296
      mut as int64: xb7_2 = (V[5] ^ V[10]) & 4294967295
      V[5] = (xb7_2 >> 7) | ((xb7_2 << 25) & 4294967295)

      r = r + 1
}

#L Finalizacao: h'[i] = IV[i] ^ V[i] ^ V[i+8]
mut as list of int64: digest = [0, 0, 0, 0, 0, 0, 0, 0]
mut as int64: fi = 1
infinite (fi <= 8) {
      digest[fi] = (IV[fi] ^ V[fi] ^ V[fi + 8]) & 4294967295
      fi = fi + 1
}

println("==================================================")
println("2. Digest BLAKE Calculado (8 palavras de 32 bits):")
println("   Digest: " + digest)

mut as bool: isMatch = (digest[1] == 2576501928) and (digest[2] == 4049648379) and (digest[3] == 430572926) and (digest[4] == 3778563663) and (digest[5] == 97612632) and (digest[6] == 3009624558) and (digest[7] == 1952047001) and (digest[8] == 1110351783)

route {
      isMatch ==> {
            println("   SUCESSO: Funcao de hash BLAKE completou compressao e validou estado exato!")
      }
      _ ==> {
            println("   FALHA: Divergencia na primitiva de hash BLAKE!")
      }
}
