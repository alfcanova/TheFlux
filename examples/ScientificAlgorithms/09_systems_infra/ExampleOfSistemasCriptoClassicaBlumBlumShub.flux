#L ==================================================
#L Algoritmo: Blum Blum Shub Pseudorandom Generator (BBS)
#L Dominio: IX - Sistemas e Infraestrutura
#L Subdominio: Primitivas criptograficas e cifras classicas
#L ==================================================
#L Descricao:
#L O gerador de numeros pseudoaleatorios criptograficamente seguro (CSPRNG)
#L Blum Blum Shub (BBS) foi introduzido em 1986 por Lenore Blum, Manuel Blum
#L e Michael Shub.
#L
#L A recorrencia opera sobre o modulo de Blum M = p * q, onde p e q sao
#L numeros primos congruentes a 3 mod 4 (primos de Blum):
#L   x_0 = s^2 mod M
#L   x_{n+1} = (x_n)^2 mod M
#L Onde cada bit gerado b_n e a paridade ou bit menos significativo de x_n:
#L   b_n = x_n mod 2
#L
#L A seguranca do BBS possui reducao teorica rigorosa a intratabilidade do
#L problema da residuosidade quadratica modulo compostos, equivalente a
#L fatoracao inteira de grandes inteiros.
#L ==================================================

#L Primos de Blum: p = 499 (499 = 4*124 + 3), q = 547 (547 = 4*136 + 3)
mut as int64: p = 499
mut as int64: q = 547
mut as int64: M = p * q     #L 272953
mut as int64: s = 572       #L Semente coprima com M

println("==================================================")
println("  SciAlgo: Blum Blum Shub CSPRNG (BBS 1986)")
println("==================================================")
println("1. Parametros do Modulo de Blum:")
println("   Primo p (congruente a 3 mod 4): " + p)
println("   Primo q (congruente a 3 mod 4): " + q)
println("   Modulo composto M = p * q: " + M)
println("   Semente inicial s: " + s)

#L Estado inicial x_0 = s^2 mod M
mut as int64: x0 = (s * s) /r M
println("   Estado inicial x0 = s^2 mod M: " + x0)

println("==================================================")
println("2. Geracao de Fluxo de Bits Pseudoaleatorios:")

mut as list of int64: bits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
mut as list of int64: states = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

mut as int64: curX = x0
mut as int64: step = 1
infinite (step <= 16) {
      curX = (curX * curX) /r M
      mut as int64: b = curX /r 2
      bits[step] = b
      states[step] = curX
      step = step + 1
}

println("   Estados intermediarios (primeiros 4): [" + states[1] + ", " + states[2] + ", " + states[3] + ", " + states[4] + "]")
println("   Sequencia de 16 bits gerada: " + bits)

#L Validacao da sequencia de bits com o vetor analitico:
#L bits esperados: [1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1]
mut as bool: isMatch = (bits[1] == 1) and (bits[2] == 1) and (bits[3] == 1) and (bits[4] == 0) and (bits[5] == 0) and (bits[6] == 0) and (bits[7] == 0) and (bits[8] == 1) and (bits[9] == 1) and (bits[10] == 1) and (bits[11] == 1) and (bits[12] == 0) and (bits[13] == 0) and (bits[14] == 0) and (bits[15] == 1) and (bits[16] == 1)

route {
      isMatch ==> {
            println("   SUCESSO: Gerador Blum Blum Shub validado com reducao quadratica exata!")
      }
      _ ==> {
            println("   FALHA: Divergencia na sequencia gerada pelo BBS!")
      }
}
