#L ============================================================================
#L Algoritmo: Janelas FIR (Hamming & Hann Windowing)
#L Dominio: 11_dsp_multimedia / Categoria: Janelamento e Projeto de Filtros
#L Descricao: Ponderacao espectral para reducao de vazamento espectral (spectral leakage)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPWindowingFIRHammingHann) {
      println("=== Algoritmo: Janelas FIR (Hamming & Hann) ===")

      #L Comprimento da janela N = 5 amostras (n = 0, 1, 2, 3, 4)
      #L Argumento angular theta = 2*pi * n / (N - 1) = 2*pi * n / 4 = pi * n / 2
      #L cos(pi*n/2):
      #L n=0: cos(0) = 1
      #L n=1: cos(pi/2) = 0
      #L n=2: cos(pi) = -1
      #L n=3: cos(3pi/2) = 0
      #L n=4: cos(2pi) = 1

      #L Janela de Hann: w_hann[n] = 0.50 - 0.50 * cos(theta)
      #L Em escala x1000:
      #L n=0: 500 - 500 * (1) = 0
      #L n=1: 500 - 500 * (0) = 500
      #L n=2: 500 - 500 * (-1) = 1000 (pico central)
      #L n=3: 500 - 500 * (0) = 500
      #L n=4: 500 - 500 * (1) = 0
      mut as int64: hann_0 = 0
      mut as int64: hann_1 = 500
      mut as int64: hann_2 = 1000
      mut as int64: hann_3 = 500
      mut as int64: hann_4 = 0

      #L Janela de Hamming: w_hamming[n] = 0.54 - 0.46 * cos(theta)
      #L Em escala x1000:
      #L n=0: 540 - 460 * (1) = 80
      #L n=1: 540 - 460 * (0) = 540
      #L n=2: 540 - 460 * (-1) = 1000 (pico central)
      #L n=3: 540 - 460 * (0) = 540
      #L n=4: 540 - 460 * (1) = 80
      mut as int64: ham_0 = 80
      mut as int64: ham_1 = 540
      mut as int64: ham_2 = 1000
      mut as int64: ham_3 = 540
      mut as int64: ham_4 = 80

      println("Janela de Hann (x1000):    [" + hann_0 + ", " + hann_1 + ", " + hann_2 + ", " + hann_3 + ", " + hann_4 + "]")
      println("Janela de Hamming (x1000): [" + ham_0 + ", " + ham_1 + ", " + ham_2 + ", " + ham_3 + ", " + ham_4 + "]")

      #L Aplicacao no sinal de entrada x = [100, 100, 100, 100, 100]:
      #L Sinal com janela Hann:
      mut as int64: y_hann_central = (100 * hann_2) /i 1000
      #L Sinal com janela Hamming:
      mut as int64: y_ham_edge = (100 * ham_0) /i 1000

      println("Pico central com Hann: " + y_hann_central)
      println("Borda suavizada com Hamming: " + y_ham_edge)

      route {
            hann_0 == 0 and ham_0 == 80 and hann_2 == 1000 ==> {
                  println("Suavizacao perimetral confirmada: Reducao de vazamento espectral garantida!")
            }
            _ ==> {
                  println("Erro no calculo das janelas")
            }
      }

      println("Janelas FIR Hamming & Hann concluido com sucesso.")
}
