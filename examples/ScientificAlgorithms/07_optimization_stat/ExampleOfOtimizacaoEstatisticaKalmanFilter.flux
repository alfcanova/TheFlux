#L ============================================================================
#L Algoritmo: Kalman Filter (Filtro Linear Gaussiano 1D)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKalmanFilter) {
      println("==================================================")
      println("  SciAlgo: Kalman Filter (Linear 1D Estimator)")
      println("==================================================")

      mut as int64: q_cov = 10
      mut as int64: r_cov = 50
      mut as int64: x_est = 0
      mut as int64: p_est = 100

      mut as list of int64: measurements = [920, 1050, 980, 1020, 1010, 990]
      mut as int64: steps = listLength(measurements)

      println("1. Executando ciclo de Predicao e Atualizacao:")
      mut as int64: t = 1
      infinite (t <= steps) {
            mut as int64: z = measurements[t]
            mut as int64: x_pred = x_est
            mut as int64: p_pred = p_est + q_cov
            mut as int64: k_gain = (p_pred * 1000) /i (p_pred + r_cov)

            x_est = x_pred + ((k_gain * (z - x_pred)) /i 1000)
            p_est = ((1000 - k_gain) * p_pred) /i 1000
            println("   Passo " + t + " | z = " + z + " -> x_est = " + x_est)
            t = t + 1
      }

      println("2. Estado estimado final: " + x_est)
      route {
            x_est >= 980 and x_est <= 1020 ==> {
                  println("   [PASS] Kalman Filter convergiu estavelmente no estado real!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Kalman Filter.")
            }
      }

      println("==================================================")
      println("Kalman Filter concluido com sucesso!")
}
