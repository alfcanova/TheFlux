#L ==================================================
#L Algoritmo: MD5 Message Digest Algorithm (RFC 1321)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O MD5 e uma funcao de dispersao criptografica (hash) de 128 bits
#L projetada por Ronald Rivest em 1991 como sucessor do MD4.
#L Opera sobre blocos de 512 bits organizados em 16 palavras de 32 bits,
#L utilizando 64 passos distribuidos em quatro rodadas com funcoes
#L booleanas nao-lineares distintas (F, G, H, I):
#L   F(X, Y, Z) = (X & Y) | (~X & Z)
#L   G(X, Y, Z) = (X & Z) | (Y & ~Z)
#L   H(X, Y, Z) = X ^ Y ^ Z
#L   I(X, Y, Z) = Y ^ (X | ~Z)
#L
#L Constantes aditivas K[i] derivadas da funcao seno e deslocamentos
#L circulares variaveis garantem efeito avalanche sobre o estado.
#L ==================================================

#L Mensagem "TheFlux" pré-processada em 16 palavras little-endian de 32 bits (512 bits)
mut as list of int64: M = [1181050964, 2155378028, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56, 0]

println("==================================================")
println("  SciAlgo: MD5 Message Digest Algorithm (RFC 1321)")
println("==================================================")
println("1. Mensagem de Entrada (Padding de 512 bits / 16 palavras):")
println("   M[1..4]: [" + M[1] + ", " + M[2] + ", " + M[3] + ", " + M[4] + "]")
println("   M[15..16] (comprimento em bits = 56): [" + M[15] + ", " + M[16] + "]")

#L Constantes de deslocamento s[1..64]
mut as list of int64: s = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]

#L Constantes aditivas K[1..64] = floor(2^32 * abs(sin(i+1)))
mut as list of int64: K = [3614090360, 3905402710, 606105819, 3250441966, 4118548399, 1200080426, 2821735955, 4249261313, 1770035416, 2336552879, 4294925233, 2304563134, 1804603682, 4254626195, 2792965006, 1236535329, 4129170786, 3225465664, 643717713, 3921069994, 3593408605, 38016083, 3634488961, 3889429448, 568446438, 3275163606, 4107603335, 1163531501, 2850285829, 4243563512, 1735328473, 2368359562, 4294588738, 2272392833, 1839030562, 4259657740, 2763975236, 1272893353, 4139469664, 3200236656, 681279174, 3936430074, 3572445317, 76029189, 3654602809, 3873151461, 530742520, 3299628645, 4096336452, 1126891415, 2878612391, 4237533241, 1700485571, 2399980690, 4293915773, 2240044497, 1873313359, 4264355552, 2734768916, 1309151649, 4149444226, 3174756917, 718787259, 3951481745]

#L Vetores de inicializacao padrao MD5
mut as int64: a0 = 1732584193
mut as int64: b0 = 4023233417
mut as int64: c0 = 2562383102
mut as int64: d0 = 271733878

mut as int64: a = a0
mut as int64: b = b0
mut as int64: c = c0
mut as int64: d = d0

#L Execucao das 64 rodadas
mut as int64: i = 0
infinite (i < 64) {
      mut as int64: f = 0
      mut as int64: g = 0

      route {
            i <= 15 ==> {
                  #L F(b, c, d) = (b & c) | (~b & d)
                  mut as int64: notB = 4294967295 - b
                  f = (b & c) | (notB & d)
                  g = i
            }
            i <= 31 ==> {
                  #L G(b, c, d) = (d & b) | (~d & c)
                  mut as int64: notD = 4294967295 - d
                  f = (d & b) | (notD & c)
                  g = ((5 * i) + 1) /r 16
            }
            i <= 47 ==> {
                  #L H(b, c, d) = b ^ c ^ d
                  f = (b ^ c ^ d) & 4294967295
                  g = ((3 * i) + 5) /r 16
            }
            _ ==> {
                  #L I(b, c, d) = c ^ (b | ~d)
                  mut as int64: notD2 = 4294967295 - d
                  f = (c ^ (b | notD2)) & 4294967295
                  g = (7 * i) /r 16
            }
      }

      #L Indice 1-based para lista M
      mut as int64: mVal = M[g + 1]
      mut as int64: kVal = K[i + 1]
      mut as int64: sVal = s[i + 1]

      mut as int64: sumF = (f + a + kVal + mVal) /r 4294967296
      mut as int64: rolF = ((sumF << sVal) & 4294967295) | (sumF >> (32 - sVal))

      a = d
      d = c
      c = b
      b = (b + rolF) /r 4294967296

      i = i + 1
}

#L Adicao ao estado acumulado
mut as int64: digestA = (a + a0) /r 4294967296
mut as int64: digestB = (b + b0) /r 4294967296
mut as int64: digestC = (c + c0) /r 4294967296
mut as int64: digestD = (d + d0) /r 4294967296

println("==================================================")
println("2. Digest MD5 Calculado (Palavras de 32 bits little-endian):")
println("   A: " + digestA)
println("   B: " + digestB)
println("   C: " + digestC)
println("   D: " + digestD)

#L Valores esperados para "TheFlux":
#L MD5("TheFlux") = 285ce2d30674179d8154fd185f097036
#L A = 3554827304, B = 2635559942, C = 419255425, D = 913312095
mut as int64: expA = 3554827304
mut as int64: expB = 2635559942
mut as int64: expC = 419255425
mut as int64: expD = 913312095

route {
      digestA == expA and digestB == expB and digestC == expC and digestD == expD ==> {
            println("   SUCESSO: Digest MD5 validado estritamente com RFC 1321!")
      }
      _ ==> {
            println("   FALHA: Divergencia no calculo do hash MD5!")
      }
}
