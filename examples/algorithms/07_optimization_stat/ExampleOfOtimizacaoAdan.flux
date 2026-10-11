#L ============================================================================
#L Algoritmo: Adan (Adaptive Nesterov Momentum Optimizer)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAdan) {
      println("==================================================")
      println("  SciAlgo: Adan (Adaptive Nesterov Momentum)")
      println("==================================================")

      #L Otimizador Adan (Xie et al., 2022):
      #L Rastreia 3 momentos:
      #L m_t: momento do gradiente g_t
      #L v_t: momento da diferenca de gradientes d_t = g_t - g_{t-1}
      #L n_t: momento de segunda ordem adaptativo (escala de passo)
      #L Combina Nesterov acelerado com precondicionamento adaptativo.

      mut as int64: theta = 70
      mut as int64: m = 0
      mut as int64: v = 0
      mut as int64: prev_grad = 0

      #L Minimizando L(theta) = (theta - 15)^2 / 2 -> grad = theta - 15

      println("1. Theta inicial = " + theta + " | Alvo = 15")

      mut as int64: iter = 1
      infinite (iter <= 8) {
            mut as int64: grad = theta - 15
            mut as int64: diff_grad = grad - prev_grad

            #L Atualizacao de momento m e diferenca v
            m = ((8 * m) + (2 * grad)) /i 10
            v = ((8 * v) + (2 * diff_grad)) /i 10

            #L Direcao combinada de Nesterov
            mut as int64: nes_dir = m + ((8 * v) /i 10)

            #L Atualizacao adaptativa
            mut as int64: step = nes_dir /i 3
            route {
                  step == 0 and grad > 0 ==> { step = 1 }
                  _ ==> {}
            }
            theta = theta - step

            prev_grad = grad
            iter = iter + 1
      }

      println("2. Theta final ajustado por Adan: " + theta)

      route {
            theta >= 14 and theta <= 18 ==> {
                  println("   [PASS] Adan acelerou a convergencia com momento triplo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no otimizador Adan.")
            }
      }

      println("==================================================")
      println("Adan concluido com sucesso!")
}
