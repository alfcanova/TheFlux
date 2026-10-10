#L ==================================================
#L Algoritmo: SHA-1 Hash Primitive (FIPS PUB 180-4)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O SHA-1 (Secure Hash Algorithm 1) e uma funcao de resumo criptografico
#L projetada pela NSA e publicada pelo NIST em 1995. Produz um resumo de 160 bits
#L (5 palavras de 32 bits) a partir de blocos de mensagem de 512 bits.
#L
#L A estrutura expande 16 palavras de mensagem de 32 bits em 80 palavras atraves
#L de rotacoes circulares e XORs, processando 80 rodadas divididas em quatro etapas
#L com funcoes logicas (Ch, Parity, Maj, Parity) e constantes aditivas distintas.
#L ==================================================

#L Mensagem "TheFlux" pré-processada em 16 palavras big-endian de 32 bits (512 bits)
mut as list of int64: M = [1416127814, 1819637888, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56]

println("==================================================")
println("  SciAlgo: SHA-1 Secure Hash Algorithm (FIPS 180-4)")
println("==================================================")
println("1. Mensagem de Entrada (16 palavras de 32 bits big-endian):")
println("   M[1..2]: [" + M[1] + ", " + M[2] + "]")
println("   M[15..16]: [" + M[15] + ", " + M[16] + "]")

#L Inicializacao do escalonador de mensagens W com 80 palavras
mut as list of int64: W = [1416127814, 1819637888, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#L Expansao das palavras W[17..80]
mut as int64: t = 17
infinite (t <= 80) {
      mut as int64: val = (W[t - 3] ^ W[t - 8] ^ W[t - 14] ^ W[t - 16]) & 4294967295
      mut as int64: rol1 = ((val << 1) & 4294967295) | (val >> 31)
      W[t] = rol1
      t = t + 1
}

#L Constantes de inicializacao padrao SHA-1
mut as int64: h0 = 1732584193
mut as int64: h1 = 4023233417
mut as int64: h2 = 2562383102
mut as int64: h3 = 271733878
mut as int64: h4 = 3285377520

mut as int64: a = h0
mut as int64: b = h1
mut as int64: c = h2
mut as int64: d = h3
mut as int64: e = h4

#L 80 Rodadas de compressao
mut as int64: step = 1
infinite (step <= 80) {
      mut as int64: f = 0
      mut as int64: k = 0

      route {
            step <= 20 ==> {
                  #L Ch(b, c, d) = (b & c) | (~b & d)
                  mut as int64: notB = 4294967295 - b
                  f = ((b & c) | (notB & d)) & 4294967295
                  k = 1518500249
            }
            step <= 40 ==> {
                  #L Parity(b, c, d) = b ^ c ^ d
                  f = (b ^ c ^ d) & 4294967295
                  k = 1859775393
            }
            step <= 60 ==> {
                  #L Maj(b, c, d) = (b & c) | (b & d) | (c & d)
                  f = ((b & c) | (b & d) | (c & d)) & 4294967295
                  k = 2400959708
            }
            _ ==> {
                  #L Parity(b, c, d) = b ^ c ^ d
                  f = (b ^ c ^ d) & 4294967295
                  k = 3395469782
            }
      }

      mut as int64: rolA = ((a << 5) & 4294967295) | (a >> 27)
      mut as int64: temp = (rolA + f + e + k + W[step]) /r 4294967296
      mut as int64: rolB = ((b << 30) & 4294967295) | (b >> 2)

      e = d
      d = c
      c = rolB
      b = a
      a = temp

      step = step + 1
}

#L Adicao ao hash final
mut as int64: dig0 = (h0 + a) /r 4294967296
mut as int64: dig1 = (h1 + b) /r 4294967296
mut as int64: dig2 = (h2 + c) /r 4294967296
mut as int64: dig3 = (h3 + d) /r 4294967296
mut as int64: dig4 = (h4 + e) /r 4294967296

mut as list of int64: digest = [dig0, dig1, dig2, dig3, dig4]
println("==================================================")
println("2. Digest SHA-1 Calculado (5 palavras de 32 bits):")
println("   Digest: " + digest)

#L Vetor oficial para "TheFlux":
#L sha1("TheFlux") = a18a9a0cdfc872701b58b48e201cc822dce3e3df
#L H0=2710215180, H1=3754455664, H2=458798222, H3=538757154, H4=3705922527
mut as bool: isMatch = (dig0 == 2710215180) and (dig1 == 3754455664) and (dig2 == 458798222) and (dig3 == 538757154) and (dig4 == 3705922527)

route {
      isMatch ==> {
            println("   SUCESSO: Digest SHA-1 validado estritamente com FIPS PUB 180-4!")
      }
      _ ==> {
            println("   FALHA: Divergencia no calculo do hash SHA-1!")
      }
}
