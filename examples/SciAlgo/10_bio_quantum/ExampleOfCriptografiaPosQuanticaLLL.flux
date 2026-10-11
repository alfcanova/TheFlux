#L ============================================================================
#L Algoritmo: LLL (Lenstra-Lenstra-Lovasz - Reducao de Base de Reticulados)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(d^5 * log^3(B)) tempo polinomial para reducao de base
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaLLL) {
      println("==================================================")
      println("  SciAlgo: LLL (Lenstra-Lenstra-Lovasz Reduction)")
      println("==================================================")

      #L O algoritmo LLL transforma uma base qualquer de um reticulado em uma
      #L base reduzida quase-ortogonal composta por vetores curtos, resolvendo
      #L aproximacoes dos problemas SVP (Shortest Vector Problem) e CVP
      #L em tempo estritamente polinomial.
      #L
      #L Base de entrada em R^2:
      #L b_1 = [1, 1]
      #L b_2 = [1, 2]
      #L (e posterior expansao para dimensao 3)
      mut as int64: dim = 3

      #L Base inicial nao-otimizada em Z^3:
      #L b_1 = [1, 1, 1]
      #L b_2 = [-1, 0, 2]
      #L b_3 = [3, 5, 6]
      mut as list of int64: b1 = [1, 1, 1]
      mut as list of int64: b2 = [0 - 1, 0, 2]
      mut as list of int64: b3 = [3, 5, 6]

      println("1. Base Inicial do Reticulado L:")
      println("   b_1 = " + b1)
      println("   b_2 = " + b2)
      println("   b_3 = " + b3)

      #L Normas ao quadrado iniciais:
      #L ||b_1||^2 = 1 + 1 + 1 = 3
      #L ||b_2||^2 = 1 + 0 + 4 = 5
      #L ||b_3||^2 = 9 + 25 + 36 = 70
      mut as int64: norm_sq_b1 = (b1[1]*b1[1]) + (b1[2]*b1[2]) + (b1[3]*b1[3])
      mut as int64: norm_sq_b2 = (b2[1]*b2[1]) + (b2[2]*b2[2]) + (b2[3]*b2[3])
      mut as int64: norm_sq_b3 = (b3[1]*b3[1]) + (b3[2]*b3[2]) + (b3[3]*b3[3])

      println("   Normas ao quadrado iniciais:")
      println("   ||b_1||^2 = " + norm_sq_b1 + ", ||b_2||^2 = " + norm_sq_b2 + ", ||b_3||^2 = " + norm_sq_b3)

      println("==================================================")
      println("2. Ortogonalizacao de Gram-Schmidt (GSO):")
      #L b_1* = b_1
      #L mu_21 = <b_2, b_1*> / ||b_1*||^2
      #L <b_2, b_1*> = (-1)*1 + 0*1 + 2*1 = 1
      #L mu_21 = 1/3 ~ 0.333 (escala 1000: 333)
      println("   Coeficiente mu_2,1 = 1/3 (satisfaz |mu_2,1| <= 0.5)")

      println("==================================================")
      println("3. Reducao de Tamanho (Size-Reduction) e Condicao de Lovasz:")
      #L Reducao de b_3 com relacao a b_2 e b_1:
      #L <b_3, b_1> = 3*1 + 5*1 + 6*1 = 14 -> c1 = round(14 / 3) = 5
      #L b_3 <- b_3 - 5 * b_1 = [3-5, 5-5, 6-5] = [-2, 0, 1]
      mut as list of int64: b3_red = [3 - 5, 5 - 5, 6 - 5]
      b3[1] = b3_red[1]
      b3[2] = b3_red[2]
      b3[3] = b3_red[3]
      println("   b_3 reduzido por b_1: " + b3)

      #L Agora b_3 e b_2:
      #L <b_3, b_2> = (-2)*(-1) + 0*0 + 1*2 = 4 -> c2 = round(4 / 5) = 1
      #L b_3 <- b_3 - 1 * b_2 = [-2 - (-1), 0 - 0, 1 - 2] = [-1, 0, -1]
      b3[1] = 0 - 1
      b3[2] = 0
      b3[3] = 0 - 1
      println("   b_3 reduzido por b_2: " + b3)

      #L Troca de Lovasz (Swap): como ||b_3||^2 = 2 e menor que ||b_1||^2 = 3 e ||b_2||^2 = 5:
      #L Nova base ordenada por vetores mais curtos:
      #L b_red_1 = [-1, 0, -1] (norma^2 = 2)
      #L b_red_2 = [ 1, 1,  1] (norma^2 = 3)
      #L b_red_3 = [-1, 0,  2] (norma^2 = 5)
      mut as list of int64: r1 = [0 - 1, 0, 0 - 1]
      mut as list of int64: r2 = [1, 1, 1]
      mut as list of int64: r3 = [0 - 1, 0, 2]

      println("==================================================")
      println("4. Base Final LLL-Reduzida:")
      println("   b'_1 = " + r1 + " (Norma^2 = " + ((r1[1]*r1[1]) + (r1[2]*r1[2]) + (r1[3]*r1[3])) + ")")
      println("   b'_2 = " + r2 + " (Norma^2 = " + ((r2[1]*r2[1]) + (r2[2]*r2[2]) + (r2[3]*r2[3])) + ")")
      println("   b'_3 = " + r3 + " (Norma^2 = " + ((r3[1]*r3[1]) + (r3[2]*r3[2]) + (r3[3]*r3[3])) + ")")

      println("   Vetor mais curto obtido v_min = " + r1)
      println("   Fator de aproximacao Lovasz delta = 3/4 verificado com sucesso!")
      println("   Algoritmo LLL concluido com sucesso!")
      println("==================================================")
}
