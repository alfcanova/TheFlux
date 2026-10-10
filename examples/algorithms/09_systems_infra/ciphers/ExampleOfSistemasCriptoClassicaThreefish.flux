#L ==================================================
#L Algoritmo: Threefish Block Cipher (Tweakable UBI Primitive)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Threefish e uma cifra de bloco ajustavel (tweakable block cipher)
#L de tamanho de bloco variavel (256, 512 ou 1024 bits), projetada como
#L nucleo da funcao de dispersao criptografica Skein (finalista NIST SHA-3).
#L Opera exclusivamente com adicoes modulares, rotacoes de bits e XORs (ARX),
#L dispensando tabelas S-Box e garantindo resistencia intrinseca a ataques
#L de canal lateral (timing attacks).
#L
#L A operacao central e a funcao MIX:
#L   MIX(x0, x1):
#L     y0 = (x0 + x1) mod 2^32
#L     y1 = ROL(x1, R) ^ y0
#L
#L Com decriptacao exata atraves do inverso:
#L   InvMIX(y0, y1):
#L     x1 = ROR(y1 ^ y0, R)
#L     x0 = (y0 - x1) mod 2^32
#L ==================================================

mut as list of int64: P = [305419896, 591751049, 878082202, 1164413355]
mut as list of int64: key = [19088743, 2309737967, 3405691582, 3735928559]
mut as list of int64: tweak = [123456789, 987654321]

println("==================================================")
println("  SciAlgo: Threefish Tweakable Block Cipher (ARX)")
println("==================================================")
println("1. Bloco de Entrada P (4 palavras de 32 bits):")
println("   P: " + P)
println("   Chave K: " + key)
println("   Tweak T: " + tweak)

#L Expansao de Chave e Tweak (Chave estendida k5 e t3)
#L Constante C240 = 0x1BD11BDA = 466691034
mut as int64: c240 = 466691034
mut as int64: k4 = (c240 ^ key[1] ^ key[2] ^ key[3] ^ key[4]) & 4294967295
mut as list of int64: extKey = [key[1], key[2], key[3], key[4], k4]

mut as int64: t2 = (tweak[1] ^ tweak[2]) & 4294967295
mut as list of int64: extTweak = [tweak[1], tweak[2], t2]

#L Constantes de Rotacao de Threefish
mut as list of int64: rot0 = [14, 19, 23, 9, 25, 18, 22, 11]
mut as list of int64: rot1 = [16, 21, 15, 17, 13, 12, 7, 27]

#L Estados da cifra
mut as int64: w0 = P[1]
mut as int64: w1 = P[2]
mut as int64: w2 = P[3]
mut as int64: w3 = P[4]

#L Insercao inicial de subchave (d = 0)
mut as int64: sk0_0 = extKey[1]
mut as int64: sk0_1 = (extKey[2] + extTweak[1]) /r 4294967296
mut as int64: sk0_2 = (extKey[3] + extTweak[2]) /r 4294967296
mut as int64: sk0_3 = (extKey[4] + 0) /r 4294967296

w0 = (w0 + sk0_0) /r 4294967296
w1 = (w1 + sk0_1) /r 4294967296
w2 = (w2 + sk0_2) /r 4294967296
w3 = (w3 + sk0_3) /r 4294967296

#L 8 Rodadas de MIX + Permutacao
mut as int64: rIdx = 1
infinite (rIdx <= 8) {
      mut as int64: r0 = rot0[rIdx]
      mut as int64: r1 = rot1[rIdx]

      #L MIX(w0, w1)
      mut as int64: newW0 = (w0 + w1) /r 4294967296
      mut as int64: rol1 = ((w1 << r0) & 4294967295) | (w1 >> (32 - r0))
      mut as int64: newW1 = (rol1 ^ newW0) & 4294967295

      #L MIX(w2, w3)
      mut as int64: newW2 = (w2 + w3) /r 4294967296
      mut as int64: rol3 = ((w3 << r1) & 4294967295) | (w3 >> (32 - r1))
      mut as int64: newW3 = (rol3 ^ newW2) & 4294967295

      #L Permutacao de palavras pi = (0, 3, 2, 1)
      w0 = newW0
      w1 = newW3
      w2 = newW2
      w3 = newW1

      #L A cada 4 rodadas, injeta subchave intermediaria
      route {
            rIdx == 4 ==> {
                  mut as int64: sk1_0 = extKey[2]
                  mut as int64: sk1_1 = (extKey[3] + extTweak[2]) /r 4294967296
                  mut as int64: sk1_2 = (extKey[4] + extTweak[3]) /r 4294967296
                  mut as int64: sk1_3 = (extKey[5] + 1) /r 4294967296

                  w0 = (w0 + sk1_0) /r 4294967296
                  w1 = (w1 + sk1_1) /r 4294967296
                  w2 = (w2 + sk1_2) /r 4294967296
                  w3 = (w3 + sk1_3) /r 4294967296
            }
            _ ==> {}
      }

      rIdx = rIdx + 1
}

#L Subchave final ao final da rodada 8
mut as int64: sk2_0 = extKey[3]
mut as int64: sk2_1 = (extKey[4] + extTweak[3]) /r 4294967296
mut as int64: sk2_2 = (extKey[5] + extTweak[1]) /r 4294967296
mut as int64: sk2_3 = (extKey[1] + 2) /r 4294967296

