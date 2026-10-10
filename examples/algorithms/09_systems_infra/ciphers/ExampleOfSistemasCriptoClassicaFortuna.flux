#L ==================================================
#L Algoritmo: Fortuna Cryptographic PRNG (Ferguson-Schneier)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Fortuna e um gerador de numeros pseudoaleatorios criptograficos (CSPRNG)
#L desenvolvido por Niels Ferguson e Bruce Schneier (2003) para superar as
#L vulnerabilidades inerentes a estimadores de entropia presentes no Yarrow.
#L
#L A arquitetura consiste em tres subsistemas:
#L   1. Acumulador de Entropia: gerencia 32 reservatorios (pools P_0..P_31).
#L      Fontes de entropia distribuem eventos ciclicamente entre os reservatorios.
#L      O reservatorio P_i so e drenado no reseed r se 2^i dividir r (r mod 2^i == 0),
#L      garantindo recuperacao progressiva mesmo sob controle hostil de fontes.
#L   2. Gerador: opera uma cifra de bloco em modo contador (CTR) emitindo blocos aleatorios.
#L   3. Sigilo Futuro (Forward Secrecy / Key Erasure): a cada bloco de saida gerado,
#L      a chave e imediatamente regerada e a chave anterior destruida da memoria.
#L ==================================================

println("==================================================")
println("  SciAlgo: Fortuna CSPRNG (Ferguson-Schneier 2003)")
println("==================================================")

#L Estado do Gerador: Chave K e Contador C
mut as int64: K = 305419896        #L 0x12345678
mut as int64: C = 0

println("1. Parametros Iniciais:")
println("   Chave K inicial: " + K)
println("   Contador C inicial: " + C)

#L 8 Reservatorios de Entropia (pools P_0 .. P_7)
mut as list of int64: pools = [0, 0, 0, 0, 0, 0, 0, 0]

#L Distribuicao ciclica (round-robin) de eventos de entropia
mut as list of int64: events = [11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132]
mut as int64: ei = 1
infinite (ei <= 12) {
      mut as int64: poolIdx = ((ei - 1) /r 8) + 1
      pools[poolIdx] = pools[poolIdx] + events[ei]
      ei = ei + 1
}

println("   Entropia acumulada nos 8 reservatorios: " + pools)

println("==================================================")
println("2. Ciclo de Reseeds do Fortuna (Regra 2^i | r):")

#L Executa 4 ciclos de reseed
mut as int64: r = 1
infinite (r <= 4) {
      mut as int64: entropyAcc = 0

      #L Verifica cada pool i (0..7) com divisor 2^i
      mut as int64: pIdx = 0
      mut as int64: p2 = 1
      infinite (pIdx < 8) {
            route {
                  (r /r p2) == 0 ==> {
                        entropyAcc = (entropyAcc + pools[pIdx + 1]) /r 4294967296
                        pools[pIdx + 1] = 0
                  }
                  _ ==> {}
            }
            p2 = p2 * 2
            pIdx = pIdx + 1
      }

      #L Atualizacao da chave K via PRF
      mut as int64: x = (K ^ entropyAcc) & 4294967295
      mut as int64: rol = ((x << 11) & 4294967295) | (x >> 21)
      K = (rol ^ (entropyAcc * 7919)) & 4294967295
      println("   [Reseed #" + r + "] Chave K atualizada: " + K)

      r = r + 1
}

println("==================================================")
println("3. Emissao de Keystream em Modo Contador (CTR):")
mut as list of int64: genBlocks = [0, 0, 0, 0]

mut as int64: bi = 1
infinite (bi <= 4) {
      C = C + 1
      mut as int64: xC = (K ^ C) & 4294967295
      mut as int64: rolC = ((xC << 11) & 4294967295) | (xC >> 21)
      mut as int64: blk = (rolC ^ (C * 7919)) & 4294967295
      genBlocks[bi] = blk
      bi = bi + 1
}

println("   Blocos gerados: " + genBlocks)

#L Key Erasure (Sigilo Futuro): sobrescreve K com novo bloco
C = C + 1
mut as int64: xFinal = (K ^ C) & 4294967295
mut as int64: rolFinal = ((xFinal << 11) & 4294967295) | (xFinal >> 21)
K = (rolFinal ^ (C * 7919)) & 4294967295

println("==================================================")
println("4. Forward Secrecy (Chave K Renovada e Apagada): " + K)

#L Validacao do vetor esperado:
#L Blocos: [1844165308, 1844150669, 1844177054, 1844180975], K = 1844125432
mut as bool: isMatch = (genBlocks[1] == 1844165308) and (genBlocks[2] == 1844150669) and (genBlocks[3] == 1844177054) and (genBlocks[4] == 1844180975) and (K == 1844125432)

route {
      isMatch ==> {
            println("   SUCESSO: CSPRNG Fortuna validado com multipooling e forward secrecy!")
      }
      _ ==> {
            println("   FALHA: Divergencia na execucao do gerador Fortuna!")
      }
}
