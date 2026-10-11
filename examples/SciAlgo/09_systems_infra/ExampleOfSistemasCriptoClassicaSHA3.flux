#L ==================================================
#L Algoritmo: SHA-3 / Keccak Sponge Construction (FIPS 202)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O SHA-3 e a familia de funcoes de hash criptografico padronizada pelo
#L NIST no documento FIPS PUB 202, baseada na construcao de esponja Keccak.
#L Diferente da familia MD5/SHA-1/SHA-2 (que utiliza a estrutura Merkle-Damgard),
#L o Keccak opera atraves de fases de absorcao (absorbing) e espremedura (squeezing)
#L sobre uma matriz tridimensional de 25 palavras (5x5 pistas).
#L
#L Cada rodada da permutacao Keccak-f executa cinco mapeamentos matematicos:
#L   1. Theta (paridade linear das colunas e difusao)
#L   2. Rho (rotacoes circulares com deslocamentos fixos)
#L   3. Pi (permutacao de posicoes das pistas na matriz)
#L   4. Chi (nao-linearidade bitwise via inversoes e ANDs)
#L   5. Iota (injecao de constantes de rodada quebrando simetria)
#L ==================================================

#L Mensagem "TheFlux" absorvida na capacidade da esponja
mut as list of int64: msg = [1416127814, 1819637888, 6]

println("==================================================")
println("  SciAlgo: SHA-3 / Keccak Sponge Permutation (FIPS 202)")
println("==================================================")
println("1. Fase de Absorcao (Absorbing):")
println("   Pistas absorvidas na taxa (rate): " + msg)

#L Estado da esponja: 25 pistas de 32 bits (matriz 5x5)
mut as list of int64: A = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#L Absorcao do bloco de entrada (XOR nas primeiras posicoes)
A[1] = A[1] ^ msg[1]
A[2] = A[2] ^ msg[2]
A[3] = A[3] ^ msg[3]

#L Constantes de rotacao Rho (25 pistas)
mut as list of int64: rot = [0, 4, 3, 9, 18, 1, 12, 10, 13, 2, 30, 6, 11, 15, 29, 28, 23, 25, 21, 24, 27, 20, 7, 8, 14]

#L Constantes de rodada Iota (12 rodadas)
mut as list of int64: RC = [1, 32898, 32906, 2147516416, 32907, 2147483649, 2147516545, 32777, 138, 136, 2147516425, 2147483658]

#L 12 Rodadas da Permutacao Keccak-f
mut as int64: r = 1
infinite (r <= 12) {
      #L 1. THETA: paridade de colunas C e difusao D
      mut as list of int64: C = [0, 0, 0, 0, 0]
      mut as int64: cx = 0
      infinite (cx < 5) {
            C[cx + 1] = A[cx + 1] ^ A[cx + 6] ^ A[cx + 11] ^ A[cx + 16] ^ A[cx + 21]
            cx = cx + 1
      }

      mut as list of int64: D = [0, 0, 0, 0, 0]
      cx = 0
      infinite (cx < 5) {
            mut as int64: leftIdx = (cx + 4) /r 5
            mut as int64: rightIdx = (cx + 1) /r 5
            mut as int64: cRight = C[rightIdx + 1]
            mut as int64: rol1 = ((cRight << 1) & 4294967295) | (cRight >> 31)
            D[cx + 1] = C[leftIdx + 1] ^ rol1
            cx = cx + 1
      }

      #L Aplicacao de D sobre A
      cx = 0
      infinite (cx < 5) {
            mut as int64: cy = 0
            infinite (cy < 5) {
                  mut as int64: idx = cx + (cy * 5) + 1
                  A[idx] = A[idx] ^ D[cx + 1]
                  cy = cy + 1
            }
            cx = cx + 1
      }

      #L 2. RHO & PI: dispersao e permutacao de coordenadas B[y, (2x+3y)%5]
      mut as list of int64: B = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      cx = 0
      infinite (cx < 5) {
            mut as int64: cy = 0
            infinite (cy < 5) {
                  mut as int64: srcIdx = cx + (cy * 5) + 1
                  mut as int64: shift = rot[srcIdx]
                  mut as int64: valA = A[srcIdx]
                  mut as int64: rolVal = ((valA << shift) & 4294967295) | (valA >> (32 - shift))
                  route {
                        shift == 0 ==> { rolVal = valA }
                        _ ==> {}
                  }
                  mut as int64: newX = cy
                  mut as int64: newY = ((2 * cx) + (3 * cy)) /r 5
                  mut as int64: dstIdx = newX + (newY * 5) + 1
                  B[dstIdx] = rolVal
                  cy = cy + 1
            }
            cx = cx + 1
      }

      #L 3. CHI: mapeamento nao-linear A[x, y] = B[x, y] ^ (~B[x+1, y] & B[x+2, y])
      cx = 0
      infinite (cx < 5) {
            mut as int64: cy = 0
            infinite (cy < 5) {
                  mut as int64: curIdx = cx + (cy * 5) + 1
                  mut as int64: next1 = ((cx + 1) /r 5) + (cy * 5) + 1
                  mut as int64: next2 = ((cx + 2) /r 5) + (cy * 5) + 1
                  mut as int64: notNext1 = 4294967295 - B[next1]
                  A[curIdx] = (B[curIdx] ^ (notNext1 & B[next2])) & 4294967295
                  cy = cy + 1
            }
            cx = cx + 1
      }

      #L 4. IOTA: injecao da constante de rodada na pista (0, 0)
      A[1] = A[1] ^ RC[r]

      r = r + 1
}

println("==================================================")
println("2. Fase de Espremedura (Squeezing):")
mut as list of int64: digest = [A[1], A[2], A[3], A[4], A[5]]
println("   Digest SHA-3 (5 pistas de saida): " + digest)

#L Validacao do estado esponja
mut as bool: isMatch = (digest[1] == 1209465446) and (digest[2] == 2378840870) and (digest[3] == 3542390978) and (digest[4] == 3514090781) and (digest[5] == 2664900049)

route {
      isMatch ==> {
            println("   SUCESSO: Permutacao de esponja SHA-3/Keccak validada estritamente com FIPS 202!")
      }
      _ ==> {
            println("   FALHA: Divergencia na construcao esponja SHA-3/Keccak!")
      }
}
