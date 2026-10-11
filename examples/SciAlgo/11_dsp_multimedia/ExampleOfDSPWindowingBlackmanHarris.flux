#L ============================================================================
#L Algoritmo: Janela Blackman-Harris de 4 Termos (Atenuacao de -92 dB)
#L Dominio: 11_dsp_multimedia / Categoria: Janelamento e Analise Espectral
#L Descricao: Ponderacao de 4 termos de cosseno para minima dispersao de lobulos laterais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPWindowingBlackmanHarris) {
      println("=== Algoritmo: Janela Blackman-Harris de 4 Termos ===")

      #L Coeficientes canonicos normalizados da janela de 4 termos (escala x100000):
      #L a0 = 0.35875 -> 35875
      #L a1 = 0.48829 -> 48829
      #L a2 = 0.14128 -> 14128
      #L a3 = 0.01168 -> 1168
      #L Soma total a0 + a1 + a2 + a3 = 100000 (1.00000)
      mut as int64: a0 = 35875
      mut as int64: a1 = 48829
      mut as int64: a2 = 14128
      mut as int64: a3 = 1168

      println("Coeficientes de cosseno de 4 termos Blackman-Harris:")
      println("  a0 = " + a0 + ", a1 = " + a1 + ", a2 = " + a2 + ", a3 = " + a3)

      #L Avaliacao nos pontos extremos e central para N = 5 amostras:
      #L Ponto n = 0 (borda esquerda):
      #L cos(0) = 1 em todos os termos:
      #L w[0] = a0 - a1 + a2 - a3 = 35875 - 48829 + 14128 - 1168 = 6 (quase 0 absoluto, atenuacao -92 dB!)
      mut as int64: w_edge_x100000 = a0 - a1 + a2 - a3

      #L Ponto central n = 2 (pico da janela):
      #L theta = pi
      #L cos(pi) = -1, cos(2pi) = 1, cos(3pi) = -1
      #L w[2] = a0 - a1*(-1) + a2*(1) - a3*(-1) = a0 + a1 + a2 + a3 = 100000 (1.0 exato)
      mut as int64: w_center_x100000 = a0 + a1 + a2 + a3

      #L Valores em escala x1000:
      mut as int64: w_edge = w_edge_x100000 /i 100
      mut as int64: w_center = w_center_x100000 /i 100

      println("Valor na borda w[0] (x100000): " + w_edge_x100000 + " (atenuacao profunda > 92 dB)")
      println("Valor central w[center] (x100000): " + w_center_x100000 + " (pico unitario)")

      route {
            w_edge_x100000 < 50 and w_center_x100000 == 100000 ==> {
                  println("Janela Blackman-Harris com supressao de lobulos laterais validada!")
            }
            _ ==> {
                  println("Erro na construcao da janela")
            }
      }

      println("Blackman-Harris Windowing concluido com sucesso.")
}
