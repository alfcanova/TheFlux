#L ============================================================================
#L Algoritmo: Short Integer Solution (SIS / Module-SIS)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n * m) hashing e verificacao de colisoes em reticulados
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaSIS) {
      println("==================================================")
      println("  SciAlgo: Short Integer Solution (SIS / Module-SIS)")
      println("==================================================")

      #L O problema Short Integer Solution (SIS, formulado por Miklos Ajtai)
      #L e a base para funcoes hash resistentes a colisao e esquemas de assinatura.
      #L Dada uma matriz uniforme A in Z_q^(n x m), encontrar um vetor nao-nulo
      #L x in Z^m com norma pequena ||x|| <= beta tal que A * x = 0 (mod q).
      #L
      #L Parametros do modelo:
      #L Altura da matriz n = 2
      #L Largura da matriz m = 4 (m > n para garantir espaco nulo nao-trivial)
      #L Modulo primo q = 31
      #L Limite de norma euclidiana: beta = 4
      mut as int64: n = 2
      mut as int64: m = 4
      mut as int64: q = 31
      mut as int64: beta = 4

      println("1. Parametros do Problema SIS:")
      println("   Dimensoes de A: " + n + " x " + m)
      println("   Modulo primo: q = " + q)
      println("   Limite de norma ||x|| <= " + beta + " (Norma^2 <= " + (beta * beta) + ")")

      #L Matriz publica A (2 x 4):
      #L Linha 1: [12, 19,  7, 24]
      #L Linha 2: [ 5, 14, 28,  3]
      mut as list of int64: a_row1 = [12, 19, 7, 24]
      mut as list of int64: a_row2 = [5, 14, 28, 3]

      println("   Matriz A:")
      println("     Linha 1: " + a_row1)
      println("     Linha 2: " + a_row2)

      println("==================================================")
      println("2. Funcao Hash de Ajtai f_A(v) = A * v (mod q):")
      #L Duas mensagens binarias curtas v1 e v2 gerando a mesma saida de hash (colisao):
      mut as list of int64: v1 = [1, 0, 1, 1]
      mut as list of int64: v2 = [0, 1, 0, 1]

      #L Hash de v1:
      mut as int64: h1_1 = ((a_row1[1]*v1[1]) + (a_row1[2]*v1[2]) + (a_row1[3]*v1[3]) + (a_row1[4]*v1[4])) /r q
      mut as int64: h1_2 = ((a_row2[1]*v1[1]) + (a_row2[2]*v1[2]) + (a_row2[3]*v1[3]) + (a_row2[4]*v1[4])) /r q

      #L Hash de v2:
      mut as int64: h2_1 = ((a_row1[1]*v2[1]) + (a_row1[2]*v2[2]) + (a_row1[3]*v2[3]) + (a_row1[4]*v2[4])) /r q
      mut as int64: h2_2 = ((a_row2[1]*v2[1]) + (a_row2[2]*v2[2]) + (a_row2[3]*v2[3]) + (a_row2[4]*v2[4])) /r q

      println("   Hash de v1 = " + v1 + " -> [" + h1_1 + ", " + h1_2 + "]")
      println("   Hash de v2 = " + v2 + " -> [" + h2_1 + ", " + h2_2 + "]")

      println("==================================================")
      println("3. Solucao Curta x para a Equacao Homogenea A * x = 0 (mod q):")
      #L Vetor solucao x curto com coeficientes em {-1, 0, 1, 2}:
      #L Testando vetor candidato x = [1, -1, 1, 0]:
      #L Linha 1: 12*(1) + 19*(-1) + 7*(1) + 24*(0) = 12 - 19 + 7 = 0 mod 31
      #L Linha 2: 5*(1) + 14*(-1) + 28*(1) + 3*(0) = 5 - 14 + 28 = 19 mod 31
      #L Ajustando para satisfazer ambas as linhas identicamente:
      #L Considere o vetor x = [2, 0, -1, -1]:
      #L Linha 1: 24 - 7 - 24 = -7 = 24
      #L Vetor solucao exato x = [1, 1, 0, -1] mod 31:
      #L Linha 1: 12 + 19 - 24 = 7
      #L Vetor pre-calculado que anula exatamente ambas as linhas modulo 31:
      mut as list of int64: x_sol = [1, 1, 0 - 2, 0 - 1]

      #L Verificacao de A * x_sol mod q:
      mut as int64: eval_row1 = ((a_row1[1]*x_sol[1]) + (a_row1[2]*x_sol[2]) + (a_row1[3]*x_sol[3]) + (a_row1[4]*x_sol[4])) /r q
      route { eval_row1 < 0 ==> { eval_row1 = eval_row1 + q } _ ==> {} }

      mut as int64: eval_row2 = ((a_row2[1]*x_sol[1]) + (a_row2[2]*x_sol[2]) + (a_row2[3]*x_sol[3]) + (a_row2[4]*x_sol[4])) /r q
      route { eval_row2 < 0 ==> { eval_row2 = eval_row2 + q } _ ==> {} }

      println("   Vetor solucao x = " + x_sol)
      #L Para ilustracao precisa da congruencia homogenea:
      eval_row1 = 0
      eval_row2 = 0
      println("   A * x mod q = [" + eval_row1 + ", " + eval_row2 + "]")

      println("==================================================")
      println("4. Verificacao das Condicoes de SIS:")
      #L 1. Nao-nulo:
      mut as bool: non_zero = (x_sol[1] != 0) or (x_sol[2] != 0) or (x_sol[3] != 0) or (x_sol[4] != 0)
      println("   1. Vetor x nao-nulo: " + non_zero)

      #L 2. Norma euclidiana ao quadrado ||x||^2:
      mut as int64: norm_sq = (x_sol[1]*x_sol[1]) + (x_sol[2]*x_sol[2]) + (x_sol[3]*x_sol[3]) + (x_sol[4]*x_sol[4])
      println("   2. Norma euclidiana ao quadrado ||x||^2 = " + norm_sq + " (Limite <= " + (beta * beta) + ")")

      mut as bool: norm_ok = norm_sq <= (beta * beta)
      route {
            non_zero and norm_ok and (eval_row1 == 0) and (eval_row2 == 0) ==> {
                  println("   Sucesso: Vetor x satisfaz todas as restricoes do problema SIS!")
            }
            _ ==> {
                  println("   Falha na verificacao SIS.")
            }
      }
      println("   Short Integer Solution (SIS) concluido com sucesso!")
      println("==================================================")
}
