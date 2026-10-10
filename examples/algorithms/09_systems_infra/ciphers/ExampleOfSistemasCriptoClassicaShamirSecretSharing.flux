#L ==================================================
#L Algoritmo: Shamir's (k, n) Threshold Secret Sharing
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O Esquema de Compartilhamento de Segredos de Shamir (1979) e uma
#L construcao criptografica baseada em interpolacao polinomial sobre corpos
#L finitos GF(p). Permite dividir um segredo S em n partes (shares), de modo
#L que qualquer subconjunto de k ou mais partes possa reconstruir o segredo S,
#L enquanto k - 1 ou menos partes nao revelam informacao alguma sobre S
#L (seguranca perfeita no sentido da Teoria da Informacao).
#L
#L A geracao avalia o polinomio de grau k - 1:
#L   P(x) = (S + a_1 * x + a_2 * x^2 + ... + a_{k-1} * x^{k-1}) mod p
#L A reconstrucao avalia P(0) atraves dos polinomios de base de Lagrange:
#L   S = sum_{i=1}^k y_i * l_i(0) mod p
#L   l_i(0) = prod_{j != i} (-x_j) * (x_i - x_j)^{-1} mod p
#L ==================================================

#L Parametros: threshold k = 3, total n = 5 sobre o corpo primo GF(10007)
mut as int64: p = 10007
mut as int64: k = 3
mut as int64: n = 5
mut as int64: secret = 1234
mut as int64: a1 = 166
mut as int64: a2 = 94

println("==================================================")
println("  SciAlgo: Shamir's (k, n) Threshold Secret Sharing")
println("==================================================")
println("1. Parametros do Esquema:")
println("   Corpo Primo p: " + p)
println("   Limiar (Threshold k): " + k)
println("   Total de Participantes (n): " + n)
println("   Segredo Original S: " + secret)
println("   Polinomio P(x) = (" + secret + " + " + a1 + "*x + " + a2 + "*x^2) mod " + p)

#L Geracao das n partes (x_i, y_i)
mut as list of int64: shareX = [1, 2, 3, 4, 5]
mut as list of int64: shareY = [0, 0, 0, 0, 0]

mut as int64: idx = 1
infinite (idx <= n) {
      mut as int64: curX = shareX[idx]
      mut as int64: term1 = (a1 * curX) /r p
      mut as int64: term2 = ((a2 * curX) /r p * curX) /r p
      mut as int64: curY = (secret + term1 + term2) /r p
      shareY[idx] = curY
      println("   Parte " + idx + ": (x = " + curX + ", y = " + curY + ")")
      idx = idx + 1
}

println("==================================================")
println("2. Reconstrucao de Lagrange a partir de k = 3 partes selecionadas:")
#L Seleciona partes 1, 3 e 5
mut as list of int64: subX = [shareX[1], shareX[3], shareX[5]]
mut as list of int64: subY = [shareY[1], shareY[3], shareY[5]]
println("   Partes selecionadas: [(1, " + subY[1] + "), (3, " + subY[2] + "), (5, " + subY[3] + ")]")

mut as int64: reconstructedS = 0
mut as int64: i = 1
infinite (i <= k) {
      mut as int64: xi = subX[i]
      mut as int64: yi = subY[i]

      mut as int64: num = 1
      mut as int64: den = 1

      mut as int64: j = 1
      infinite (j <= k) {
            route {
                  i != j ==> {
                        mut as int64: xj = subX[j]

                        #L Numerador: (-xj) mod p
                        mut as int64: negXj = 0 - xj
                        infinite (negXj < 0) { negXj = negXj + p }
                        negXj = negXj /r p
                        num = (num * negXj) /r p

                        #L Denominador: (xi - xj) mod p
                        mut as int64: diffX = xi - xj
                        infinite (diffX < 0) { diffX = diffX + p }
                        diffX = diffX /r p
                        den = (den * diffX) /r p
                  }
                  _ ==> {}
            }
            j = j + 1
      }

      #L Inversao Modular do denominador: den^(p-2) mod p via Pequeno Teorema de Fermat
      mut as int64: invDen = 1
      mut as int64: base = den
      mut as int64: exp = p - 2
      infinite (exp > 0) {
            route {
                  (exp /r 2) == 1 ==> {
                        invDen = (invDen * base) /r p
                  }
                  _ ==> {}
            }
            base = (base * base) /r p
            exp = exp /i 2
      }

      #L Polinomio de base l_i(0) = (num * invDen) mod p
      mut as int64: li = (num * invDen) /r p
      mut as int64: termS = (yi * li) /r p
      reconstructedS = (reconstructedS + termS) /r p

      i = i + 1
}

println("==================================================")
println("3. Segredo Reconstruido:")
println("   S': " + reconstructedS)

mut as bool: isMatch = (reconstructedS == secret)
route {
      isMatch ==> {
            println("   SUCESSO: Segredo de Shamir reconstruido perfeitamente via Lagrange!")
      }
      _ ==> {
            println("   FALHA: Divergencia na interpolacao do segredo de Shamir!")
      }
}
