#L ============================================================================
#L Algoritmo: Extended Kalman Filter (EKF com Observacao Nao-Linear)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaExtendedKalmanFilter) {
      println("==================================================")
      println("  SciAlgo: Extended Kalman Filter (EKF 1D)")
      println("==================================================")

      mut as int64: q_proc = 5
      mut as int64: r_meas = 20
      mut as int64: x_est = 30
      mut as int64: p_est = 200

      mut as list of int64: measurements_z = [22, 26, 24, 25, 27]
      mut as int64: n = listLength(measurements_z)

      println("1. Estado inicial estimado: " + x_est + " | h(x) = x^2 / 100")
      mut as int64: step = 1
      infinite (step <= n) {
            mut as int64: z = measurements_z[step]
            mut as int64: x_pred = x_est
            mut as int64: p_pred = p_est + q_proc

            mut as int64: h_x = (x_pred * x_pred) /i 100
            mut as int64: jacobian_h = 2 * x_pred

            mut as int64: denom = (((jacobian_h * jacobian_h) /i 100) * p_pred) /i 100 + r_meas
            mut as int64: k_gain = ((p_pred * jacobian_h) /i 100) /i denom

            mut as int64: residual = z - h_x
            x_est = x_pred + (k_gain * residual)
            p_est = p_pred - (((k_gain * jacobian_h) /i 100) * p_pred)

            println("   Passo " + step + " | z = " + z + " -> x_est = " + x_est)
            step = step + 1
      }

      println("2. Estado estimado final pelo EKF: " + x_est)
      route {
            x_est >= 45 and x_est <= 55 ==> {
                  println("   [PASS] Extended Kalman Filter linearizou e rastreou o estado real!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no EKF.")
            }
      }

      println("==================================================")
      println("Extended Kalman Filter concluido com sucesso!")
}
