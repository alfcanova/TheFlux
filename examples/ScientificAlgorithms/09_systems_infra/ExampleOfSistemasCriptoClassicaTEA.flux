#L ==================================================
#L Algoritmo: Tiny Encryption Algorithm (TEA)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O TEA (Tiny Encryption Algorithm) foi desenvolvido por David Wheeler
#L e Roger Needham em Cambridge em 1994. Trata-se de uma cifra de bloco
#L baseada em rede de Feistel com operacoes elementares em palavras de 32 bits.
#L
#L Caracteristicas tecnicas:
#L - Tamanho do bloco: 64 bits (duas palavras v0, v1 de 32 bits).
#L - Tamanho da chave: 128 bits (quatro palavras k0, k1, k2, k3 de 32 bits).
#L - Constante de dispersao: delta = 0x9E3779B9 = 2654435769 (razao aurea 2^32 / phi).
#L - Estrutura: 32 ciclos (64 rodadas de Feistel) com alternancia de shifts e XORs.
#L ==================================================

mut as int64: origV0 = 305419896
mut as int64: origV1 = 591751049
mut as list of int64: key = [272716322, 1347440720, 2422165118, 3496889516]

println("==================================================")
println("  SciAlgo: Tiny Encryption Algorithm (TEA)")
println("==================================================")
println("1. Bloco de Entrada (64 bits em v0, v1):")
println("   v0: " + origV0 + " (0x12345678)")
println("   v1: " + origV1 + " (0x23456789)")
println("   Chave (128 bits): " + key)

mut as int64: k0 = key[1]
mut as int64: k1 = key[2]
mut as int64: k2 = key[3]
mut as int64: k3 = key[4]
mut as int64: delta = 2654435769

#L Encriptacao TEA (32 ciclos = 64 rodadas)
mut as int64: encV0 = origV0
mut as int64: encV1 = origV1
mut as int64: sum = 0

mut as int64: cycle = 1
infinite (cycle <= 32) {
      sum = (sum + delta) /r 4294967296

      mut as int64: t0_shift = ((encV1 << 4) & 4294967295) + k0
      mut as int64: t0_sum = encV1 + sum
      mut as int64: t0_rshift = (encV1 >> 5) + k1
      mut as int64: f0 = ((t0_shift /r 4294967296) ^ (t0_sum /r 4294967296) ^ (t0_rshift /r 4294967296)) & 4294967295
      encV0 = (encV0 + f0) /r 4294967296

      mut as int64: t1_shift = ((encV0 << 4) & 4294967295) + k2
      mut as int64: t1_sum = encV0 + sum
      mut as int64: t1_rshift = (encV0 >> 5) + k3
      mut as int64: f1 = ((t1_shift /r 4294967296) ^ (t1_sum /r 4294967296) ^ (t1_rshift /r 4294967296)) & 4294967295
      encV1 = (encV1 + f1) /r 4294967296

      cycle = cycle + 1
}

println("==================================================")
println("2. Bloco Cifrado TEA (64 bits):")
println("   C0: " + encV0)
println("   C1: " + encV1)

#L Decriptacao TEA (32 ciclos reversos com delta * 32 mod 2^32)
mut as int64: decV0 = encV0
mut as int64: decV1 = encV1
mut as int64: decSum = (delta * 32) /r 4294967296

mut as int64: dCycle = 1
infinite (dCycle <= 32) {
      mut as int64: dt1_shift = ((decV0 << 4) & 4294967295) + k2
      mut as int64: dt1_sum = decV0 + decSum
      mut as int64: dt1_rshift = (decV0 >> 5) + k3
      mut as int64: df1 = ((dt1_shift /r 4294967296) ^ (dt1_sum /r 4294967296) ^ (dt1_rshift /r 4294967296)) & 4294967295

      mut as int64: diff1 = decV1 - df1
      infinite (diff1 < 0) { diff1 = diff1 + 4294967296 }
      decV1 = diff1 /r 4294967296

      mut as int64: dt0_shift = ((decV1 << 4) & 4294967295) + k0
      mut as int64: dt0_sum = decV1 + decSum
      mut as int64: dt0_rshift = (decV1 >> 5) + k1
      mut as int64: df0 = ((dt0_shift /r 4294967296) ^ (dt0_sum /r 4294967296) ^ (dt0_rshift /r 4294967296)) & 4294967295

      mut as int64: diff0 = decV0 - df0
      infinite (diff0 < 0) { diff0 = diff0 + 4294967296 }
      decV0 = diff0 /r 4294967296

      mut as int64: diffSum = decSum - delta
      infinite (diffSum < 0) { diffSum = diffSum + 4294967296 }
      decSum = diffSum /r 4294967296

      dCycle = dCycle + 1
}

println("==================================================")
println("3. Bloco Decriptado TEA:")
println("   v0': " + decV0)
println("   v1': " + decV1)

route {
      decV0 == origV0 and decV1 == origV1 ==> {
            println("   SUCESSO: TEA decriptou o bloco de 64 bits perfeitamente!")
      }
      _ ==> {
            println("   FALHA: Divergencia na decriptacao TEA!")
      }
}
