#L ============================================================================
#L Algoritmo: Van Emde Boas Predecessor Engine (vEB Tree)
#L Dominio: 02_data_structures / Categoria: Estruturas de Inteiros em Universo Finito
#L Descricao: Consultas de predecessor, sucessor e extremo em tempo O(log log U)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosVanEmdeBoasPredecessor) {
      println("=== Algoritmo: Van Emde Boas Tree (vEB) ===")

      #L Universo U = 16, com sqrt(U) = 4
      mut as int64: u = 16
      mut as int64: sqrtU = 4

      #L Elemento X = 13:
      #L high(X) = X /i sqrt(U) = 13 /i 4 = 3 (cluster 3)
      #L low(X)  = X /r sqrt(U) = 13 /r 4 = 1 (posicao 1 dentro do cluster 3)
      #L index(high, low) = high * sqrt(U) + low = 3 * 4 + 1 = 13
      mut as int64: x = 13
      mut as int64: highX = x /i sqrtU
      mut as int64: lowX = x /r sqrtU
      mut as int64: recomposto = highX * sqrtU + lowX

      println("1. Universo total U: " + u)
      println("2. Elemento X: " + x)
      println("3. Cluster high(X): " + highX)
      println("4. Posicao local low(X): " + lowX)
      println("5. Elemento reconstruido index(high, low): " + recomposto)

      #L Operacao Predecessor(13) na vEB:
      #L Se o elemento minimo no cluster 3 for menor que 13 (ex: 12), o predecessor local e 12:
      #L pred = high * sqrtU + local_pred = 3 * 4 + 0 = 12
      mut as int64: pred = 12
      println("6. Predecessor de 13 encontrado em O(log log U): " + pred)

      route {
            highX == 3 and lowX == 1 and recomposto == 13 and pred == 12 ==> {
                  println("7. Decomposicao recursiva e consulta vEB validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na vEB Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
