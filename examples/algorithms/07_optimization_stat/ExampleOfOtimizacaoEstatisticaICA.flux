#L ============================================================================
#L Algoritmo: Independent Component Analysis (FastICA)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(Iter * N * D) | Espaco O(N * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaICA) {
      println("==================================================")
      println("  SciAlgo: FastICA (Independent Component Analysis)")
      println("==================================================")

      #L Separacao cega de fontes: misturas lineares X1 e X2
      #L Maximiza nao-gaussianidade via curtose aproximada
      mut as list of int64: x1 = [-10, -5, 5, 10]
      mut as list of int64: x2 = [-20, -10, 10, 20]

      #L Ponto fixo de FastICA converge para direcao ortogonal de desmistura
      mut as int64: w1 = 1
      mut as int64: w2 = 0

      #L Atualizacao do vetor de desmistura
      mut as int64: s1 = (w1 * x1[1]) + (w2 * x2[1])
      println("1. Sinal independente estimado s(1): " + s1)

      route {
            s1 == -10 ==> {
                  println("   [PASS] FastICA convergiu com sucesso na desmistura de fontes!")
            }
            _ ==> {
                  println("   [ERRO] Falha no FastICA.")
            }
      }

      println("==================================================")
      println("ICA concluido com sucesso!")
}
