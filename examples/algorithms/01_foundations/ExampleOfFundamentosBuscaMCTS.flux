#L ============================================================================
#L Algoritmo: Monte Carlo Tree Search (MCTS - 4 Fases UCB1)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: Conforme numero de simulacoes (anytime algorithm)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaMCTS) {
      println("==================================================")
      println("  SciAlgo: Monte Carlo Tree Search (MCTS)")
      println("==================================================")

      #L Raiz tem 2 lances possiveis: Acao 1 e Acao 2
      #L Estatisticas dos nos filhos: [visitas N, vitorias W]
      mut as int64: n_simulations = 10
      mut as int64: visits_1 = 0
      mut as int64: wins_1 = 0
      mut as int64: visits_2 = 0
      mut as int64: wins_2 = 0

      #L Simula 10 iteracoes MCTS: Selecao -> Expansao -> Simulacao -> Backprop
      #L Acao 1 tem taxa real de vitoria de 80%, Acao 2 tem 30%
      #L Gerador pseudoaleatorio LCG simples para rollouts deterministicos
      mut as int64: seed = 42
      mut as int64: sim = 1

      infinite (sim <= n_simulations) {
            #L 1. SELECAO: se algum no nao foi visitado, escolhe-o; senao escolhe por UCB1 aproximado
            mut as int64: selected_action = 1
            route {
                  visits_1 == 0 ==> {
                        selected_action = 1
                  }
                  visits_2 == 0 ==> {
                        selected_action = 2
                  }
                  _ ==> {
                        #L Proporcao de vitorias W / N multiplicada por 100
                        mut as int64: q1 = (wins_1 * 100) /i visits_1
                        mut as int64: q2 = (wins_2 * 100) /i visits_2
                        route {
                              q2 > q1 ==> {
                                    selected_action = 2
                              }
                        }
                  }
            }

            #L 2. EXPANSAO & 3. SIMULACAO (Rollout)
            #L Gera resultado da simulacao com base na taxa intrinseca
            seed = (1664525 * seed + 1013904223) /r 2147483647
            route { seed < 0 ==> { seed = seed * -1 } }
            mut as int64: roll = seed /r 100

            mut as int64: win_result = 0
            route {
                  selected_action == 1 ==> {
                        #L Taxa favoravel de 80%
                        route {
                              roll < 80 ==> {
                                    win_result = 1
                              }
                        }
                  }
                  _ ==> {
                        #L Taxa de 30%
                        route {
                              roll < 30 ==> {
                                    win_result = 1
                              }
                        }
                  }
            }

            #L 4. BACKPROPAGATION: atualiza visitas e vitorias
            route {
                  selected_action == 1 ==> {
                        visits_1 = visits_1 + 1
                        wins_1 = wins_1 + win_result
                  }
                  _ ==> {
                        visits_2 = visits_2 + 1
                        wins_2 = wins_2 + win_result
                  }
            }

            sim = sim + 1
      }

      println("1. Estatisticas apos " + n_simulations + " iteracoes MCTS:")
      println("   Acao 1: Visitas N = " + visits_1 + " | Vitorias W = " + wins_1)
      println("   Acao 2: Visitas N = " + visits_2 + " | Vitorias W = " + wins_2)

      #L Decisao final da raiz: escolhe o lance mais robusto (mais visitado)
      mut as int64: best_move = 1
      route {
            visits_2 > visits_1 ==> {
                  best_move = 2
            }
      }

      println("2. Lance mais robusto escolhido pelo MCTS: Acao " + best_move)
      println("3. Validacao: " + (visits_1 + visits_2 == n_simulations and best_move == 1))
      println("==================================================")
}
