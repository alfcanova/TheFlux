#L ============================================================================
#L Algoritmo: Filtro Comb & Reverberador de Schroeder (Acustica de Salas)
#L Dominio: 11_dsp_multimedia / Categoria: Efeitos de Audio e Reverberacao
#L Descricao: Simulacao de reflexoes acústicas densas via linhas de atraso recirculantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPCombFilterReverbSchroeder) {
      println("=== Algoritmo: Reverberador Schroeder (Feedback Comb Filter) ===")

      #L Linha de atraso D = 2 amostras
      #L Ganho de realimentacao de feedback g = 0.50 (500 em escala x1000)
      #L Equacao de diferencas: y[n] = x[n] + g * y[n - D]
      mut as int64: delay = 2
      mut as int64: gain_feedback = 500

      println("Parametros: Atraso D = " + delay + " amostras, ganho de feedback g = " + gain_feedback + "/1000")

      #L Entrada: Impulso acustico inicial na amostra 0 com amplitude 1000
      #L x[0] = 1000, x[1..4] = 0
      #L Memoria de atraso de saida (buffer circular de 2 posicoes):
      mut as int64: y_buf0 = 0
      mut as int64: y_buf1 = 0

      #L Amostra n = 0: x[0] = 1000
      #L y[0] = 1000 + g * y_buf0 = 1000 + 0 = 1000
      mut as int64: y0 = 1000
      y_buf0 = y_buf1
      y_buf1 = y0

      #L Amostra n = 1: x[1] = 0
      #L y[1] = 0 + g * y_buf0 = 0
      mut as int64: y1 = (gain_feedback * y_buf0) /i 1000
      y_buf0 = y_buf1
      y_buf1 = y1

      #L Amostra n = 2: x[2] = 0
      #L y[2] = 0 + g * y_buf0 = 0 + 500 * 1000 / 1000 = 500 (Primeiro eco recirculante!)
      mut as int64: y2 = (gain_feedback * y_buf0) /i 1000
      y_buf0 = y_buf1
      y_buf1 = y2

      #L Amostra n = 3: x[3] = 0
      mut as int64: y3 = (gain_feedback * y_buf0) /i 1000
      y_buf0 = y_buf1
      y_buf1 = y3

      #L Amostra n = 4: x[4] = 0
      #L y[4] = 0 + g * y_buf0 = 500 * 500 / 1000 = 250 (Segundo eco atenuado!)
      mut as int64: y4 = (gain_feedback * y_buf0) /i 1000

      println("Trem de ecos gerado pela linha de atraso:")
      println("  n=0 (Sinal Direto): y[0] = " + y0)
      println("  n=1 (Silencio):     y[1] = " + y1)
      println("  n=2 (Eco 1):        y[2] = " + y2)
      println("  n=3 (Silencio):     y[3] = " + y3)
      println("  n=4 (Eco 2):        y[4] = " + y4)

      route {
            y0 == 1000 and y2 == 500 and y4 == 250 ==> {
                  println("Decaimento exponencial de reverberacao Schroeder validado com exatidao!")
            }
            _ ==> {
                  println("Erro na simulacao de reverberacao")
            }
      }

      println("Filtro Comb & Reverberador Schroeder concluido com sucesso.")
}
