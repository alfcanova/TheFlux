#L ============================================================================
#L Algoritmo: Alpha-Beta Pruning (Poda Alfa-Beta)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^(d/2)) no melhor caso ordenado | O(d) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaAlphaBeta) {
      println("==================================================")
      println("  SciAlgo: Alpha-Beta Pruning")
      println("==================================================")

      #L Arvore de jogo:
      #L Raiz (MAX)
      #L   Subarvore B (MIN): Folhas [3, 5]
      #L   Subarvore C (MIN): Folhas [2, 99 (deve ser podado!)]

      mut as int64: alpha = -9999
      mut as int64: beta = 9999

      mut as int64: evaluated_nodes = 0
      mut as int64: pruned_nodes = 0

      #L Avaliacao da Subarvore B (MIN)
      #L Filho B1 = 3
      evaluated_nodes = evaluated_nodes + 1
      mut as int64: val_b = 3
      route {
            val_b < beta ==> {
                  beta = val_b
            }
      }

      #L Filho B2 = 5
      evaluated_nodes = evaluated_nodes + 1
      #L min(3, 5) permanece 3
      mut as int64: b_result = 3

      #L Raiz (MAX) atualiza alpha com o resultado de B
      route {
            b_result > alpha ==> {
                  alpha = b_result #L alpha = 3
            }
      }
      println("1. Subarvore B avaliada com valor: " + b_result + " | Novo alpha na raiz: " + alpha)

      #L Avaliacao da Subarvore C (MIN) com alpha = 3 e beta = 9999
      mut as int64: beta_c = 9999
      #L Filho C1 = 2
      evaluated_nodes = evaluated_nodes + 1
      mut as int64: val_c1 = 2
      route {
            val_c1 < beta_c ==> {
                  beta_c = val_c1 #L beta_c = 2
            }
      }

      #L Condicao de Poda Alfa-Beta: beta_c <= alpha
      mut as bool: cutoff_occurred = false
      route {
            beta_c <= alpha ==> {
                  cutoff_occurred = true
                  pruned_nodes = pruned_nodes + 1
                  println("2. Poda Alfa-Beta acionada em C! beta (" + beta_c + ") <= alpha (" + alpha + ")")
                  println("   No folha [99] foi PODADO com sucesso sem ser avaliado!")
            }
      }

      #L Valor final da raiz e max(B, C_garantido) = 3
      mut as int64: final_val = alpha

      println("3. Valor Minimax final calculado com poda: " + final_val)
      println("4. Folhas avaliadas: " + evaluated_nodes + " | Folhas podadas: " + pruned_nodes)
      println("5. Validacao: " + (cutoff_occurred and final_val == 3 and pruned_nodes == 1))
      println("==================================================")
}
