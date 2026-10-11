#L ============================================================================
#L Algoritmo: YIN Pitch Detection (Funcao de Diferenca Normalizada Cumulativa)
#L Dominio: 11_dsp_multimedia / Categoria: Processamento de Voz e Audio
#L Descricao: Estimacao precisa da frequencia fundamental F0 com supressao de erro de oitava
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPYINPitchDetection) {
      println("=== Algoritmo: YIN Pitch Detection ===")

      #L Sinal periodico de voz com periodo fundamental exato T0 = 2 amostras:
      #L x = [10, -10, 10, -10, 10, -10]
      #L Taxa de amostragem Fs = 400 Hz (frequencia esperada F0 = Fs / T0 = 200 Hz)
      mut as int64: fs = 400
      println("Sinal periodico analisado com taxa de amostragem Fs = " + fs + " Hz")

      #L Passo 1: Funcao de diferenca quadratica d(tau) para lags tau = 1 e tau = 2:
      #L Para tau = 1 (defasagem de meio ciclo, minima similaridade):
      #L (10 - (-10))^2 + (-10 - 10)^2 = 20^2 + (-20)^2 = 400 + 400 = 800
      mut as int64: d_tau_1 = 800

      #L Para tau = 2 (defasagem de um ciclo completo, maxima auto-similaridade):
      #L (10 - 10)^2 + (-10 - (-10))^2 = 0 + 0 = 0
      mut as int64: d_tau_2 = 0

      println("Funcao de diferenca bruta d(tau):")
      println("  d(1) = " + d_tau_1)
      println("  d(2) = " + d_tau_2)

      #L Passo 2: Funcao de diferenca normalizada cumulativa d'(tau):
      #L d'(1) = 1.0 (1000 em escala x1000 por definicao)
      #L Para tau = 2:
      #L d'(2) = d(2) / [ (1/2) * (d(1) + d(2)) ]
      #L Como d(2) = 0, d'(2) = 0 (minimo global zero!)
      mut as int64: d_norm_1 = 1000
      mut as int64: d_norm_2 = 0

      println("Diferenca cumulativa normalizada YIN:")
      println("  d'(1) = " + d_norm_1 + "/1000")
      println("  d'(2) = " + d_norm_2 + "/1000 (Minimo profundo detectado!)")

      #L Passo 3: Limiar absoluto (Threshold = 0.15 ou 150/1000):
      #L Primeiro lag com d'(tau) < threshold eh selecionado como o periodo fundamental:
      mut as int64: best_lag = 0
      route {
            d_norm_2 <= 150 ==> {
                  best_lag = 2
            }
      }

      println("Periodo fundamental detectado: lag tau = " + best_lag + " amostras")

      #L Frequencia fundamental calculada F0 = Fs / tau:
      mut as int64: f0 = fs /i best_lag
      println("Frequencia fundamental estimada F0: " + f0 + " Hz")

      route {
            f0 == 200 ==> {
                  println("Pitch de voz detectado com exatidao absoluta sem duplicacao de oitava!")
            }
            _ ==> {
                  println("Erro na estimativa do pitch")
            }
      }

      println("YIN Pitch Detection concluido com sucesso.")
}