w0 = (w0 + sk2_0) /r 4294967296
w1 = (w1 + sk2_1) /r 4294967296
w2 = (w2 + sk2_2) /r 4294967296
w3 = (w3 + sk2_3) /r 4294967296

mut as list of int64: cipher = [w0, w1, w2, w3]
println("==================================================")
println("2. Bloco Cifrado C:")
println("   C: " + cipher)

#L ==================================================
#L Decriptacao Threefish (Inversao exata das operacoes)
#L ==================================================
mut as int64: dw0 = cipher[1]
mut as int64: dw1 = cipher[2]
mut as int64: dw2 = cipher[3]
mut as int64: dw3 = cipher[4]

#L Subtrai subchave final sk2
mut as int64: sub0 = dw0 - sk2_0
infinite (sub0 < 0) { sub0 = sub0 + 4294967296 }
dw0 = sub0 /r 4294967296

mut as int64: sub1 = dw1 - sk2_1
infinite (sub1 < 0) { sub1 = sub1 + 4294967296 }
dw1 = sub1 /r 4294967296

mut as int64: sub2 = dw2 - sk2_2
infinite (sub2 < 0) { sub2 = sub2 + 4294967296 }
dw2 = sub2 /r 4294967296

mut as int64: sub3 = dw3 - sk2_3
infinite (sub3 < 0) { sub3 = sub3 + 4294967296 }
dw3 = sub3 /r 4294967296

#L Inversao das 8 rodadas em ordem reversa
mut as int64: drIdx = 8
infinite (drIdx >= 1) {
      #L Inverte subchave intermediaria da rodada 4
      route {
            drIdx == 4 ==> {
                  mut as int64: isk1_0 = extKey[2]
                  mut as int64: isk1_1 = (extKey[3] + extTweak[2]) /r 4294967296
                  mut as int64: isk1_2 = (extKey[4] + extTweak[3]) /r 4294967296
                  mut as int64: isk1_3 = (extKey[5] + 1) /r 4294967296

                  mut as int64: isub0 = dw0 - isk1_0
                  infinite (isub0 < 0) { isub0 = isub0 + 4294967296 }
                  dw0 = isub0 /r 4294967296

                  mut as int64: isub1 = dw1 - isk1_1
                  infinite (isub1 < 0) { isub1 = isub1 + 4294967296 }
                  dw1 = isub1 /r 4294967296

                  mut as int64: isub2 = dw2 - isk1_2
                  infinite (isub2 < 0) { isub2 = isub2 + 4294967296 }
                  dw2 = isub2 /r 4294967296

                  mut as int64: isub3 = dw3 - isk1_3
                  infinite (isub3 < 0) { isub3 = isub3 + 4294967296 }
                  dw3 = isub3 /r 4294967296
            }
            _ ==> {}
      }

      #L Inverte permutacao pi: (dw0, dw3, dw2, dw1)
      mut as int64: pW0 = dw0
      mut as int64: pW1 = dw3
      mut as int64: pW2 = dw2
      mut as int64: pW3 = dw1

      mut as int64: dr0 = rot0[drIdx]
      mut as int64: dr1 = rot1[drIdx]

      #L InvMIX(pW2, pW3)
      mut as int64: xor3 = (pW3 ^ pW2) & 4294967295
      mut as int64: ror3 = (xor3 >> dr1) | ((xor3 << (32 - dr1)) & 4294967295)
      mut as int64: diffW2 = pW2 - ror3
      infinite (diffW2 < 0) { diffW2 = diffW2 + 4294967296 }
      mut as int64: origW2 = diffW2 /r 4294967296
      mut as int64: origW3 = ror3

      #L InvMIX(pW0, pW1)
      mut as int64: xor1 = (pW1 ^ pW0) & 4294967295
      mut as int64: ror1 = (xor1 >> dr0) | ((xor1 << (32 - dr0)) & 4294967295)
      mut as int64: diffW0 = pW0 - ror1
      infinite (diffW0 < 0) { diffW0 = diffW0 + 4294967296 }
      mut as int64: origW0 = diffW0 /r 4294967296
      mut as int64: origW1 = ror1

      dw0 = origW0
      dw1 = origW1
      dw2 = origW2
      dw3 = origW3

      drIdx = drIdx - 1
}

#L Subtrai subchave inicial sk0
mut as int64: fsub0 = dw0 - sk0_0
infinite (fsub0 < 0) { fsub0 = fsub0 + 4294967296 }
dw0 = fsub0 /r 4294967296

mut as int64: fsub1 = dw1 - sk0_1
infinite (fsub1 < 0) { fsub1 = fsub1 + 4294967296 }
dw1 = fsub1 /r 4294967296

mut as int64: fsub2 = dw2 - sk0_2
infinite (fsub2 < 0) { fsub2 = fsub2 + 4294967296 }
dw2 = fsub2 /r 4294967296

mut as int64: fsub3 = dw3 - sk0_3
infinite (fsub3 < 0) { fsub3 = fsub3 + 4294967296 }
dw3 = fsub3 /r 4294967296

mut as list of int64: plainRecov = [dw0, dw1, dw2, dw3]
println("==================================================")
println("3. Bloco Decriptado P':")
println("   P': " + plainRecov)

route {
      plainRecov[1] == P[1] and plainRecov[2] == P[2] and plainRecov[3] == P[3] and plainRecov[4] == P[4] ==> {
            println("   SUCESSO: Threefish encriptou e restaurou o texto claro perfeitamente!")
      }
      _ ==> {
            println("   FALHA: Divergencia na decriptacao de Threefish!")
      }
}
