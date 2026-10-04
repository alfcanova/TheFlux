#L ============================================================================
#L Algoritmo: Negamax (Minimax com Inversao de Sinal)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo | O(d) espaco linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchNegamax) {
      println("==================================================")
      println("  SciAlgo: Negamax Formulation")
      println("==================================================")

      #L Na formulacao Negamax, a pontuacao de um estado para o jogador atual
      #L e o inverso simetrico da pontuacao para o proximo jogador:
      #L max(a, b) = -min(-a, -b)

      #L Folhas terminais vistas sob a perspectiva do jogador que acabou de mover
      #L Filhos do movimento 1: [4, 7] -> da perspectiva do oponente sao [-4, -7]
      #L Filhos do movimento 2: [2, 9] -> da perspectiva do oponente sao [-2, -9]

      #L Subarvore 1 avaliada por Negamax no nivel 1:
      #L max(-4, -7) = -4. Logo, para a raiz: -(-4) = +4
      mut as int64: s1_child1 = 4
      mut as int64: s1_child2 = 7
      mut as int64: opp_val1 = -1 * s1_child1
      mut as int64: opp_val2 = -1 * s1_child2
      mut as int64: max_sub1 = opp_val1
      route {
            opp_val2 > opp_val1 ==> {
                  max_sub1 = opp_val2
            }
      }
      mut as int64: score_move1 = -1 * max_sub1
      println("1. Pontuacao Negamax para Lance 1: " + score_move1)

      #L Subarvore 2 avaliada por Negamax no nivel 1:
      #L max(-2, -9) = -2. Logo, para a raiz: -(-2) = +2
      mut as int64: s2_child1 = 2
      mut as int64: s2_child2 = 9
      mut as int64: opp2_val1 = -1 * s2_child1
      mut as int64: opp2_val2 = -1 * s2_child2
      mut as int64: max_sub2 = opp2_val1
      route {
            opp2_val2 > opp2_val1 ==> {
                  max_sub2 = opp2_val2
            }
      }
      mut as int64: score_move2 = -1 * max_sub2
      println("2. Pontuacao Negamax para Lance 2: " + score_move2)

      #L Raiz maximiza entre score_move1 e score_move2
      mut as int64: best_score = score_move1
      mut as int64: best_move = 1
      route {
            score_move2 > score_move1 ==> {
                  best_score = score_move2
                  best_move = 2
            }
      }

      println("3. Melhor pontuacao calculada via Negamax: " + best_score)
      println("4. Lance escolhido: " + best_move)
      println("5. Validacao: " + (best_score == 4 and best_move == 1))
      println("==================================================")
}
