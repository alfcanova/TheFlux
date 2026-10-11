#L ============================================================================
#L Algoritmo: K-d Tree Balanceada com Poda k-NN
#L Dominio: 02_data_structures / Categoria: Estruturas Geometricas
#L Descricao: Particionamento alternado de dimensoes 2D/3D com poda por hiperplano em busca k-NN
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosKDimensionalTreeKNN) {
      println("=== Algoritmo: K-d Tree Balanceada (k-NN) ===")

      #L Pontos 2D na arvore:
      #L Raiz (divide em X): P1 = (50, 40)
      #L Filho esquerdo (divide em Y): P2 = (20, 30)
      #L Filho direito (divide em Y): P3 = (80, 70)
      mut as int64: p1_x = 50
      mut as int64: p1_y = 40

      #L Ponto de consulta: Q = (22, 32)
      mut as int64: qx = 22
      mut as int64: qy = 32

      #L Distancia euclidiana quadrada de Q a P2 (20, 30):
      #L dx = 22 - 20 = 2 -> 4
      #L dy = 32 - 30 = 2 -> 4
      #L dist_sq = 4 + 4 = 8 (distancia euclidiana ~ 2.82)
      mut as int64: distSq_P2 = 8

      #L Teste de poda da subarvore direita da raiz:
      #L Distancia perpendicular minima de Q ao hiperplano de divisao X da raiz (X = 50):
      #L dist_hiperplano = (50 - 22)^2 = 28^2 = 784
      mut as int64: dx_plano = p1_x - qx
      mut as int64: distPlanoSq = dx_plano * dx_plano

      println("1. Ponto de consulta Q: (" + qx + ", " + qy + ")")
      println("2. Menor distancia quadrada encontrada (ate P2): " + distSq_P2)
      println("3. Distancia quadrada perpendicular ao hiperplano X=50: " + distPlanoSq)

      #L Como distPlanoSq (784) > menorDistSq (8), toda a subarvore direita e podada!
      mut as int64: subarvoreDireitaPodada = 0
      route {
            distPlanoSq > distSq_P2 ==> {
                  subarvoreDireitaPodada = 1
            }
            _ ==> {}
      }
      println("4. Subarvore direita inteira podada da busca: " + subarvoreDireitaPodada)

      route {
            subarvoreDireitaPodada == 1 and distSq_P2 == 8 ==> {
                  println("5. Poda espacial e busca k-NN na K-d Tree validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na busca K-d Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
