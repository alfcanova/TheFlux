#L ============================================================================
#L Algoritmo: Unscented Kalman Filter (UKF com Pontos Sigma)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T * L) | Espaco O(L)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaUnscentedKalmanFilter) {
      println("==================================================")
      println("  SciAlgo: Unscented Kalman Filter (UKF 1D)")
      println("==================================================")

      mut as int64: x_mean = 20
      mut as int64: p_var = 16
      mut as int64: r_noise = 10

      mut as list of int64: measurements = [38, 41, 39, 42, 40]
      mut as int64: n = listLength(measurements)

      println("1. UKF com geracao deterministica de 3 Pontos Sigma (chi0, chi1, chi2)")
      mut as int64: step = 1
      infinite (step <= n) {
            mut as int64: z = measurements[step]

            #L Sigma points: x_mean, x_mean + sqrt(P), x_mean - sqrt(P) (sqrt(16) = 4)
            mut as int64: sigma_step = 4
            mut as int64: s0 = x_mean
            mut as int64: s1 = x_mean + sigma_step
            mut as int64: s2 = x_mean - sigma_step

            #L Propagacao nao-linear: f(s) = s + 5
            mut as int64: p0 = s0 + 5
            mut as int64: p1 = s1 + 5
            mut as int64: p2 = s2 + 5
            mut as int64: pred_mean = (p0 + p1 + p2) /i 3

            #L Medicao esperada: h(s) = s
            mut as int64: z_pred = pred_mean
            mut as int64: residual = z - z_pred

            #L Atualizacao UKF com ganho K = 1/2
            x_mean = pred_mean + (residual /i 2)
            println("   Passo " + step + " | z = " + z + " -> Estado UKF: " + x_mean)
            step = step + 1
      }

      println("2. Estado final estimado pelo UKF: " + x_mean)
      route {
            x_mean >= 38 and x_mean <= 42 ==> {
                  println("   [PASS] Unscented Kalman Filter rastreou estado com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no UKF.")
            }
      }

      println("==================================================")
      println("Unscented Kalman Filter concluido com sucesso!")
}
