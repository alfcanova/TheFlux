#L ============================================================================
#L Algoritmo: Lion Optimizer (EvoLved Sign Momentum - Chen et al., Google 2023)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoLion) {
      println("==================================================")
      println("  SciAlgo: Lion Optimizer (Sign Momentum)")
      println("==================================================")

      #L Otimizador descoberto por busca automatica no Google Brain:
      #L 1. c_t = sign(beta1 * m_{t-1} + (1 - beta1) * g_t)
      #L 2. theta_t = theta_{t-1} - lr * c_t - lr * wd * theta_{t-1}
      #L 3. m_t = beta2 * m_{t-1} + (1 - beta2) * g_t
      #L Mais eficiente em memoria que Adam por rastrear apenas o momento m.

      mut as int64: theta = 80 #L parametro inicial
      mut as int64: m = 0      #L buffer de momento
      #L Hiperparametros: beta1 = 0.9 (9/10), beta2 = 0.99 (99/100)
      #L Funcao de perda: L(theta) = (theta - 20)^2 / 2 -> grad = theta - 20

      println("1. Parametros iniciais:")
      println("   Theta0 = " + theta + " | Alvo teorico = 20")

      mut as int64: iter = 1
      infinite (iter <= 10) {
            mut as int64: grad = theta - 20

            #L Combinacao interpolada de momento: inter = 0.9 * m + 0.1 * grad
            mut as int64: update_dir = ((9 * m) + grad) /i 10

            #L Operacao Sign
            mut as int64: sign_val = 0
            route {
                  update_dir > 0 ==> { sign_val = 1 }
                  update_dir < 0 ==> { sign_val = -1 }
                  _ ==> { sign_val = 0 }
            }

            #L Atualizacao com passo fixo (lr = 6)
            theta = theta - (6 * sign_val)

            #L Atualizacao do momento m: m = 0.9 * m + 0.1 * grad
            m = ((9 * m) + grad) /i 10

            iter = iter + 1
      }

      println("2. Theta final alcancado por Lion: " + theta)

      route {
            theta >= 18 and theta <= 25 ==> {
                  println("   [PASS] Lion convergiu estavelmente via operacao Sign!")
            }
            _ ==> {
                  println("   [ERRO] Falha na convergencia do Lion.")
            }
      }

      println("==================================================")
      println("Lion Optimizer concluido com sucesso!")
}
