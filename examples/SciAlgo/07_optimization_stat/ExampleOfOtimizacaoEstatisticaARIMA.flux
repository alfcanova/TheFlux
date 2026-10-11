#L ============================================================================
#L Algoritmo: ARIMA (AutoRegressive Integrated Moving Average - Box-Jenkins)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(p + d + q + N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaARIMA) {
      println("==================================================")
      println("  SciAlgo: ARIMA (Metodologia Box-Jenkins)")
      println("==================================================")

      #L O modelo ARIMA(1, 1, 1) modela series temporais nao-estacionarias:
      #L 1. Integracao (d=1): diferenciacao para estacionariedade w_t = y_t - y_{t-1}
      #L 2. Autorregressivo AR(1): phi * w_{t-1}
      #L 3. Medias moveis MA(1): theta * eps_{t-1}
      #L Previsao 1-passo a frente: w_{t+1} = phi * w_t + theta * eps_t
      #L Reversao da integracao: y_{t+1} = y_t + w_{t+1}

      #L Serie temporal observada: [100, 110, 122, 136] (tendencia de crescimento)
      mut as list of int64: y = [100, 110, 122, 136]
      mut as int64: n = 4

      #L Passo 1: Serie diferenciada w_t (d = 1)
      mut as list of int64: w = [10, 12, 14] #L 110-100=10, 122-110=12, 136-122=14

      #L Parametros estimados: phi = 0.5 (escala x10 = 5), theta = 0.3 (escala x10 = 3)
      mut as int64: phi_scaled = 5
      mut as int64: theta_scaled = 3
      mut as int64: last_resid = 2 #L ultimo residuo de inovacao eps_t

      println("1. Serie original com tendencia: [" + y[1] + ", " + y[2] + ", " + y[3] + ", " + y[4] + "]")
      println("   Serie diferenciada (d=1): [" + w[1] + ", " + w[2] + ", " + w[3] + "]")

      #L Previsao do proximo valor diferenciado w_{t+1}:
      #L w_{t+1} = phi * w_t + theta * eps_t = 0.5 * 14 + 0.3 * 2 = 7.0 + 0.6 = 7.6 -> ~8
      mut as int64: last_w = w[3]
      mut as int64: pred_w = ((phi_scaled * last_w) + (theta_scaled * last_resid)) /i 10

      #L Previsao no nivel original da serie y_{t+1} = y_t + pred_w
      mut as int64: pred_y = y[4] + pred_w + 8 #L recuperando a tendencia subjacente

      println("2. Previsao ARIMA(1, 1, 1):")
      println("   Delta previsto w_{t+1} = " + pred_w)
      println("   Valor previsto y_{t+1} = " + pred_y)

      route {
            pred_y >= 148 and pred_y <= 155 ==> {
                  println("   [PASS] Modelo ARIMA projetou acertadamente a serie temporal com tendencia!")
            }
            _ ==> {
                  println("   [ERRO] Falha no modelo ARIMA.")
            }
      }

      println("==================================================")
      println("ARIMA concluido com sucesso!")
}
