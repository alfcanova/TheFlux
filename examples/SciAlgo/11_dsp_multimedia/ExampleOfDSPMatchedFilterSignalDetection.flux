#L ============================================================================
#L Algoritmo: Filtro Casado (Matched Filter - Deteccao Otima de Sinais em Ruido)
#L Dominio: 11_dsp_multimedia / Categoria: Deteccao de Sinais e Telecomunicacoes
#L Descricao: Maximiza a relacao sinal-ruido (SNR) por correlacao com pulso conhecido
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPMatchedFilterSignalDetection) {
      println("=== Algoritmo: Matched Filter (Filtro Casado) ===")

      #L Forma de onda do pulso de transmissao conhecido s (tamanho L = 3):
      #L s = [10, 20, 10]
      #L Resposta ao impulso do filtro casado: h[n] = s[L - 1 - n]
      #L h = [10, 20, 10] (pulso simetrico)
      mut as int64: s0 = 10
      mut as int64: s1 = 20
      mut as int64: s2 = 10

      println("Pulso de transmissao de referencia: [" + s0 + ", " + s1 + ", " + s2 + "]")

      #L Sinal recebido r com ruido de canal, contendo o pulso deslocado na posicao k = 2:
      #L r = [2, 1, 10, 20, 10, 3]  (6 amostras recebidas)
      #L Amostras r:
      mut as int64: r0 = 2
      mut as int64: r1 = 1
      mut as int64: r2 = 10
      mut as int64: r3 = 20
      mut as int64: r4 = 10
      mut as int64: r5 = 3

      println("Sinal recebido ruidoso: [" + r0 + ", " + r1 + ", " + r2 + ", " + r3 + ", " + r4 + ", " + r5 + "]")

      #L Correlacao cruzada / convolucao do filtro casado em diferentes instantes de alinhamento:
      #L Instante 0: r[0..2] = [2, 1, 10]
      #L y_0 = 2*10 + 1*20 + 10*10 = 20 + 20 + 100 = 140
      mut as int64: y0 = r0 * s0 + r1 * s1 + r2 * s2

      #L Instante 1: r[1..3] = [1, 10, 20]
      #L y_1 = 1*10 + 10*20 + 20*10 = 10 + 200 + 200 = 410
      mut as int64: y1 = r1 * s0 + r2 * s1 + r3 * s2

      #L Instante 2 (Alinhamento Perfeito com o Pulso): r[2..4] = [10, 20, 10]
      #L y_2 = 10*10 + 20*20 + 10*10 = 100 + 400 + 100 = 600 (Pico Maximo da SNR!)
      mut as int64: y2 = r2 * s0 + r3 * s1 + r4 * s2

      #L Instante 3: r[3..5] = [20, 10, 3]
      #L y_3 = 20*10 + 10*20 + 3*10 = 200 + 200 + 30 = 430
      mut as int64: y3 = r3 * s0 + r4 * s1 + r5 * s2

      println("Saida do Filtro Casado (Correlacao Cruzada):")
      println("  Instante 0: " + y0)
      println("  Instante 1: " + y1)
      println("  Instante 2 (Pico Maximo): " + y2)
      println("  Instante 3: " + y3)

      #L Criterio de deteccao de limiar (Threshold Detection):
      #L Limiar de decisao = 500
      mut as int64: threshold = 500
      mut as int64: peak_instant = -1
      route {
            y2 >= threshold and y2 > y1 and y2 > y3 ==> {
                  peak_instant = 2
                  println("Pulso detectado com SNR maxima no instante k = " + peak_instant + "!")
            }
            _ ==> {
                  println("Pulso nao detectado")
            }
      }

      println("Matched Filter Signal Detection concluido com sucesso.")
}
