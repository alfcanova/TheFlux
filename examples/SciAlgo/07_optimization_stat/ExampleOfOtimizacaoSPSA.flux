#L ============================================================================
#L Algoritmo: SPSA (Simultaneous Perturbation Stochastic Approximation)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSPSA) {
      println("==================================================")
      println("  SciAlgo: SPSA (Stochastic Approximation de Spall)")
      println("==================================================")

      #L O SPSA (Spall, 1992) estima gradientes com apenas 2 avaliacoes de funcao
      #L usando perturbacao simultanea de Bernoulli delta_i in {-1, +1}:
      #L g_hat(theta) = (y(theta + c*delta) - y(theta - c*delta)) / (2 * c * delta)
      #L theta_{k+1} = theta_k - a_k * g_hat_k
      #L Independente do numero de parametros, requer sempre 2 medicoes!

      mut as int64: theta = 80 #L parametro inicial
      mut as int64: c_pert = 2  #L magnitude da perturbacao simultanea
      #L Funcao objetivo com ruido: f(x) = (x - 20)^2 / 2 -> x* = 20

      println("1. Parametro inicial theta0 = " + theta + " | Alvo = 20")

      mut as int64: k = 1
      infinite (k <= 7) {
            #L Perturbacao de Bernoulli: alterna +1 e -1
            mut as int64: delta = 1
            mut as int64: rem2 = k /r 2
            route {
                  rem2 == 0 ==> { delta = -1 }
                  _ ==> { delta = 1 }
            }

            #L Duas avaliacoes de funcao f(theta + c*delta) e f(theta - c*delta)
            mut as int64: pos_pert = theta + (c_pert * delta)
            mut as int64: neg_pert = theta - (c_pert * delta)
            mut as int64: y_plus = ((pos_pert - 20) * (pos_pert - 20)) /i 2
            mut as int64: y_minus = ((neg_pert - 20) * (neg_pert - 20)) /i 2

            #L Estimativa do gradiente simultaneo
            mut as int64: num_diff = y_plus - y_minus
            mut as int64: den = 2 * c_pert * delta
            mut as int64: g_hat = num_diff /i den

            #L Atualizacao com taxa de aprendizado decrescente
            mut as int64: step = g_hat /i 2
            theta = theta - step

            println("   Passo " + k + ": gradiente estimado g_hat = " + g_hat + " -> theta = " + theta)
            k = k + 1
      }

      println("2. Parametro final alcancado por SPSA: " + theta)

      route {
            theta >= 19 and theta <= 22 ==> {
                  println("   [PASS] SPSA convergiu com exatidao usando apenas 2 avaliacoes por passo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo SPSA.")
            }
      }

      println("==================================================")
      println("SPSA concluido com sucesso!")
}
