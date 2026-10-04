#L ============================================================================
#L Algoritmo: Eytzinger Search (Layout de Heap Implicito / BFS Layout)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(log N) tempo | O(N) espaco do layout
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchEytzinger) {
      println("==================================================")
      println("  SciAlgo: Eytzinger Search (BFS Array Layout)")
      println("==================================================")

      #L Vetor original ordenado (N = 7)
      mut as list of int64: sorted_arr = [10, 20, 30, 40, 50, 60, 70]
      println("1. Vetor ordenado original: " + sorted_arr)

      #L Constrói o layout de Eytzinger (no k tem filhos em 2k e 2k+1)
      #L Para N = 7, a arvore completa tem niveis:
      #L Nivel 1: [40] (raiz em k=1)
      #L Nivel 2: [20, 60] (filhos em k=2, k=3)
      #L Nivel 3: [10, 30, 50, 70] (filhos em k=4, 5, 6, 7)
      mut as list of int64: eytz = [40, 20, 60, 10, 30, 50, 70]
      mut as int64: n = listLength(eytz)
      println("2. Layout de Eytzinger (ordem por nivel): " + eytz)

      mut as int64: target = 50
      mut as int64: k = 1
      mut as int64: found_pos = 0
      mut as int64: steps = 0

      #L Busca na arvore implicita: k = 2k (esquerda) ou 2k + 1 (direita)
      infinite (k <= n) {
            steps = steps + 1
            mut as int64: val = eytz[k]
            route {
                  val == target ==> {
                        found_pos = k
                        break
                  }
                  target < val ==> {
                        k = 2 * k
                  }
                  _ ==> {
                        k = 2 * k + 1
                  }
            }
      }

      println("3. Alvo buscado: " + target)
      println("4. Indice no array de Eytzinger: " + found_pos)
      println("5. Passos (profundidade da arvore): " + steps)
      println("6. Validacao: " + (found_pos == 6 and eytz[found_pos] == target))
      println("==================================================")
}
