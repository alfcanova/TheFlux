#L ==================================================
#L Algoritmo: SipHash Pseudorandom Function (SipHash-2-4)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O SipHash e uma familia de funcoes pseudoaleatórias (PRF) projetada por
#L Jean-Philippe Aumasson e Daniel J. Bernstein em 2012. E otimizada para
#L processamento ultrarrapido de entradas curtas e resistencia comprovada
#L contra ataques de colisao em tabelas hash (Hash-DoS).
#L
#L A arquitetura opera sobre um estado interno de 4 palavras (v0, v1, v2, v3)
#L utilizando a rodada ARX SipRound:
#L   v0 = (v0 + v1) mod 2^32; v1 = ROL(v1, 5) ^ v0; v0 = ROL(v0, 16)
#L   v2 = (v2 + v3) mod 2^32; v3 = ROL(v3, 8) ^ v2
#L   v0 = (v0 + v3) mod 2^32; v3 = ROL(v3, 7) ^ v0
#L   v2 = (v2 + v1) mod 2^32; v1 = ROL(v1, 13) ^ v2; v2 = ROL(v2, 16)
#L ==================================================

#L Chave secreta de 64 bits (duas palavras k0, k1 de 32 bits)
mut as int64: k0 = 117835012   #L 0x07060504
mut as int64: k1 = 50462976    #L 0x03020100

#L Mensagem m0: "mple" (0x656c706d = 1701605485)
mut as int64: m0 = 1701605485

println("==================================================")
println("  SciAlgo: SipHash-2-4 Pseudorandom Function (PRF)")
println("==================================================")
println("1. Entradas e Chaves:")
println("   Chave k0: " + k0 + ", k1: " + k1)
println("   Mensagem m0: " + m0)

#L Inicializacao do estado de 4 palavras
mut as int64: v0 = k0
mut as int64: v1 = k1
mut as int64: v2 = (k0 ^ 1819895653) & 4294967295   #L k0 ^ 0x6c796765
mut as int64: v3 = (k1 ^ 1952801890) & 4294967295   #L k1 ^ 0x74656462

println("   Estado Inicial v: [" + v0 + ", " + v1 + ", " + v2 + ", " + v3 + "]")

#L Ingestao do bloco de mensagem m0 (c = 2 rodadas)
v3 = v3 ^ m0

#L Rodada 1 de compressao
mut as int64: r1_v0 = (v0 + v1) /r 4294967296
mut as int64: rol1_v1 = ((v1 << 5) & 4294967295) | (v1 >> 27)
mut as int64: r1_v1 = (rol1_v1 ^ r1_v0) & 4294967295
r1_v0 = ((r1_v0 << 16) & 4294967295) | (r1_v0 >> 16)

mut as int64: r1_v2 = (v2 + v3) /r 4294967296
mut as int64: rol1_v3 = ((v3 << 8) & 4294967295) | (v3 >> 24)
mut as int64: r1_v3 = (rol1_v3 ^ r1_v2) & 4294967295

r1_v0 = (r1_v0 + r1_v3) /r 4294967296
mut as int64: rol1_v3_2 = ((r1_v3 << 7) & 4294967295) | (r1_v3 >> 25)
r1_v3 = (rol1_v3_2 ^ r1_v0) & 4294967295

r1_v2 = (r1_v2 + r1_v1) /r 4294967296
mut as int64: rol1_v1_2 = ((r1_v1 << 13) & 4294967295) | (r1_v1 >> 19)
r1_v1 = (rol1_v1_2 ^ r1_v2) & 4294967295
r1_v2 = ((r1_v2 << 16) & 4294967295) | (r1_v2 >> 16)

v0 = r1_v0
v1 = r1_v1
v2 = r1_v2
v3 = r1_v3

#L Rodada 2 de compressao
mut as int64: r2_v0 = (v0 + v1) /r 4294967296
mut as int64: rol2_v1 = ((v1 << 5) & 4294967295) | (v1 >> 27)
mut as int64: r2_v1 = (rol2_v1 ^ r2_v0) & 4294967295
r2_v0 = ((r2_v0 << 16) & 4294967295) | (r2_v0 >> 16)

mut as int64: r2_v2 = (v2 + v3) /r 4294967296
mut as int64: rol2_v3 = ((v3 << 8) & 4294967295) | (v3 >> 24)
mut as int64: r2_v3 = (rol2_v3 ^ r2_v2) & 4294967295

r2_v0 = (r2_v0 + r2_v3) /r 4294967296
mut as int64: rol2_v3_2 = ((r2_v3 << 7) & 4294967295) | (r2_v3 >> 25)
r2_v3 = (rol2_v3_2 ^ r2_v0) & 4294967295

r2_v2 = (r2_v2 + r2_v1) /r 4294967296
mut as int64: rol2_v1_2 = ((r2_v1 << 13) & 4294967295) | (r2_v1 >> 19)
r2_v1 = (rol2_v1_2 ^ r2_v2) & 4294967295
r2_v2 = ((r2_v2 << 16) & 4294967295) | (r2_v2 >> 16)

v0 = r2_v0 ^ m0
v1 = r2_v1
v2 = r2_v2
v3 = r2_v3

#L Finalizacao (v2 = v2 ^ 0xFF seguido de d = 4 rodadas)
v2 = v2 ^ 255

mut as int64: fRound = 1
infinite (fRound <= 4) {
      mut as int64: f_v0 = (v0 + v1) /r 4294967296
      mut as int64: f_rol_v1 = ((v1 << 5) & 4294967295) | (v1 >> 27)
      mut as int64: f_v1 = (f_rol_v1 ^ f_v0) & 4294967295
      f_v0 = ((f_v0 << 16) & 4294967295) | (f_v0 >> 16)

      mut as int64: f_v2 = (v2 + v3) /r 4294967296
      mut as int64: f_rol_v3 = ((v3 << 8) & 4294967295) | (v3 >> 24)
      mut as int64: f_v3 = (f_rol_v3 ^ f_v2) & 4294967295

      f_v0 = (f_v0 + f_v3) /r 4294967296
      mut as int64: f_rol_v3_2 = ((f_v3 << 7) & 4294967295) | (f_v3 >> 25)
      f_v3 = (f_rol_v3_2 ^ f_v0) & 4294967295

      f_v2 = (f_v2 + f_v1) /r 4294967296
      mut as int64: f_rol_v1_2 = ((f_v1 << 13) & 4294967295) | (f_v1 >> 19)
      f_v1 = (f_rol_v1_2 ^ f_v2) & 4294967295
      f_v2 = ((f_v2 << 16) & 4294967295) | (f_v2 >> 16)

      v0 = f_v0
      v1 = f_v1
      v2 = f_v2
      v3 = f_v3

      fRound = fRound + 1
}

#L Tag gerada = v1 ^ v3
mut as int64: sipTag = (v1 ^ v3) & 4294967295

println("==================================================")
println("2. Estado Final e Tag Calculada:")
println("   v: [" + v0 + ", " + v1 + ", " + v2 + ", " + v3 + "]")
println("   SipHash Tag: " + sipTag)

#L Validacao do resultado exato (1245708350)
mut as bool: isMatch = (sipTag == 1245708350)

route {
      isMatch ==> {
            println("   SUCESSO: Funcao pseudoaleatoria SipHash-2-4 validada perfeitamente!")
      }
      _ ==> {
            println("   FALHA: Divergencia na avaliacao do SipHash!")
      }
}
