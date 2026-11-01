#L ==================================================
#L Algoritmo: Yarrow Cryptographic Pseudorandom Generator
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O algoritmo Yarrow e uma arquitetura de gerador de numeros pseudoaleatorios
#L criptograficos (CSPRNG) projetada por John Kelsey, Bruce Schneier e Niels Ferguson
#L em 1999, amplamente empregada em sistemas operacionais (como macOS/iOS e FreeBSD).
#L
#L Elementos fundamentais:
#L   1. Acumulador de Entropia: gerencia dois reservatorios independentes:
#L      - Fast Pool (reservatorio rapido): aciona reseeds frequentes do gerador.
#L      - Slow Pool (reservatorio lento): acumula entropia profunda de multiplas fontes.
#L   2. Mecanismo de Reseed: re-encripta e atualiza a chave de estado K com dispersao criptografica.
#L   3. Gerador CTR: cifra de bloco em modo contador emitindo blocos pseudoaleatorios.
#L   4. Resistencia a Retrocesso (Backtrack Resistance): atualizacao imediata da chave K
#L      apos cada requisicao, impedindo que um invasor comprometa chaves passadas.
#L ==================================================

println("==================================================")
println("  SciAlgo: Yarrow Entropy PRNG (Kelsey-Schneier-Ferguson)")
println("==================================================")

#L Chave inicial K e contadores de reservatorio
mut as int64: K = 305419896        #L 0x12345678
mut as int64: fastPool = 0
mut as int64: fastThreshold = 100
mut as int64: reseedCount = 0

println("1. Parametros e Reservatorios de Entropia:")
println("   Chave K inicial: " + K)
println("   Limiar do Fast Pool: " + fastThreshold)

#L Coleta e Injecao de Entropia de fontes externas
mut as list of int64: samples = [35, 45, 55, 65, 80]
mut as int64: si = 1
infinite (si <= 5) {
      mut as int64: sample = samples[si]
      fastPool = fastPool + sample

      route {
            fastPool >= fastThreshold ==> {
                  #L Reseed do Fast Pool: K = PRF(K, fastPool) ^ 0x5a827999
                  mut as int64: x = (K ^ fastPool) & 4294967295
                  mut as int64: rol = ((x << 13) & 4294967295) | (x >> 19)
                  mut as int64: prf = (rol ^ (fastPool * 10007)) & 4294967295
                  K = (prf ^ 1518500249) & 4294967295
                  fastPool = 0
                  reseedCount = reseedCount + 1
                  println("   [Reseed #" + reseedCount + "] Chave K atualizada com Fast Pool: " + K)
            }
            _ ==> {}
      }

      si = si + 1
}

println("==================================================")
println("2. Emissao de Keystream em Modo Contador (CTR):")
mut as list of int64: outBlocks = [0, 0, 0, 0]
mut as int64: C = 0

mut as int64: bi = 1
infinite (bi <= 4) {
      C = C + 1
      mut as int64: xB = (K ^ C) & 4294967295
      mut as int64: rolB = ((xB << 13) & 4294967295) | (xB >> 19)
      mut as int64: blk = (rolB ^ (C * 10007)) & 4294967295
      outBlocks[bi] = blk
      bi = bi + 1
}

println("   Blocos emitidos: " + outBlocks)

#L Resistencia a Retrocesso: atualiza K com o proximo bloco
C = C + 1
mut as int64: xK = (K ^ C) & 4294967295
mut as int64: rolK = ((xK << 13) & 4294967295) | (xK >> 19)
mut as int64: nextKey = (rolK ^ (C * 10007)) & 4294967295
K = nextKey

println("==================================================")
println("3. Backtrack Resistance (Nova Chave K): " + K)

#L Validacao do vetor calculado: [888334428, 888332645, 888338958, 888337175]
mut as bool: isMatch = (outBlocks[1] == 888334428) and (outBlocks[2] == 888332645) and (outBlocks[3] == 888338958) and (outBlocks[4] == 888337175) and (K == 888310840)

route {
      isMatch ==> {
            println("   SUCESSO: CSPRNG Yarrow validado com acumulacao e resistencia a retrocesso!")
      }
      _ ==> {
            println("   FALHA: Divergencia na execucao do gerador Yarrow!")
      }
}
