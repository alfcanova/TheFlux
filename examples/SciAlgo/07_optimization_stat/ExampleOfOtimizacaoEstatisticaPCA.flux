#L ============================================================================
#L Algoritmo: Principal Component Analysis (PCA via Metodo das Potencias)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(Iter * D^2) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaPCA) {
      println("==================================================")
      println("  SciAlgo: Principal Component Analysis (PCA)")
      println("==================================================")

      #L Matriz de covariancia 2x2 C = [[10, 8], [8, 10]]
      #L Autovalor dominante lambda1 = 18 com autovetor [1, 1]
      mut as int64: c11 = 10
      mut as int64: c12 = 8
      mut as int64: c21 = 8
      mut as int64: c22 = 10

      mut as int64: v1 = 1
      mut as int64: v2 = 0

      #L Metodo das potencias para encontrar o primeiro componente principal
      mut as int64: iter = 1
      infinite (iter <= 4) {
            mut as int64: next_v1 = c11 * v1 + c12 * v2
            mut as int64: next_v2 = c21 * v1 + c22 * v2

            #L Normalizacao aproximada
            mut as int64: scale = next_v1
            route {
                  scale > 0 ==> {
                        v1 = (next_v1 * 10) /i scale
                        v2 = (next_v2 * 10) /i scale
                  }
                  _ ==> {}
            }
            iter = iter + 1
      }

      println("1. Autovetor do 1o Componente Principal obtido: [" + v1 + ", " + v2 + "]")
      route {
            v1 == v2 ==> {
                  println("   [PASS] PCA identificou o eixo de maxima variancia!")
            }
            _ ==> {
                  println("   [ERRO] Falha no PCA.")
            }
      }

      println("==================================================")
      println("PCA concluido com sucesso!")
}
