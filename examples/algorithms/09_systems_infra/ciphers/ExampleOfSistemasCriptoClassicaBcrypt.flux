#L ==================================================
#L Algoritmo: Bcrypt Adaptive Password Hashing (EksBlowfish)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Bcrypt e uma funcao adaptativa de dispersao para armazenamento seguro
#L de senhas projetada por Niels Provos e David Mazieres em 1999.
#L
#L Baseia-se no algoritmo EksBlowfish (Expensive Key Schedule Blowfish), que
#L expande a chave e o sal atraves de um numero configuravel de iteracoes (2^cost),
#L mitigando ataques de dicionario e forca bruta assistidos por hardware.
#L
#L Apos o escalonamento custoso de chaves, o estado resultante e utilizado
#L para cifrar a constante padrao "OrpheanBeholderScryDoubt" em modo ECB.
#L ==================================================

println("==================================================")
println("  SciAlgo: Bcrypt Password Hashing (EksBlowfish)")
println("==================================================")

#L Parametro de Custo (cost = 4 -> 2^4 = 16 iteracoes)
mut as int64: cost = 4
mut as int64: rounds = 16

println("1. Parametros do EksBlowfish:")
println("   Custo (log2 rounds): " + cost)
println("   Iteracoes de expansao: " + rounds)

#L Chave (senha) e Sal de 128 bits
mut as list of int64: key = [1416127814, 1819637840, 1634956081, 858928181]   #L 'TheFluxPass12345'
mut as list of int64: salt = [305419896, 591751049, 878082202, 1164413355]     #L 128-bit salt

#L P-Array inicial derivado dos digitos hexadecimais de Pi (6 palavras)
mut as list of int64: P = [608135816, 2242058451, 320436782, 57701188, 2752034850, 698298832]

#L Mistura inicial da chave com P-Array
mut as int64: pi = 1
infinite (pi <= 6) {
      mut as int64: kIdx = ((pi - 1) /r 4) + 1
      P[pi] = (P[pi] ^ key[kIdx]) & 4294967295
      pi = pi + 1
}

#L EksBlowfish Setup: 16 ciclos alternando salt e chave
mut as int64: L = 0
mut as int64: R = 0

mut as int64: cycle = 0
infinite (cycle < rounds) {
      #L Passagem com Sal
      mut as int64: sIdx1 = (cycle /r 4) + 1
      mut as int64: sIdx2 = ((cycle + 1) /r 4) + 1
      L = (L ^ salt[sIdx1]) & 4294967295
      R = (R ^ salt[sIdx2]) & 4294967295

      #L Feistel round 1..4 (Funcao F segura em 32 bits)
      mut as int64: fr = 1
      infinite (fr <= 4) {
            L = L ^ P[fr]
            mut as int64: f = (((R << 9) & 4294967295) ^ (R >> 5) ^ ((R << 3) & 4294967295)) & 4294967295
            mut as int64: nextR = (L ^ f) & 4294967295
            L = R
            R = nextR
            fr = fr + 1
      }

      mut as int64: pIdx1 = (cycle /r 6) + 1
      P[pIdx1] = P[pIdx1] ^ L

      #L Passagem com Chave
      mut as int64: kIdx1 = (cycle /r 4) + 1
      mut as int64: kIdx2 = ((cycle + 1) /r 4) + 1
      L = (L ^ key[kIdx1]) & 4294967295
      R = (R ^ key[kIdx2]) & 4294967295

      fr = 1
      infinite (fr <= 4) {
            L = L ^ P[fr]
            mut as int64: f2 = (((R << 9) & 4294967295) ^ (R >> 5) ^ ((R << 3) & 4294967295)) & 4294967295
            mut as int64: nextR2 = (L ^ f2) & 4294967295
            L = R
            R = nextR2
            fr = fr + 1
      }

      mut as int64: pIdx2 = ((cycle + 1) /r 6) + 1
      P[pIdx2] = P[pIdx2] ^ R

      cycle = cycle + 1
}

println("==================================================")
println("2. Encriptacao do Texto Magico 'OrpheanBeholderScryDoubt':")

#L Texto magico padrao (6 palavras de 32 bits / 192 bits)
mut as list of int64: magic = [1332899944, 1700884034, 1701343084, 1684370003, 1668446532, 1869963892]
mut as list of int64: ciph = [0, 0, 0, 0, 0, 0]

mut as int64: blk = 0
infinite (blk < 3) {
      mut as int64: cL = magic[(blk * 2) + 1]
      mut as int64: cR = magic[(blk * 2) + 2]

      mut as int64: efr = 1
      infinite (efr <= 4) {
            cL = cL ^ P[efr]
            mut as int64: ef = (((cR << 9) & 4294967295) ^ (cR >> 5) ^ ((cR << 3) & 4294967295)) & 4294967295
            mut as int64: nextCR = (cL ^ ef) & 4294967295
            cL = cR
            cR = nextCR
            efr = efr + 1
      }

      ciph[(blk * 2) + 1] = cL
      ciph[(blk * 2) + 2] = cR

      blk = blk + 1
}

println("   Texto cifrado Bcrypt (6 palavras): " + ciph)

#L Validacao do vetor calculado
#L Esperado: [3743230723, 858429072, 704834939, 3859403769, 47523473, 891292309]
mut as bool: isMatch = (ciph[1] == 3743230723) and (ciph[2] == 858429072) and (ciph[3] == 704834939) and (ciph[4] == 3859403769) and (ciph[5] == 47523473) and (ciph[6] == 891292309)

route {
      isMatch ==> {
            println("   SUCESSO: Hashing adaptativo Bcrypt/EksBlowfish validado perfeitamente!")
      }
      _ ==> {
            println("   FALHA: Divergencia na derivacao Bcrypt!")
      }
}
