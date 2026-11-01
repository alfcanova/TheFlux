#L ============================================================================
#L Algoritmo: Minimax (Teoria dos Jogos de Soma Zero)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo | O(d) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaMinimax) {
      println("==================================================")
      println("  SciAlgo: Minimax Algorithm")
      println("==================================================")

      #L Folhas da arvore de jogo (profundidade 3, 8 folhas)
      #L Nos MAX em nivel 2:
      #L   Subarvore 1 (filhos do no 4): [3, 5]
      #L   Subarvore 2 (filhos do no 5): [6, 9]
      #L   Subarvore 3 (filhos do no 6): [1, 2]
      #L   Subarvore 4 (filhos do no 7): [0, -1]
      mut as list of int64: leaves = [3, 5, 6, 9, 1, 2, 0, -1]
      println("1. Valores das folhas terminais: " + leaves)

      #L Nivel 2: Jogador MAX escolhe o maior de cada par
      #L max(3, 5) = 5; max(6, 9) = 9; max(1, 2) = 2; max(0, -1) = 0
      mut as list of int64: level2 = []
      mut as int64: i = 1
      infinite (i <= 8) {
            mut as int64: val1 = leaves[i]
            mut as int64: val2 = leaves[i + 1]
            mut as int64: mx = val1
            route {
                  val2 > val1 ==> {
                        mx = val2
                  }
            }
            level2 = listPushBack(level2, mx)
            i = i + 2
      }
      println("2. Nivel 2 (Jogador MAX avaliou): " + level2)

      #L Nivel 1: Jogador MIN escolhe o menor de cada par
      #L min(5, 9) = 5; min(2, 0) = 0
      mut as list of int64: level1 = []
      mut as int64: j = 1
      infinite (j <= 4) {
            mut as int64: v1 = level2[j]
            mut as int64: v2 = level2[j + 1]
            mut as int64: mn = v1
            route {
                  v2 < v1 ==> {
                        mn = v2
                  }
            }
            level1 = listPushBack(level1, mn)
            j = j + 2
      }
      println("3. Nivel 1 (Jogador MIN avaliou): " + level1)

      #L Raiz (Nivel 0): Jogador MAX escolhe o maior entre level1[1] e level1[2]
      #L max(5, 0) = 5
      mut as int64: root_val = level1[1]
      mut as int64: best_move = 1
      route {
            level1[2] > level1[1] ==> {
                  root_val = level1[2]
                  best_move = 2
            }
      }

      println("4. Valor Minimax da raiz: " + root_val)
      println("5. Melhor movimento inicial (1=Esquerda, 2=Direita): " + best_move)
      println("6. Validacao: " + (root_val == 5 and best_move == 1))
      println("==================================================")
}
