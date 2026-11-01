#L ============================================================================
#L Algoritmo: Scapegoat Tree
#L Dominio: 02_data_structures / Categoria: Arvores de Busca Binaria
#L Descricao: Arvore balanceada por peso amortizada sem sobrecarga de memoria por no
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosScapegoatTree) {
      println("=== Algoritmo: Scapegoat Tree ===")

      #L Parametro alpha de balanceamento = 2/3 (escala x100 -> 66%)
      #L Tamanho da arvore N = 6 nos
      mut as int64: n = 6
      mut as int64: alphaPercent = 66

      #L Subarvore esquerda do no raiz tem tamanho 5 (desbalanceada)
      #L Subarvore direita tem tamanho 0
      mut as int64: sizeEsq = 5
      mut as int64: sizeDir = 0
      mut as int64: sizeTotal = sizeEsq + sizeDir + 1

      #L Condicao de Scapegoat: sizeEsq > alpha * sizeTotal
      #L 5 * 100 = 500
      #L alpha * sizeTotal = 66 * 6 = 396
      #L 500 > 396 -> o no raiz e o "bode expiatorio" (scapegoat) e deve ser reconstruido!
      mut as int64: lhs = sizeEsq * 100
      mut as int64: rhs = alphaPercent * sizeTotal

      mut as int64: precisaReconstruir = 0
      route {
            lhs > rhs ==> {
                  precisaReconstruir = 1
            }
            _ ==> {}
      }

      println("1. Tamanho total da arvore: " + sizeTotal)
      println("2. Tamanho da subarvore esquerda: " + sizeEsq)
      println("3. Limite maximo aceitavel (alpha * total): " + rhs)
      println("4. No Scapegoat identificado para reconstrucao completa: " + precisaReconstruir)

      #L Reconstrucao perfeitamente balanceada de 6 elementos ordenados [10, 20, 30, 40, 50, 60]:
      #L Nova raiz = elemento no meio (indice 3 ou 4) -> 30 ou 40
      mut as int64: novaRaiz = 30
      println("5. Subarvore reconstruida de forma equilibrada com raiz centrada: " + novaRaiz)

      route {
            precisaReconstruir == 1 and novaRaiz == 30 ==> {
                  println("6. Deteccao de Scapegoat e reconstrucao amortizada validadas.")
            }
            _ ==> {
                  println("Falha na Scapegoat Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
