#L ==================================================
#L Algoritmo: Poly1305 One-Time Authenticator (RFC 8439)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Poly1305 e um autenticador de mensagens de uso unico (one-time MAC)
#L de alta performance projetado por Daniel J. Bernstein (DJB) e
#L padronizado na RFC 8439.
#L
#L A primitiva calcula uma tag polinomial sobre o corpo primo GF(2^130 - 5):
#L   Tag = ((m_1 * r^k + m_2 * r^{k-1} + ... + m_k * r) mod (2^130 - 5) + s) mod 2^128
#L
#L Propriedades fundamentais:
#L - Clamping de r: bits especificos sao zerados para prevenir ataques e garantir avaliacao estavel.
#L - Metodo de Horner: avaliacao acumulada a = ((a + c_i) * r) mod p bloco a bloco.
#L - Mascara secreta s: adicao final impedindo que o receptor reconstrua a chave r.
#L ==================================================

println("==================================================")
println("  SciAlgo: Poly1305 One-Time Polynomial MAC (RFC 8439)")
println("==================================================")

#L Chave de 32 bytes: r (chave de avaliacao) e s (mascara secreta)
#L Chave r bruta
mut as int64: rawR = 268435455

#L Clamping de r (bits 28..31, etc.)
mut as int64: clampR = rawR & 251658240
route {
      clampR == 0 ==> {
            clampR = 268435451
      }
      _ ==> {}
}

#L Mascara secreta s
mut as int64: keyS = 49153

#L Primo de Mersenne do corpo: p = 2^31 - 1 = 2147483647
mut as int64: primeP = 2147483647

println("1. Parametros e Chaves Criptograficas:")
println("   Chave r (clampada): " + clampR)
println("   Chave s (mascara):  " + keyS)
println("   Corpo Primo p:      " + primeP)

#L Mensagem particionada em blocos de entrada
mut as list of int64: msgBlocks = [1001, 2002, 3003, 4004]
mut as int64: numBlocks = 4
println("   Mensagem (4 blocos): " + msgBlocks)

println("==================================================")
println("2. Avaliacao Polinomial via Regra de Horner:")
mut as int64: acc = 0
mut as int64: i = 1
infinite (i <= numBlocks) {
      mut as int64: block = msgBlocks[i]
      #L Insercao do bit sentinela 0x01 no fim de cada bloco (padding RFC 8439)
      mut as int64: ci = (block + 65536) /r primeP
      acc = (acc + ci) /r primeP
      acc = (acc * (clampR /r 10007)) /r primeP
      println("   Bloco " + i + " processado: acumulador = " + acc)
      i = i + 1
}

#L Geracao da Tag de Autenticacao: tag = (acc + s) mod p
mut as int64: authTag = (acc + keyS) /r primeP
println("==================================================")
println("3. Tag Poly1305 Gerada:")
println("   AuthTag: " + authTag)

#L Verificacao no Receptor
println("==================================================")
println("4. Verificacao de Autenticidade no Receptor:")
mut as int64: rxAcc = 0
mut as int64: ri = 1
infinite (ri <= numBlocks) {
      mut as int64: rxBlock = msgBlocks[ri]
      mut as int64: rxCi = (rxBlock + 65536) /r primeP
      rxAcc = (rxAcc + rxCi) /r primeP
      rxAcc = (rxAcc * (clampR /r 10007)) /r primeP
      ri = ri + 1
}

mut as int64: rxTag = (rxAcc + keyS) /r primeP
println("   Tag recalculada pelo receptor: " + rxTag)

mut as bool: isValid = (rxTag == authTag)
route {
      isValid ==> {
            println("   SUCESSO: Tag Poly1305 autenticada e verificada com exito!")
      }
      _ ==> {
            println("   FALHA: Divergencia na autenticacao Poly1305!")
      }
}
