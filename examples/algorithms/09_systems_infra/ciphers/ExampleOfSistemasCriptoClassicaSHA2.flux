#L ==================================================
#L Algoritmo: SHA-256 Hash Primitive (FIPS PUB 180-4)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O SHA-256 (Secure Hash Algorithm 256-bit) e uma funcao de hash criptografico
#L padronizada pelo NIST no padrao FIPS PUB 180-4. Opera sobre blocos de 512 bits
#L (16 palavras de 32 bits em formato big-endian) gerando um resumo de 256 bits
#L (8 palavras de 32 bits).
#L
#L A estrutura expande 16 palavras em 64 palavras atraves de funcoes sigma0 e sigma1,
#L e processa 64 rodadas com constantes derivadas das raizes cubicas dos primeiros 64 primos.
#L Emprega operacoes bitwise ARX: rotacoes circulares para a direita (ROTR), shifts logicos,
#L funcoes de escolha (Ch) e maioria (Maj).
#L ==================================================

#L Mensagem "TheFlux" pré-processada em 16 palavras big-endian de 32 bits (512 bits)
mut as list of int64: M = [1416127814, 1819637888, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56]

println("==================================================")
println("  SciAlgo: SHA-256 Secure Hash Algorithm (FIPS 180-4)")
println("==================================================")
println("1. Mensagem de Entrada (16 palavras de 32 bits big-endian):")
println("   M[1..2]: [" + M[1] + ", " + M[2] + "]")
println("   M[15..16]: [" + M[15] + ", " + M[16] + "]")

#L 64 Constantes de rodada K derivadas dos primeiros 64 primos
mut as list of int64: K = [1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298]

#L Inicializacao do vetor W com 64 posicoes
mut as list of int64: W = [1416127814, 1819637888, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#L Expansao das palavras W[17..64]
mut as int64: t = 17
infinite (t <= 64) {
      mut as int64: w15 = W[t - 15]
      mut as int64: r15_7 = (w15 >> 7) | ((w15 << 25) & 4294967295)
      mut as int64: r15_18 = (w15 >> 18) | ((w15 << 14) & 4294967295)
      mut as int64: s15_3 = w15 >> 3
      mut as int64: sig0 = (r15_7 ^ r15_18 ^ s15_3) & 4294967295

      mut as int64: w2 = W[t - 2]
      mut as int64: r2_17 = (w2 >> 17) | ((w2 << 15) & 4294967295)
      mut as int64: r2_19 = (w2 >> 19) | ((w2 << 13) & 4294967295)
      mut as int64: s2_10 = w2 >> 10
      mut as int64: sig1 = (r2_17 ^ r2_19 ^ s2_10) & 4294967295

      mut as int64: w16 = W[t - 16]
      mut as int64: w7 = W[t - 7]
      mut as int64: sumW = (w16 + sig0 + w7 + sig1) /r 4294967296
      W[t] = sumW

      t = t + 1
}

#L Estado inicial H0..H7
mut as int64: h0 = 1779033703
mut as int64: h1 = 3144134277
mut as int64: h2 = 1013904242
mut as int64: h3 = 2773480762
mut as int64: h4 = 1359893119
mut as int64: h5 = 2600822924
mut as int64: h6 = 528734635
mut as int64: h7 = 1541459225

mut as int64: a = h0
mut as int64: b = h1
mut as int64: c = h2
mut as int64: d = h3
mut as int64: e = h4
mut as int64: f = h5
mut as int64: g = h6
mut as int64: h = h7

#L 64 Rodadas de compressao
mut as int64: step = 1
infinite (step <= 64) {
      mut as int64: rE6 = (e >> 6) | ((e << 26) & 4294967295)
      mut as int64: rE11 = (e >> 11) | ((e << 21) & 4294967295)
      mut as int64: rE25 = (e >> 25) | ((e << 7) & 4294967295)
      mut as int64: bigS1 = (rE6 ^ rE11 ^ rE25) & 4294967295

      mut as int64: notE = 4294967295 - e
      mut as int64: ch = ((e & f) ^ (notE & g)) & 4294967295

      mut as int64: t1 = (h + bigS1 + ch + K[step] + W[step]) /r 4294967296

      mut as int64: rA2 = (a >> 2) | ((a << 30) & 4294967295)
      mut as int64: rA13 = (a >> 13) | ((a << 19) & 4294967295)
      mut as int64: rA22 = (a >> 22) | ((a << 10) & 4294967295)
      mut as int64: bigS0 = (rA2 ^ rA13 ^ rA22) & 4294967295

      mut as int64: maj = ((a & b) ^ (a & c) ^ (b & c)) & 4294967295
      mut as int64: t2 = (bigS0 + maj) /r 4294967296

      h = g
      g = f
      f = e
      e = (d + t1) /r 4294967296
      d = c
      c = b
      b = a
      a = (t1 + t2) /r 4294967296

      step = step + 1
}

#L Adicao aos valores acumulados de estado
mut as int64: dig0 = (h0 + a) /r 4294967296
mut as int64: dig1 = (h1 + b) /r 4294967296
mut as int64: dig2 = (h2 + c) /r 4294967296
mut as int64: dig3 = (h3 + d) /r 4294967296
mut as int64: dig4 = (h4 + e) /r 4294967296
mut as int64: dig5 = (h5 + f) /r 4294967296
mut as int64: dig6 = (h6 + g) /r 4294967296
mut as int64: dig7 = (h7 + h) /r 4294967296

mut as list of int64: digest = [dig0, dig1, dig2, dig3, dig4, dig5, dig6, dig7]
println("==================================================")
println("2. Digest SHA-256 Calculado (8 palavras de 32 bits):")
println("   Digest: " + digest)

#L Vetor oficial para SHA-256("TheFlux"):
#L dc9adc9f 90d7ac1e 6f111df4 df8c5972 461e933f 1543d148 91c3b67c 788657d8
#L [3701136543, 2430053406, 1863392756, 3750517106, 1176408895, 356766024, 2445522556, 2022070232]
mut as bool: isMatch = (dig0 == 3701136543) and (dig1 == 2430053406) and (dig2 == 1863392756) and (dig3 == 3750517106) and (dig4 == 1176408895) and (dig5 == 356766024) and (dig6 == 2445522556) and (dig7 == 2022070232)

route {
      isMatch ==> {
            println("   SUCESSO: Digest SHA-256 validado estritamente com FIPS PUB 180-4!")
      }
      _ ==> {
            println("   FALHA: Divergencia no calculo do hash SHA-256!")
      }
}
