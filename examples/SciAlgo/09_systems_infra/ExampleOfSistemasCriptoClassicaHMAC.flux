#L ==================================================
#L Algoritmo: Keyed-Hash Message Authentication Code (HMAC - RFC 2104)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O HMAC (Keyed-Hash Message Authentication Code) e um mecanismo de
#L autenticacao de mensagens baseado em funcoes de hash criptografico,
#L padronizado pela RFC 2104 e FIPS PUB 198.
#L
#L A construcao combina a chave secreta K com duas constantes de preenchimento (padding):
#L   ipad = 0x36 repetido B vezes (0x36363636 = 909522486 em palavras de 32 bits)
#L   opad = 0x5C repetido B vezes (0x5C5C5C5C = 1549556828 em palavras de 32 bits)
#L
#L A tag de autenticacao e gerada por aninhamento criptografico:
#L   HMAC(K, m) = H((K ^ opad) || H((K ^ ipad) || m))
#L ==================================================

#L Chave K (16 bytes = 4 palavras little-endian): "FluxHMACKey12345"
mut as list of int64: keyWords = [2020961350, 1128353096, 830039371, 892613426]

#L Mensagem m (16 bytes = 4 palavras little-endian): "PayloadDataFlux!"
mut as list of int64: msgWords = [1819894096, 1147429231, 1180791905, 561542508]

println("==================================================")
println("  SciAlgo: HMAC Message Authentication Code (RFC 2104)")
println("==================================================")
println("1. Entradas Criptograficas:")
println("   Chave K (4 palavras): " + keyWords)
println("   Mensagem m (4 palavras): " + msgWords)

#L Expansao da chave para 16 palavras (512 bits) com padding de zeros
mut as list of int64: K0 = [2020961350, 1128353096, 830039371, 892613426, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#L Geracao dos blocos K ^ ipad e K ^ opad
mut as list of int64: K_ipad = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
mut as list of int64: K_opad = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
mut as int64: ki = 1
infinite (ki <= 16) {
      K_ipad[ki] = (K0[ki] ^ 909522486) & 4294967295
      K_opad[ki] = (K0[ki] ^ 1549556828) & 4294967295
      ki = ki + 1
}

#L Constantes de deslocamento s e aditivas K para a funcao compressora MD5
mut as list of int64: sMD5 = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]
mut as list of int64: KMD5 = [3614090360, 3905402710, 606105819, 3250441966, 4118548399, 1200080426, 2821735955, 4249261313, 1770035416, 2336552879, 4294925233, 2304563134, 1804603682, 4254626195, 2792965006, 1236535329, 4129170786, 3225465664, 643717713, 3921069994, 3593408605, 38016083, 3634488961, 3889429448, 568446438, 3275163606, 4107603335, 1163531501, 2850285829, 4243563512, 1735328473, 2368359562, 4294588738, 2272392833, 1839030562, 4259657740, 2763975236, 1272893353, 4139469664, 3200236656, 681279174, 3936430074, 3572445317, 76029189, 3654602809, 3873151461, 530742520, 3299628645, 4096336452, 1126891415, 2878612391, 4237533241, 1700485571, 2399980690, 4293915773, 2240044497, 1873313359, 4264355552, 2734768916, 1309151649, 4149444226, 3174756917, 718787259, 3951481745]

#L Estado acumulado da funcao hash (4 palavras)
mut as list of int64: st = [1732584193, 4023233417, 2562383102, 271733878]

#L Execucao sequencial dos 4 blocos de compressao:
#L Bloco 1: K_ipad
#L Bloco 2: msg + padding (640 bits total)
#L Bloco 3: K_opad
#L Bloco 4: inner_hash + padding (640 bits total)
mut as list of int64: innerHash = [0, 0, 0, 0]
mut as list of int64: authTag = [0, 0, 0, 0]

mut as int64: stage = 1
infinite (stage <= 4) {
      mut as list of int64: curBlock = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      route {
            stage == 1 ==> {
                  curBlock = K_ipad
            }
            stage == 2 ==> {
                  curBlock = [msgWords[1], msgWords[2], msgWords[3], msgWords[4], 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 640, 0]
            }
            stage == 3 ==> {
                  #L Reinicializa estado hash para a passagem externa (outer pass)
                  st[1] = 1732584193
                  st[2] = 4023233417
                  st[3] = 2562383102
                  st[4] = 271733878
                  curBlock = K_opad
            }
            _ ==> {
                  curBlock = [innerHash[1], innerHash[2], innerHash[3], innerHash[4], 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 640, 0]
            }
      }

      #L Compressao MD5 das 16 palavras do bloco
      mut as int64: a0 = st[1]
      mut as int64: b0 = st[2]
      mut as int64: c0 = st[3]
      mut as int64: d0 = st[4]

      mut as int64: a = a0
      mut as int64: b = b0
      mut as int64: c = c0
      mut as int64: d = d0

      mut as int64: step = 0
      infinite (step < 64) {
            mut as int64: f = 0
            mut as int64: g = 0
            route {
                  step <= 15 ==> {
                        mut as int64: notB = 4294967295 - b
                        f = (b & c) | (notB & d)
                        g = step
                  }
                  step <= 31 ==> {
                        mut as int64: notD = 4294967295 - d
                        f = (d & b) | (notD & c)
                        g = ((5 * step) + 1) /r 16
                  }
                  step <= 47 ==> {
                        f = (b ^ c ^ d) & 4294967295
                        g = ((3 * step) + 5) /r 16
                  }
                  _ ==> {
                        mut as int64: notD2 = 4294967295 - d
                        f = (c ^ (b | notD2)) & 4294967295
                        g = (7 * step) /r 16
                  }
            }

            mut as int64: mVal = curBlock[g + 1]
            mut as int64: kVal = KMD5[step + 1]
            mut as int64: sVal = sMD5[step + 1]

            mut as int64: sumVal = (f + a + kVal + mVal) /r 4294967296
            mut as int64: rolVal = ((sumVal << sVal) & 4294967295) | (sumVal >> (32 - sVal))

            a = d
            d = c
            c = b
            b = (b + rolVal) /r 4294967296

            step = step + 1
      }

      st[1] = (a0 + a) /r 4294967296
      st[2] = (b0 + b) /r 4294967296
      st[3] = (c0 + c) /r 4294967296
      st[4] = (d0 + d) /r 4294967296

      route {
            stage == 2 ==> {
                  innerHash[1] = st[1]
                  innerHash[2] = st[2]
                  innerHash[3] = st[3]
                  innerHash[4] = st[4]
            }
            stage == 4 ==> {
                  authTag[1] = st[1]
                  authTag[2] = st[2]
                  authTag[3] = st[3]
                  authTag[4] = st[4]
            }
            _ ==> {}
      }

      stage = stage + 1
}

println("==================================================")
println("2. Resultados Criptograficos HMAC:")
println("   Inner Hash H_in: " + innerHash)
println("   Tag de Autenticacao HMAC (Tag): " + authTag)

#L Vetor oficial HMAC-MD5 para as entradas especificadas:
#L [3385140243, 3642869720, 1111094170, 2986991614]
mut as bool: isMatch = (authTag[1] == 3385140243) and (authTag[2] == 3642869720) and (authTag[3] == 1111094170) and (authTag[4] == 2986991614)

route {
      isMatch ==> {
            println("   SUCESSO: Autenticacao HMAC validada estritamente com RFC 2104!")
      }
      _ ==> {
            println("   FALHA: Divergencia no calculo do HMAC!")
      }
}
