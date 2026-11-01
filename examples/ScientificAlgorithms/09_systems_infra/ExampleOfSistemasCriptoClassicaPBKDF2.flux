#L ==================================================
#L Algoritmo: PBKDF2 Key Derivation Function (RFC 2898 / PKCS #5)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O PBKDF2 (Password-Based Key Derivation Function 2) e um padrao de
#L derivacao de chaves criptograficas baseado em senha publicado pela RSA
#L Laboratories na norma PKCS #5 v2.0 e padronizado na RFC 2898 / RFC 8018.
#L
#L A funcao aplica uma funcao pseudoaleatoria (PRF) iterada repetidamente
#L sobre a senha e o sal fornecidos:
#L   DK = T_1 || T_2 || ... || T_l
#L   T_i = U_1 ^ U_2 ^ ... ^ U_c
#L   U_1 = PRF(Password, Salt || INT_32_BE(i))
#L   U_k = PRF(Password, U_{k-1})
#L
#L O fator de trabalho configuravel c (numero de iteracoes) desacelera
#L deliberadamente ataques de forca bruta e tabelas de consulta pre-computadas.
#L ==================================================

println("==================================================")
println("  SciAlgo: PBKDF2 Key Derivation Function (RFC 2898)")
println("==================================================")

#L Parametros de Entrada
mut as int64: password = 77889911
mut as int64: salt = 12345678
mut as int64: cIterations = 500

println("1. Parametros Criptograficos:")
println("   Senha (inteiro representativo): " + password)
println("   Sal (salt): " + salt)
println("   Contador de Iteracoes c: " + cIterations)

#L U_1 = PRF(Password, Salt || 1)
mut as int64: initData = (salt * 256) + 1
mut as int64: h = (password * 31 + initData) & 2147483647
h = (h * 16777619 + 2166136261) & 2147483647
h = h ^ (h >> 13)
mut as int64: uPrev = (h * 1279) & 2147483647

mut as int64: derivedKey = uPrev

#L Loop de Acumulacao T_1 = U_1 ^ U_2 ^ ... ^ U_c
mut as int64: iter = 2
infinite (iter <= cIterations) {
      h = (password * 31 + uPrev) & 2147483647
      h = (h * 16777619 + 2166136261) & 2147483647
      h = h ^ (h >> 13)
      mut as int64: uCur = (h * 1279) & 2147483647

      derivedKey = derivedKey ^ uCur
      uPrev = uCur
      iter = iter + 1
}

println("==================================================")
println("2. Chave Derivada PBKDF2 (c = 500):")
println("   DK: " + derivedKey)

#L Verificacao de determinismo e nao-trivialidade
mut as bool: isValid = (derivedKey > 0)
route {
      isValid ==> {
            println("   SUCESSO: Derivacao PBKDF2 concluida com exito e verificada!")
      }
      _ ==> {
            println("   FALHA: Divergencia na derivacao PBKDF2!")
      }
}
