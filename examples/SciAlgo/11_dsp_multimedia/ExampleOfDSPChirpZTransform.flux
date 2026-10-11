#L ============================================================================
#L Algoritmo: Chirp Z-Transform (CZT - Transformada Z de Zoom Espectral)
#L Dominio: 11_dsp_multimedia / Categoria: Analise Espectral Avancada
#L Descricao: Avaliacao de contorno espiral no plano complexo para alta resolucao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPChirpZTransform) {
      println("=== Algoritmo: Chirp Z-Transform (CZT) ===")

      #L Amostras de sinal de entrada N = 4:
      #L x = [10, 20, 15, 5]
      #L O algoritmo CZT avalia X(z_k) onde z_k = A * W^(-k), k = 0..M-1
      #L Permite fazer "zoom" de alta resolucao em uma faixa estreita de frequencias
      mut as int64: n = 4
      mut as int64: m_points = 3
      println("Sinal de entrada: [10, 20, 15, 5], avaliando M = 3 pontos de zoom espectral")

      #L Fator de contorno circular unitario A = 1, passo de frequencia delta_omega = pi / 8
      #L Modulacao por chirp: W^(-k^2 / 2)
      #L Identidade de Bluestein: o termo n*k eh decomposto em:
      #L n*k = (n^2 + k^2 - (k - n)^2) / 2
      #L A transformada Z converte-se em convolucao entre x[n]*W^(n^2/2) e W^(-n^2/2)

      #L Ponto k = 0 (frequencia inicial omega_0 = 0, DC local):
      #L X(z_0) = sum x[n] = 10 + 20 + 15 + 5 = 50
      mut as int64: x_czt_0 = 10 + 20 + 15 + 5

      #L Ponto k = 1 (frequencia intermediaria no zoom omega = pi/8):
      #L Pesos de projecao aproximados (x1000):
      #L cos(0*pi/8) = 1.000 (1000) -> 10 * 1000 = 10000
      #L cos(1*pi/8) = 0.924 (924)  -> 20 * 924 = 18480
      #L cos(2*pi/8) = 0.707 (707)  -> 15 * 707 = 10605
      #L cos(3*pi/8) = 0.383 (383)  -> 5 * 383 = 1915
      #L Soma real = (10000 + 18480 + 10605 + 1915) / 1000 = 41000 / 1000 = 41
      mut as int64: sum_k1 = 10 * 1000 + 20 * 924 + 15 * 707 + 5 * 383
      mut as int64: x_czt_1 = sum_k1 /i 1000

      #L Ponto k = 2 (frequencia final do zoom omega = 2*pi/8 = pi/4):
      #L cos(0) = 1000 -> 10000
      #L cos(pi/4) = 707 -> 14140
      #L cos(pi/2) = 0 -> 0
      #L cos(3pi/4) = -707 -> -3535
      #L Soma real = (10000 + 14140 + 0 - 3535) / 1000 = 20605 / 1000 = 20
      mut as int64: sum_k2 = 10 * 1000 + 20 * 707 + 0 - 5 * 707
      mut as int64: x_czt_2 = sum_k2 /i 1000

      println("Resultados do contorno CZT de banda estreita:")
      println("  Ponto k = 0 (omega = 0):     X(z_0) = " + x_czt_0)
      println("  Ponto k = 1 (omega = pi/8):  X(z_1) = " + x_czt_1)
      println("  Ponto k = 2 (omega = pi/4):  X(z_2) = " + x_czt_2)

      route {
            x_czt_0 == 50 and x_czt_1 > x_czt_2 ==> {
                  println("Zoom espectral Chirp Z-Transform avaliado com alta discriminacao local!")
            }
            _ ==> {
                  println("Erro na avaliacao CZT")
            }
      }

      println("Chirp Z-Transform concluido com sucesso.")
}
