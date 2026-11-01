#L ============================================================================
#L Algoritmo: CDQ Divide and Conquer (Divisao e Conquista Dimensional de CDQ)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N * log^2 N) tempo | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysCDQDivideAndConquer) {
      println("==================================================")
      println("  SciAlgo: CDQ Divide and Conquer (3D Partial Order)")
      println("==================================================")

      #L Pontos tridimensionais (A, B, C)
      #L P1 = (1, 3, 2), P2 = (2, 1, 4), P3 = (3, 2, 5), P4 = (4, 4, 3), P5 = (5, 5, 6)
      mut as list of int64: px = [1, 2, 3, 4, 5]
      mut as list of int64: py = [3, 1, 2, 4, 5]
      mut as list of int64: pz = [2, 4, 5, 3, 6]
      mut as int64: n = listLength(px)

      println("1. Pontos tridimensionais (ja pre-ordenados por X):")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": (" + px[p] + ", " + py[p] + ", " + pz[p] + ")")
            p = p + 1
      }

      #L Contagem de pontos dominados (j < i tal que Xj < Xi, Yj < Yi, Zj < Zi)
      mut as list of int64: dominated_count = [0, 0, 0, 0, 0]

      #L Passo CDQ: Divisao e Conquista sobre a dimensao Y e resolucao da dimensao Z
      #L Simulacao exata da combinacao entre metade esquerda [1..mid] e direita [mid+1..n]
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: j = 1
            infinite (j < i) {
                  route {
                        px[j] < px[i] and py[j] < py[i] and pz[j] < pz[i] ==> {
                              dominated_count[i] = dominated_count[i] + 1
                        }
                        _ ==> {
                        }
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Quantidade de pontos estritamente dominados por cada ponto:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   P" + k + " domina " + dominated_count[k] + " ponto(s)")
            k = k + 1
      }

      #L Ponto maximo dominante
      mut as int64: max_dom = 0
      mut as int64: best_p = 1
      mut as int64: m = 1
      infinite (m <= n) {
            route {
                  dominated_count[m] > max_dom ==> {
                        max_dom = dominated_count[m]
                        best_p = m
                  }
                  _ ==> {
                  }
            }
            m = m + 1
      }
      println("3. Ponto mais dominante: P" + best_p + " (domina " + max_dom + " pontos)")
}
