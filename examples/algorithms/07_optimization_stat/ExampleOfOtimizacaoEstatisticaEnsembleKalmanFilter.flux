#L ============================================================================
#L Algoritmo: EnKF (Ensemble Kalman Filter - Geir Evensen, 1994)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(Iter * N_ens) | Espaco O(N_ens)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaEnsembleKalmanFilter) {
      println("==================================================")
      println("  SciAlgo: Ensemble Kalman Filter (EnKF)")
      println("==================================================")

      #L O EnKF representa a distribuicao de probabilidade por um conjunto (ensemble)
      #L de estados para assimilacao de dados em sistemas nao-lineares de grande porte:
      #L Previsao: propaga cada membro do conjunto x_i pela dinamica
      #L Covariancia empirica: calculada a partir da dispersao dos membros
      #L Analise (Atualizacao): x_i^a = x_i^f + K * (y + v_i - H * x_i^f)

      #L Conjunto inicial de 4 membros (escala x10)
      mut as list of int64: ens = [80, 90, 110, 120] #L media = 100, variancia moderada
      mut as int64: n_ens = 4
      mut as int64: obs_y = 150 #L medicao externa observada
      mut as int64: k_gain = 6  #L ganho de Kalman empirico = 0.6 (escala x10)

      println("1. Conjunto inicial (Forecast):")
      mut as int64: i = 1
      mut as int64: sum_f = 0
      infinite (i <= n_ens) {
            println("   Membro " + i + ": x = " + ens[i])
            sum_f = sum_f + ens[i]
            i = i + 1
      }
      mut as int64: mean_f = sum_f /i n_ens
      println("   Media prevista = " + mean_f + " | Observacao ruidosa y = " + obs_y)

      #L Passo de Analise (Atualizacao EnKF para cada membro)
      println("2. Atualizacao dos membros com o ganho de Kalman K = 0.6:")
      i = 1
      mut as int64: sum_a = 0
      infinite (i <= n_ens) {
            mut as int64: innov = obs_y - ens[i]
            ens[i] = ens[i] + ((k_gain * innov) /i 10)
            println("   Membro " + i + " assimilado: x = " + ens[i])
            sum_a = sum_a + ens[i]
            i = i + 1
      }
      mut as int64: mean_a = sum_a /i n_ens
      println("   Media assimilada final (Analysis) = " + mean_a)

      route {
            mean_a >= 125 and mean_a <= 135 ==> {
                  println("   [PASS] EnKF atualizou os membros convergindo em direcao a observacao!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Ensemble Kalman Filter.")
            }
      }

      println("==================================================")
      println("Ensemble Kalman Filter concluido com sucesso!")
}
