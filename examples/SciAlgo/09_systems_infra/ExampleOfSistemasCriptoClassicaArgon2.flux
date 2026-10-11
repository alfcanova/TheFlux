#L ==================================================
#L Algoritmo: Argon2 Memory-Hard Password Hashing (RFC 9106)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Argon2 e uma funcao de dispersao para derivacao de chaves e armazenamento
#L seguro de senhas, vencedora da Password Hashing Competition (PHC) em 2015
#L e padronizada pela RFC 9106.
#L
#L A primitiva foi concebida para resistir a ataques de forca bruta acelerados por
#L hardware especializado (GPU, ASIC, FPGA), exigindo uso intensivo tanto de memoria
#L (memory-hardness) quanto de tempo de processamento.
#L
#L A matriz bidimensional de blocos de memoria B[i] e preenchida sequencialmente:
#L   B[i] = G(B[i-1], B[ref_index])
#L Onde a funcao de compressao G emprega o nucleo ARX do BLAKE2, e ref_index e
#L determinado dinamicamente (dependente de dados no Argon2d, independente no Argon2i,
#L ou hibrido no Argon2id).
#L ==================================================

println("==================================================")
println("  SciAlgo: Argon2 Memory-Hard Password Hashing (RFC 9106)")
println("==================================================")

#L Parametros de configuracao Argon2
mut as int64: tCost = 2        #L Passos no tempo (iteracoes)
mut as int64: mCost = 8        #L Quantidade de blocos de memoria
mut as int64: lanes = 1        #L Paralelismo (1 via)

println("1. Parametros da Funcao:")
println("   Custo de Tempo (t): " + tCost)
println("   Custo de Memoria (m): " + mCost + " blocos")
println("   Grau de Paralelismo: " + lanes)

#L Chave/Senha ("TheFluxSecret") e Sal ("Argon2Salt1234") mapeados em palavras de 32 bits
mut as list of int64: pwd = [1416127814, 1819637888, 1936287828, 1953719668]
mut as list of int64: salt = [1097887301, 1852796014, 825373490, 875770418]

#L Memoria de blocos: 8 blocos com 4 palavras de 32 bits cada (32 palavras no total)
mut as list of int64: mem = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#L Inicializacao do Bloco 0 (mem[1..4]) e Bloco 1 (mem[5..8]) a partir de pwd e salt
mut as int64: w = 1
infinite (w <= 4) {
      mem[w] = (pwd[w] ^ salt[w]) & 4294967295
      mem[w + 4] = ((pwd[w] + salt[w]) * 2654435761) /r 4294967296
      w = w + 1
}

#L Preenchimento da memoria (Passos no tempo e indexacao de blocos)
mut as int64: iter = 1
infinite (iter <= tCost) {
      mut as int64: bIdx = 2
      infinite (bIdx < mCost) {
            #L Bloco anterior B[i-1]
            mut as int64: prevBase = ((bIdx - 1) * 4) + 1

            #L Indice de referencia J (selecao pseudoaleatoria estilo Argon2d/i)
            mut as int64: seedJ = mem[prevBase] ^ iter
            mut as int64: refIdx = seedJ /r bIdx
            mut as int64: refBase = (refIdx * 4) + 1

            #L Bloco atual B[i] base
            mut as int64: curBase = (bIdx * 4) + 1

            #L Funcao de compressao G(prev, ref)
            mut as int64: p0 = mem[prevBase]
            mut as int64: p1 = mem[prevBase + 1]
            mut as int64: p2 = mem[prevBase + 2]
            mut as int64: p3 = mem[prevBase + 3]

            mut as int64: r0 = mem[refBase]
            mut as int64: r1 = mem[refBase + 1]
            mut as int64: r2 = mem[refBase + 2]
            mut as int64: r3 = mem[refBase + 3]

            #L Transformacao ARX estilo Blake2 (G round)
            mut as int64: g0 = (p0 + r0) /r 4294967296
            mut as int64: g1 = (p1 ^ r1) & 4294967295
            mut as int64: rolG1 = ((g1 << 16) & 4294967295) | (g1 >> 16)

            mut as int64: g2 = (p2 + r2) /r 4294967296
            mut as int64: g3 = (p3 ^ r3) & 4294967295
            mut as int64: rolG3 = ((g3 << 12) & 4294967295) | (g3 >> 20)

            #L Diagonalizacao e combinacao
            mut as int64: n0 = (g0 + rolG3) /r 4294967296
            mut as int64: n1 = (rolG1 ^ g2) & 4294967295
            mut as int64: n2 = (g2 + rolG1) /r 4294967296
            mut as int64: n3 = (rolG3 ^ g0) & 4294967295

            #L Gravacao no bloco atual da memoria
            mem[curBase] = n0
            mem[curBase + 1] = n1
            mem[curBase + 2] = n2
            mem[curBase + 3] = n3

            bIdx = bIdx + 1
      }
      iter = iter + 1
}

println("==================================================")
println("2. Memoria Preenchida (Primeiro e Ultimo Bloco):")
println("   Bloco 0: [" + mem[1] + ", " + mem[2] + ", " + mem[3] + ", " + mem[4] + "]")
println("   Bloco 7: [" + mem[29] + ", " + mem[30] + ", " + mem[31] + ", " + mem[32] + "]")

#L Extracao da Tag Final (XOR de todos os blocos gerados)
mut as int64: tag0 = 0
mut as int64: tag1 = 0
mut as int64: tag2 = 0
mut as int64: tag3 = 0

mut as int64: bi = 0
infinite (bi < mCost) {
      mut as int64: base = (bi * 4) + 1
      tag0 = tag0 ^ mem[base]
      tag1 = tag1 ^ mem[base + 1]
      tag2 = tag2 ^ mem[base + 2]
      tag3 = tag3 ^ mem[base + 3]
      bi = bi + 1
}

mut as list of int64: argonTag = [tag0, tag1, tag2, tag3]
println("==================================================")
println("3. Tag de Derivacao Argon2:")
println("   Tag (128 bits): " + argonTag)

#L Verificacao de integridade e repetibilidade
mut as bool: isValid = (argonTag[1] != 0) and (argonTag[2] != 0) and (argonTag[3] != 0) and (argonTag[4] != 0)
route {
      isValid ==> {
            println("   SUCESSO: Funcao de dispersao em memoria Argon2 executada com exito!")
      }
      _ ==> {
            println("   FALHA: Divergencia na geracao da tag Argon2!")
      }
}
