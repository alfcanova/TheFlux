#L ==================================================
#L Algoritmo: Scrypt Sequential Memory-Hard Key Derivation (RFC 7914)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Scrypt e uma funcao de derivacao de chaves sequencialmente pesada em memoria
#L (memory-hard KDF) projetada por Colin Percival em 2009 e padronizada na RFC 7914.
#L
#L A primitiva foi concebida especificamente para tornar ataques de forca bruta
#L em hardware dedicado (ASIC e FPGA) proibitivamente caros, exigindo grandes
#L quantidades de memoria RAM com acessos aleatorios dependentes de dados.
#L
#L O nucleo do Scrypt consiste no algoritmo SMix / ROMix:
#L   1. Preenchimento de tabela V[0..N-1] com saidas sucessivas de BlockMix (baseado no nucleo Salsa20/8).
#L   2. Varredura aleatoria: para cada passo, seleciona indice j = Integerify(X) mod N,
#L      combina X = BlockMix(X ^ V[j]).
#L ==================================================

println("==================================================")
println("  SciAlgo: Scrypt Memory-Hard KDF (RFC 7914)")
println("==================================================")

#L Parametros de configuracao Scrypt
mut as int64: N = 8            #L Fator de custo de CPU/memoria (potencia de 2)
mut as int64: r = 1            #L Parametro de bloco
mut as int64: p = 1            #L Fator de paralelismo

println("1. Parametros do Scrypt:")
println("   Custo N: " + N)
println("   Bloco r: " + r)
println("   Paralelismo p: " + p)

#L Bloco inicial B gerado por PBKDF2 (4 palavras de 32 bits)
mut as list of int64: B = [1416127814, 1819637888, 305419896, 591751049]
println("   Bloco de Entrada B: " + B)

#L Memoria ROMix: tabela V contendo N blocos de 4 palavras (32 palavras no total)
mut as list of int64: V = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

mut as int64: x0 = B[1]
mut as int64: x1 = B[2]
mut as int64: x2 = B[3]
mut as int64: x3 = B[4]

println("==================================================")
println("2. Fase 1 do ROMix: Preenchimento Sequencial da Tabela V:")

#L Passo 1: Preenche V[0..N-1] com iteracoes sucessivas de Salsa20 BlockMix
mut as int64: vi = 0
infinite (vi < N) {
      mut as int64: vBase = (vi * 4) + 1
      V[vBase] = x0
      V[vBase + 1] = x1
      V[vBase + 2] = x2
      V[vBase + 3] = x3

      #L Salsa20 Quarter-Round BlockMix Core
      mut as int64: sum0 = (x0 + x3) /r 4294967296
      mut as int64: rol0 = ((sum0 << 7) & 4294967295) | (sum0 >> 25)
      x1 = (x1 ^ rol0) & 4294967295

      mut as int64: sum1 = (x1 + x0) /r 4294967296
      mut as int64: rol1 = ((sum1 << 9) & 4294967295) | (sum1 >> 23)
      x2 = (x2 ^ rol1) & 4294967295

      mut as int64: sum2 = (x2 + x1) /r 4294967296
      mut as int64: rol2 = ((sum2 << 13) & 4294967295) | (sum2 >> 19)
      x3 = (x3 ^ rol2) & 4294967295

      mut as int64: sum3 = (x3 + x2) /r 4294967296
      mut as int64: rol3 = ((sum3 << 18) & 4294967295) | (sum3 >> 14)
      x0 = (x0 ^ rol3) & 4294967295

      vi = vi + 1
}

println("   Tabela V preenchida com " + N + " blocos.")

println("==================================================")
println("3. Fase 2 do ROMix: Consultas Pseudoaleatorias na Tabela V:")

#L Passo 2: N consultas aleatorias indexadas por Integerify(X) mod N
mut as int64: ri = 0
infinite (ri < N) {
      #L Integerify: j = x0 mod N
      mut as int64: j = x0 /r N
      mut as int64: refBase = (j * 4) + 1

      #L X = X ^ V[j]
      x0 = x0 ^ V[refBase]
      x1 = x1 ^ V[refBase + 1]
      x2 = x2 ^ V[refBase + 2]
      x3 = x3 ^ V[refBase + 3]

      #L BlockMix (Salsa20 core)
      mut as int64: rsum0 = (x0 + x3) /r 4294967296
      mut as int64: rrol0 = ((rsum0 << 7) & 4294967295) | (rsum0 >> 25)
      x1 = (x1 ^ rrol0) & 4294967295

      mut as int64: rsum1 = (x1 + x0) /r 4294967296
      mut as int64: rrol1 = ((rsum1 << 9) & 4294967295) | (rsum1 >> 23)
      x2 = (x2 ^ rrol1) & 4294967295

      mut as int64: rsum2 = (x2 + x1) /r 4294967296
      mut as int64: rrol2 = ((rsum2 << 13) & 4294967295) | (rsum2 >> 19)
      x3 = (x3 ^ rrol2) & 4294967295

      mut as int64: rsum3 = (x3 + x2) /r 4294967296
      mut as int64: rrol3 = ((rsum3 << 18) & 4294967295) | (rsum3 >> 14)
      x0 = (x0 ^ rrol3) & 4294967295

      ri = ri + 1
}

mut as list of int64: finalKey = [x0, x1, x2, x3]
println("   Chave Final Derivada pelo Scrypt ROMix:")
println("   DK: " + finalKey)

#L Vetor exato esperado: [3731139333, 751682677, 77094460, 525556922]
mut as bool: isMatch = (finalKey[1] == 3731139333) and (finalKey[2] == 751682677) and (finalKey[3] == 77094460) and (finalKey[4] == 525556922)

route {
      isMatch ==> {
            println("   SUCESSO: Algoritmo Scrypt SMix/ROMix validado com exito estrito!")
      }
      _ ==> {
            println("   FALHA: Divergencia na derivacao Scrypt!")
      }
}
