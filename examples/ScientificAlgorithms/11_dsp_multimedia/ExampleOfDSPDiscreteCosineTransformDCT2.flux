#L ============================================================================
#L Algoritmo: DCT-II — Discrete Cosine Transform Tipo 2 (Compressao Multimedia)
#L Dominio: 11_dsp_multimedia / Categoria: Transformadas Espectrais
#L Descricao: Transformada discreta de cosseno para compactacao de energia em JPEG/MP3
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPDiscreteCosineTransformDCT2) {
      println("=== Algoritmo: DCT-II (Discrete Cosine Transform) ===")

      #L Bloco de sinal de entrada N = 4 amostras (ex: linha de pixels ou áudio):
      #L x = [80, 85, 90, 85]  (sinal suave de luminancia media)
      mut as int64: x0 = 80
      mut as int64: x1 = 85
      mut as int64: x2 = 90
      mut as int64: x3 = 85

      println("Sinal de entrada: [" + x0 + ", " + x1 + ", " + x2 + ", " + x3 + "]")

      #L Coeficiente DC (k = 0):
      #L cos(0) = 1 para todas as amostras
      #L X_0 = x0 + x1 + x2 + x3 = 80 + 85 + 90 + 85 = 340
      mut as int64: x_dc = x0 + x1 + x2 + x3
      println("Coeficiente DC (Energia Media do Bloco X_0): " + x_dc)

      #L Coeficiente AC 1 (k = 1):
      #L Argumentos do cosseno: pi/4 * (n + 0.5):
      #L n=0: cos(pi/8)  ~ 0.9239 (924 / 1000)
      #L n=1: cos(3pi/8) ~ 0.3827 (383 / 1000)
      #L n=2: cos(5pi/8) ~ -0.3827 (-383 / 1000)
      #L n=3: cos(7pi/8) ~ -0.9239 (-924 / 1000)
      #L X_1 = 924*80 + 383*85 - 383*90 - 924*85
      #L 924*(80 - 85) + 383*(85 - 90) = 924*(-5) + 383*(-5) = -4620 - 1915 = -6535
      #L X_1 / 1000 = -6
      mut as int64: sum_ac1 = 924 * (x0 - x3) + 383 * (x1 - x2)
      mut as int64: x_ac1 = sum_ac1 /i 1000

      #L Coeficiente AC 2 (k = 2):
      #L n=0: cos(2pi/8) = cos(pi/4) ~ 0.707 (707 / 1000)
      #L n=1: cos(6pi/8) = cos(3pi/4) ~ -0.707 (-707 / 1000)
      #L n=2: cos(10pi/8) = -0.707 (-707 / 1000)
      #L n=3: cos(14pi/8) = 0.707 (707 / 1000)
      #L X_2 = 707*(x0 - x1 - x2 + x3) = 707*(80 - 85 - 90 + 85) = 707*(-10) = -7070
      #L X_2 / 1000 = -7
      mut as int64: sum_ac2 = 707 * (x0 - x1 - x2 + x3)
      mut as int64: x_ac2 = sum_ac2 /i 1000

      println("Coeficiente AC 1 (Frequencia Baixa X_1): " + x_ac1)
      println("Coeficiente AC 2 (Frequencia Media X_2): " + x_ac2)

      #L Efeito de Compactacao de Energia:
      #L O coeficiente DC contem a esmagadora maioria da variancia do sinal
      route {
            x_dc > 300 and x_ac1 > -20 ==> {
                  println("Compactacao de energia DCT-II confirmada: Quase toda energia reside no termo DC!")
            }
            _ ==> {
                  println("Divergencia espectral")
            }
      }

      println("DCT-II concluido com sucesso.")
}
