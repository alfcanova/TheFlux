#L ============================================================================
#L Algoritmo: MFCC — Mel-Frequency Cepstral Coefficients (Extracao Acustica)
#L Dominio: 11_dsp_multimedia / Categoria: Processamento de Voz e Audio
#L Descricao: Banco de filtros triangulares Mel e DCT para representacao de timbre vocal
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPMelFrequencyCepstralCoefficients) {
      println("=== Algoritmo: Mel-Frequency Cepstral Coefficients (MFCC) ===")

      #L Espectro de potencia de um frame de voz (3 bins de frequencia linear FFT):
      #L Bin 1 (baixas frequencias, 300 Hz):   potencia P1 = 800
      #L Bin 2 (formante vocal F1, 1000 Hz):   potencia P2 = 1200
      #L Bin 3 (altas frequencias, 3000 Hz):   potencia P3 = 200
      mut as int64: p1 = 800
      mut as int64: p2 = 1200
      mut as int64: p3 = 200

      println("Espectro de potencia FFT: [P1=" + p1 + ", P2=" + p2 + ", P3=" + p3 + "]")

      #L Estagio 1: Integracao pelo banco de filtros triangulares na Escala Mel:
      #L Filtro Mel 1 (centrado em 500 Hz): peso w1_1 = 80%, w1_2 = 20%
      #L Energia Mel 1: (800 * 80 + 1200 * 20) / 100 = (64000 + 24000) / 100 = 880
      mut as int64: mel_energy_1 = (p1 * 80 + p2 * 20) /i 100

      #L Filtro Mel 2 (centrado em 1500 Hz): peso w2_2 = 70%, w2_3 = 30%
      #L Energia Mel 2: (1200 * 70 + 200 * 30) / 100 = (84000 + 6000) / 100 = 900
      mut as int64: mel_energy_2 = (p2 * 70 + p3 * 30) /i 100

      #L Filtro Mel 3 (centrado em 3000 Hz): peso w3_3 = 90%
      #L Energia Mel 3: (200 * 90) / 100 = 180
      mut as int64: mel_energy_3 = (p3 * 90) /i 100

      println("Energias dos Bancos de Filtros Mel:")
      println("  Banco Mel 1: " + mel_energy_1)
      println("  Banco Mel 2: " + mel_energy_2)
      println("  Banco Mel 3: " + mel_energy_3)

      #L Estagio 2: Compressao Logaritmica (aproximacao inteira de log):
      #L log(880) ~ 678, log(900) ~ 680, log(180) ~ 519 (escala x100)
      mut as int64: log_mel_1 = 678
      mut as int64: log_mel_2 = 680
      mut as int64: log_mel_3 = 519

      #L Estagio 3: Decorrelacao via DCT (coeficientes cepstrais c0 e c1):
      #L c0 (Energia cepstral total): log_mel_1 + log_mel_2 + log_mel_3 = 678 + 680 + 519 = 1877
      #L c1 (Inclinacao espectral / Spectral Tilt): log_mel_1 - log_mel_3 = 678 - 519 = 159
      mut as int64: mfcc_0 = log_mel_1 + log_mel_2 + log_mel_3
      mut as int64: mfcc_1 = log_mel_1 - log_mel_3

      println("Coeficientes MFCC extraidos:")
      println("  MFCC Coeff 0 (Energia do Frame): " + mfcc_0)
      println("  MFCC Coeff 1 (Inclinacao Formantica): " + mfcc_1)

      route {
            mfcc_0 > 1000 and mfcc_1 > 0 ==> {
                  println("Vetor de caracteristicas MFCC robusto e apto para modelo acustico de ASR!")
            }
            _ ==> {
                  println("Falha na extracao MFCC")
            }
      }

      println("MFCC Cepstral Coefficients concluido com sucesso.")
}
