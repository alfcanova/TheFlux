#L ============================================================================
#L Algoritmo: MTD(f) (Memory-enhanced Test Driver com valor f - Plaat 1996)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^(d/2)) superior ao Alpha-Beta tradicional
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaMTDf) {
      println("==================================================")
      println("  SciAlgo: MTD(f) Algorithm (Aske Plaat 1996)")
      println("==================================================")

      #L O valor minimax exato da posicao hipotetica e 7
      mut as int64: true_minimax_value = 7

      #L Palpite inicial f (geralmente da iteracao anterior em iterative deepening)
      mut as int64: f = 0
      mut as int64: lowerbound = -9999
      mut as int64: upperbound = 9999
      mut as int64: iterations = 0

      println("1. Palpite inicial f = " + f + " | Limites: [" + lowerbound + ", " + upperbound + "]")

      infinite (lowerbound < upperbound and iterations < 10) {
            iterations = iterations + 1
            mut as int64: beta = f
            route {
                  f == lowerbound ==> {
                        beta = f + 1
                  }
            }

            #L Simula o resultado da busca de janela nula [beta - 1, beta]
            #L Se true_value >= beta: busca falha alto e retorna >= beta
            #L Se true_value < beta: busca falha baixo e retorna < beta
            mut as int64: g = 0
            route {
                  true_minimax_value >= beta ==> {
                        g = true_minimax_value #L Falha alto
                  }
                  _ ==> {
                        g = true_minimax_value #L Falha baixo
                  }
            }

            route {
                  g < beta ==> {
                        upperbound = g
                  }
                  _ ==> {
                        lowerbound = g
                  }
            }

            f = g
            println("  Iteracao " + iterations + " | Teste beta=" + beta + " -> ret=" + g + " | Intervalo: [" + lowerbound + ", " + upperbound + "]")
      }

      println("2. Valor minimax exato convergido por MTD(f): " + f)
      println("3. Total de testes de janela nula executados: " + iterations)
      println("4. Validacao: " + (f == 7 and lowerbound == upperbound))
      println("==================================================")
}
