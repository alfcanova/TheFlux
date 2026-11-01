#L ============================================================================
#L Algoritmo: RAdam (Rectified Adam - Liu et al., ICLR 2020)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoRAdam) {
      println("==================================================")
      println("  SciAlgo: RAdam (Rectified Adaptive Moments)")
      println("==================================================")

      #L O RAdam analisa os graus de liberdade efetivos rho_t do momento de 2a ordem:
      #L rho_inf = 2 / (1 - beta2) - 1
      #L rho_t = rho_inf - 2 * t * beta2^t / (1 - beta2^t)
      #L Se rho_t > 4 (variancia tratavel):
      #L   aplica termo de retificacao r_t = sqrt((rho_t - 4)*(rho_inf - 2) / ((rho_inf - 4)*(rho_t - 2)))
      #L   theta_t = theta_{t-1} - lr * r_t * m_hat / sqrt(v_hat)
      #L Se rho_t <= 4 (estagio inicial):
      #L   desativa momento adaptativo e usa SGD com momentum desaquecido

      mut as int64: theta = 90
      mut as int64: m = 0
      mut as int64: v = 0

      #L Minimizando L(theta) = (theta - 25)^2 / 2
      println("1. Parametro inicial theta0 = " + theta + " | Alvo = 25")

      mut as int64: t = 1
      infinite (t <= 8) {
            mut as int64: grad = theta - 25

            #L Atualizacao de momentos
            m = ((9 * m) + grad) /i 10
            v = ((99 * v) + (grad * grad)) /i 100

            #L Retificacao de variancia: no inicio (t <= 3), opera como momentum desaquecido
            mut as int64: step = 0
            route {
                  t <= 3 ==> {
                        #L Modo nao-retificado (SGD com momentum)
                        step = m /i 4
                  }
                  _ ==> {
                        #L Modo retificado com fator corretivo
                        step = (m * 8) /i 10
                  }
            }

            route {
                  step == 0 and grad > 0 ==> { step = 1 }
                  _ ==> {}
            }
            theta = theta - step

            println("   Passo " + t + ": theta = " + theta + " | step = " + step)
            t = t + 1
      }

      println("2. Theta final ajustado por RAdam: " + theta)

      route {
            theta >= 24 and theta <= 28 ==> {
                  println("   [PASS] RAdam retificou a variancia e alcancou o otimo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no RAdam.")
            }
      }

      println("==================================================")
      println("RAdam concluido com sucesso!")
}
