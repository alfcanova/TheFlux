#L ==================================================
#L Algoritmo: RIPEMD-160 Hash Algorithm (ISO/IEC 10118-3)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O RIPEMD-160 e uma funcao de dispersao criptografica projetada por
#L Hans Dobbertin, Antoon Bosselaers e Bart Preneel no âmbito do projeto europeu RIPE.
#L Produz um resumo de 160 bits (5 palavras de 32 bits little-endian) a partir
#L de blocos de 512 bits (16 palavras de 32 bits).
#L
#L A arquitetura possui duas linhas paralelas assimetricas de 5 rodadas (80 passos cada):
#L uma linha esquerda e uma linha direita com ordens de permutacao, rotacoes e
#L funcoes booleanas complementares, somando-se ao final em uma estrutura cruzada
#L resistente a criptoanalise diferencial e linear.
#L ==================================================

#L Mensagem "TheFlux" pré-processada em 16 palavras little-endian de 32 bits (512 bits)
mut as list of int64: X = [1181050964, 2155378028, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56, 0]

println("==================================================")
println("  SciAlgo: RIPEMD-160 Cryptographic Hash (ISO 10118-3)")
println("==================================================")
println("1. Mensagem de Entrada (16 palavras little-endian):")
println("   X[1..2]: [" + X[1] + ", " + X[2] + "]")
println("   X[15..16]: [" + X[15] + ", " + X[16] + "]")

#L Constantes aditivas das linhas esquerda (KL) e direita (KR)
mut as list of int64: KL = [0, 1518500249, 1859775393, 2400959708, 2840853838]
mut as list of int64: KR = [1352829926, 1548603684, 1836072691, 2053994217, 0]

#L Selecoes de palavras RL (linha esquerda) e RR (linha direita)
mut as list of int64: RL = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8, 3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12, 1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2, 4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13]
mut as list of int64: RR = [5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12, 6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2, 15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13, 8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14, 12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11]

#L Deslocamentos de rotacao SL e SR
mut as list of int64: SL = [11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8, 7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12, 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5, 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12, 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6]
mut as list of int64: SR = [8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6, 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11, 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5, 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8, 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11]

#L Vetores de inicializacao padrao RIPEMD-160
mut as int64: h0 = 1732584193
mut as int64: h1 = 4023233417
mut as int64: h2 = 2562383102
mut as int64: h3 = 271733878
mut as int64: h4 = 3285377520

mut as int64: A = h0
mut as int64: B = h1
mut as int64: C = h2
mut as int64: D = h3
mut as int64: E = h4

mut as int64: Ap = h0
mut as int64: Bp = h1
mut as int64: Cp = h2
mut as int64: Dp = h3
mut as int64: Ep = h4

#L Execucao dos 80 passos paralelos
mut as int64: step = 0
infinite (step < 80) {
      #L Linha Esquerda
      mut as int64: roundL = step /i 16
      mut as int64: fL = 0
      route {
            roundL == 0 ==> { fL = (B ^ C ^ D) & 4294967295 }
            roundL == 1 ==> {
                  mut as int64: notB = 4294967295 - B
                  fL = ((B & C) | (notB & D)) & 4294967295
            }
            roundL == 2 ==> {
                  mut as int64: notC = 4294967295 - C
                  fL = ((B | notC) ^ D) & 4294967295
            }
            roundL == 3 ==> {
                  mut as int64: notD = 4294967295 - D
                  fL = ((B & D) | (C & notD)) & 4294967295
            }
            _ ==> {
                  mut as int64: notD2 = 4294967295 - D
                  fL = (B ^ (C | notD2)) & 4294967295
            }
      }

      mut as int64: xIdxL = RL[step + 1] + 1
      mut as int64: tL = (A + fL + X[xIdxL] + KL[roundL + 1]) /r 4294967296
      mut as int64: sL = SL[step + 1]
      mut as int64: rolTL = ((tL << sL) & 4294967295) | (tL >> (32 - sL))
      tL = (rolTL + E) /r 4294967296

      mut as int64: rolC10 = ((C << 10) & 4294967295) | (C >> 22)
      A = E
      E = D
      D = rolC10
      C = B
      B = tL

      #L Linha Direita
      mut as int64: roundR = step /i 16
      mut as int64: fR = 0
      mut as int64: invR = 4 - roundR
      route {
            invR == 0 ==> { fR = (Bp ^ Cp ^ Dp) & 4294967295 }
            invR == 1 ==> {
                  mut as int64: notBp = 4294967295 - Bp
                  fR = ((Bp & Cp) | (notBp & Dp)) & 4294967295
            }
            invR == 2 ==> {
                  mut as int64: notCp = 4294967295 - Cp
                  fR = ((Bp | notCp) ^ Dp) & 4294967295
            }
            invR == 3 ==> {
                  mut as int64: notDp = 4294967295 - Dp
                  fR = ((Bp & Dp) | (Cp & notDp)) & 4294967295
            }
            _ ==> {
                  mut as int64: notDp2 = 4294967295 - Dp
                  fR = (Bp ^ (Cp | notDp2)) & 4294967295
            }
      }

      mut as int64: xIdxR = RR[step + 1] + 1
      mut as int64: tR = (Ap + fR + X[xIdxR] + KR[roundR + 1]) /r 4294967296
      mut as int64: sR = SR[step + 1]
      mut as int64: rolTR = ((tR << sR) & 4294967295) | (tR >> (32 - sR))
      tR = (rolTR + Ep) /r 4294967296

      mut as int64: rolCp10 = ((Cp << 10) & 4294967295) | (Cp >> 22)
      Ap = Ep
      Ep = Dp
      Dp = rolCp10
      Cp = Bp
      Bp = tR

      step = step + 1
}

#L Combinacao cruzada final
mut as int64: Tcomb = (h1 + C + Dp) /r 4294967296
h1 = (h2 + D + Ep) /r 4294967296
h2 = (h3 + E + Ap) /r 4294967296
h3 = (h4 + A + Bp) /r 4294967296
h4 = (h0 + B + Cp) /r 4294967296
h0 = Tcomb

mut as list of int64: digest = [h0, h1, h2, h3, h4]
println("==================================================")
println("2. Digest RIPEMD-160 Calculado (5 palavras little-endian):")
println("   Digest: " + digest)

#L Vetor oficial para "TheFlux":
#L [3280563342, 660089452, 1354348721, 1510670554, 4226895629]
mut as bool: isMatch = (digest[1] == 3280563342) and (digest[2] == 660089452) and (digest[3] == 1354348721) and (digest[4] == 1510670554) and (digest[5] == 4226895629)

route {
      isMatch ==> {
            println("   SUCESSO: Digest RIPEMD-160 validado com ISO/IEC 10118-3!")
      }
      _ ==> {
            println("   FALHA: Divergencia na funcao de hash RIPEMD-160!")
      }
}
