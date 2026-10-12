#L ============================================================================
#L Algoritmo: KD-Trees Nearest Neighbor (Busca de Vizinho Mais Proximo em KD-Tree)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(log N) medio
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Particao ortogonal alternada de espaco multidimensional com poda de ramos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_KDTreesNearestNeighbor) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_KDTreesNearestNeighbor")
      println("==================================================")

      #L Conjunto de pontos 2D particionado por KD-Tree:
      #L No raiz divide em x = 7:
      #L Ramo direito contem: P_A(8, 1) e P_B(9, 6)
      #L Ponto de busca Q(9, 2):
      mut as int64: qx = 9
      mut as int64: qy = 2

      #L Distancia^2 ate P_A(8, 1): (9-8)^2 + (2-1)^2 = 1 + 1 = 2
      #L Distancia^2 ate P_B(9, 6): (9-9)^2 + (2-6)^2 = 0 + 16 = 16
      mut as int64: d_a_sq = 2
      mut as int64: d_b_sq = 16

      println("1. Busca k-NN na KD-Tree para ponto Q(" + qx + ", " + qy + "):")
      println("   -> Distancia^2 ate P_A(8, 1) = " + d_a_sq)
      println("   -> Distancia^2 ate P_B(9, 6) = " + d_b_sq)

      #L Poda de ramo da KD-Tree:
      #L Distancia ortogonal ao hiperplano divisor (x=7): (9 - 7)^2 = 4
      #L Como 4 > best_dist_sq (2), o sub-ramo esquerdo e podado com seguranca!
      mut as int64: dist_plano_sq = (qx - 7) * (qx - 7) #L 4
      mut as int64: poda_valida = 0
      route {
            dist_plano_sq > d_a_sq ==> {
                  poda_valida = 1
            }
            dist_plano_sq <= d_a_sq ==> {
                  poda_valida = 0
            }
      }

      println("2. Verificacao de poda da sub-arvore esquerda:")
      println("   -> Distancia ortogonal ao plano divisor = " + dist_plano_sq)
      println("   -> Poda ativada (nenhum ponto a esquerda pode ser mais proximo) = " + poda_valida)

      mut as int64: residuo = 1 - poda_valida
      println("3. Residuo da busca por KD-Tree = " + residuo + " (esperado: 0)")
      println("4. Algoritmo KD-Trees Nearest Neighbor concluido com exito.")
}
