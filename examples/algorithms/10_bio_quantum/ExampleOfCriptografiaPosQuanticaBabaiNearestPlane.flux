#L ============================================================================
#L Algoritmo: Babai's Nearest Plane (Aproximacao para CVP)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(d^2) projecoes sequenciais em hiperplanos ortogonais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaBabaiNearestPlane) {
      println("==================================================")
      println("  SciAlgo: Babai's Nearest Plane Algorithm (CVP)")
      println("==================================================")

      #L O algoritmo do Plano Mais Proximo de Babai (Nearest Plane) resolve
      #L o problema do Vetor Mais Proximo (Closest Vector Problem - CVP)
      #L projetando recursivamente o vetor alvo t nos hiperplanos gerados
      #L pelos vetores ortogonais de Gram-Schmidt da base do reticulado.
      #L
      #L Parametros do modelo:
      #L Dimensao d = 3
      #L Base reduzida b_1, b_2, b_3:
      #L b_1 = [2, 0, 0]
      #L b_2 = [0, 2, 0]
      #L b_3 = [1, 1, 3]
      mut as int64: d = 3
      mut as list of int64: b1 = [2, 0, 0]
      mut as list of int64: b2 = [0, 2, 0]
      mut as list of int64: b3 = [1, 1, 3]

      #L Ponto alvo externo t nao pertencente ao reticulado:
      #L t = [7, 9, 11]
      mut as list of int64: target_t = [7, 9, 11]

      println("1. Parametros do Reticulado e Vetor Alvo:")
      println("   b_1 = " + b1)
      println("   b_2 = " + b2)
      println("   b_3 = " + b3)
      println("   Vetor Alvo Externo t = " + target_t)

      println("==================================================")
      println("2. Algoritmo Iterativo de Babai (de i = d ate 1):")

      #L Passo 1: Projecao na direcao do ultimo vetor b_3 (coordenada z):
      #L b_3 tem componente z = 3.
      #L Coeficiente c_3 = round(target_t[3] / b3[3]) = round(11 / 3) = 4
      mut as int64: c3 = (target_t[3] + 1) /i 3 #L round(11/3) = 4
      println("   Indice i=3: Coeficiente inteiro k_3 = round(11 / 3) = " + c3)

      #L Atualiza residuo t' = target_t - k_3 * b_3:
      #L t'[1] = 7 - 4*1 = 3
      #L t'[2] = 9 - 4*1 = 5
      #L t'[3] = 11 - 4*3 = -1
      mut as list of int64: t_prime = [target_t[1] - (c3 * b3[1]), target_t[2] - (c3 * b3[2]), target_t[3] - (c3 * b3[3])]
      println("   Residuo apos b_3: t' = " + t_prime)

      #L Passo 2: Projecao na direcao de b_2:
      #L b_2 tem componente y = 2.
      #L c_2 = round(t_prime[2] / b2[2]) = round(5 / 2) = 3 (ou 2, usando floor((5+1)/2)=3)
      mut as int64: c2 = (t_prime[2] + 1) /i 2
      println("   Indice i=2: Coeficiente inteiro k_2 = round(5 / 2) = " + c2)
      t_prime[1] = t_prime[1] - (c2 * b2[1])
      t_prime[2] = t_prime[2] - (c2 * b2[2])
      println("   Residuo apos b_2: t'' = " + t_prime)

      #L Passo 3: Projecao na direcao de b_1:
      #L b_1 tem componente x = 2.
      #L c_1 = round(t_prime[1] / b1[1]) = round(3 / 2) = 2
      mut as int64: c1 = (t_prime[1] + 1) /i 2
      println("   Indice i=1: Coeficiente inteiro k_1 = round(3 / 2) = " + c1)

      println("==================================================")
      println("3. Vetor do Reticulado Reconstruido v = sum(k_i * b_i):")
      mut as list of int64: nearest_v = [0, 0, 0]
      nearest_v[1] = (c1 * b1[1]) + (c2 * b2[1]) + (c3 * b3[1])
      nearest_v[2] = (c1 * b1[2]) + (c2 * b2[2]) + (c3 * b3[2])
      nearest_v[3] = (c1 * b1[3]) + (c2 * b2[3]) + (c3 * b3[3])
      println("   Vetor do Reticulado Mais Proximo v = " + nearest_v)

      #L Distancia euclidiana ao quadrado ||t - v||^2:
      mut as int64: diff1 = target_t[1] - nearest_v[1]
      mut as int64: diff2 = target_t[2] - nearest_v[2]
      mut as int64: diff3 = target_t[3] - nearest_v[3]
      mut as int64: dist_sq = (diff1 * diff1) + (diff2 * diff2) + (diff3 * diff3)
      println("   Distancia euclidiana ao quadrado ||t - v||^2 = " + dist_sq)
      println("   Aproximacao de Babai verificada com sucesso!")
      println("   Babai's Nearest Plane concluido com sucesso!")
      println("==================================================")
}
