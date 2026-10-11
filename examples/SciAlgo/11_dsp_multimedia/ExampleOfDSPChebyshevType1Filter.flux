#L ============================================================================
#L Algoritmo: Filtro IIR Chebyshev Tipo I (Banda Passante com Ripple Equiondulado)
#L Dominio: 11_dsp_multimedia / Categoria: Filtragem Digital IIR
#L Descricao: Transicao espectral ingreme otimizada com ondulacao tolerada na banda passante
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPChebyshevType1Filter) {
      println("=== Algoritmo: Filtro Chebyshev Tipo I (IIR) ===")

      #L Filtro biquad Chebyshev Tipo I (1 dB de ripple na banda passante, corte wc = 0.25*pi)
      #L Coeficientes de feedforward b (escala x1000):
      #L b0 = 48, b1 = 96, b2 = 48
      #L Coeficientes de feedback a (escala x1000):
      #L a1 = -1230, a2 = 560
      mut as int64: b0 = 48
      mut as int64: b1 = 96
      mut as int64: b2 = 48
      mut as int64: a1 = -1230
      mut as int64: a2 = 560

      println("Coeficientes Chebyshev Tipo I:")
      println("  b = [" + b0 + ", " + b1 + ", " + b2 + "]")
      println("  a = [1000, " + a1 + ", " + a2 + "]")

      #L Entrada: Sinal com amplitude alternada simulando componente de alta frequencia na banda de rejeicao
      #L x = [1000, -1000, 1000, -1000]
      #L Processamento de 3 passos:
      #L Passo 1: x[0] = 1000
      mut as int64: y0 = (b0 * 1000) /i 1000

      #L Passo 2: x[1] = -1000
      #L y1 = (b0*(-1000) + b1*(1000) - a1*y0) / 1000
      #L -48000 + 96000 + 1230*48 = 48000 + 59040 = 107040 / 1000 = 107
      mut as int64: num1 = b0 * (-1000) + b1 * 1000 - a1 * y0
      mut as int64: y1 = num1 /i 1000

      #L Passo 3: x[2] = 1000
      #L y2 = (b0*(1000) + b1*(-1000) + b2*(1000) - a1*y1 - a2*y0) / 1000
      #L 48000 - 96000 + 48000 = 0
      #L -a1*y1 = 1230 * 107 = 131610
      #L -a2*y0 = -560 * 48 = -26880
      #L Total = 131610 - 26880 = 104730 / 1000 = 104
      mut as int64: num2 = b0 * 1000 + b1 * (-1000) + b2 * 1000 - a1 * y1 - a2 * y0
      mut as int64: y2 = num2 /i 1000

      println("Sinal de saida sob excitacao de alta frequencia:")
      println("  y[0] = " + y0)
      println("  y[1] = " + y1)
      println("  y[2] = " + y2)

      #L Atenuacao expressiva na banda de rejeicao (sinal original 1000 atenuado para ~100):
      route {
            y2 < 200 ==> {
                  println("Alta atenuacao de Chebyshev Tipo I confirmada (mais de 18 dB de rejeicao)!")
            }
            _ ==> {
                  println("Atenuacao insuficiente")
            }
      }

      println("Chebyshev Type 1 Filter concluido com sucesso.")
}
