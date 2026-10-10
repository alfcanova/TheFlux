#L ============================================================================
#L Algoritmo: Josephus Problem (Problema de Josephus)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N) tempo | O(1) espaco pela recorrencia analitica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisJosephus) {
      println("==================================================")
      println("  SciAlgo: Josephus Problem")
      println("==================================================")

      mut as int64: n = 7
      mut as int64: k = 3
      println("1. Parametros: N = " + n + " pessoas | Passo K = " + k)

      #L Calculo pela formula analitica de recorrencia (1-based):
      #L J(1, k) = 1
      #L J(i, k) = ((J(i-1, k) + k - 1) % i) + 1
      mut as int64: survivor_formula = 1
      mut as int64: i = 2
      infinite (i <= n) {
            survivor_formula = ((survivor_formula + k - 1) /r i) + 1
            i = i + 1
      }
      println("2. Sobrevivente calculado pela recorrencia: " + survivor_formula)

      #L Simulacao explicita com lista circular de ativos (1 = vivo, 0 = eliminado)
      mut as list of int64: circle = [1, 1, 1, 1, 1, 1, 1]
      mut as list of int64: elimination_order = []
      mut as int64: remaining = n
      mut as int64: current_pos = 0

      infinite (remaining > 1) {
            #L Conta k pessoas vivas
            mut as int64: count = 0
            infinite (count < k) {
                  current_pos = (current_pos /r n) + 1
                  route {
                        circle[current_pos] == 1 ==> {
                              count = count + 1
                        }
                  }
            }

            #L Elimina a k-esima pessoa
            circle[current_pos] = 0
            elimination_order = listPushBack(elimination_order, current_pos)
            remaining = remaining - 1
      }

      #L Localiza o unico sobrevivente na simulacao
      mut as int64: survivor_sim = 0
      mut as int64: check_idx = 1
      infinite (check_idx <= n) {
            route {
                  circle[check_idx] == 1 ==> {
                        survivor_sim = check_idx
                        break
                  }
            }
            check_idx = check_idx + 1
      }

      println("3. Ordem das eliminacoes na simulacao: " + elimination_order)
      println("4. Sobrevivente final da simulacao: " + survivor_sim)
      println("5. Validacao: " + (survivor_formula == 4 and survivor_sim == 4))
      println("==================================================")
}
