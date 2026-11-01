#L ============================================================================
#L Algoritmo: Filtro IIR Butterworth Passo-Baixa (Segunda Ordem Biquad)
#L Dominio: 11_dsp_multimedia / Categoria: Filtragem Digital IIR
#L Descricao: Resposta em frequencia maximamente plana sem ripple na banda passante
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPButterworthLowPassFilter) {
      println("=== Algoritmo: Filtro Butterworth Passo-Baixa (IIR) ===")

      #L Filtro biquad de 2a ordem com frequencia de corte normalizada wc = 0.2 * pi:
      #L Coeficientes de feedforward b (escala x1000):
      #L b0 = 67, b1 = 135, b2 = 67
      #L Coeficientes de feedback a (escala x1000):
      #L a1 = -1143, a2 = 413
      mut as int64: b0 = 67
      mut as int64: b1 = 135
      mut as int64: b2 = 67
      mut as int64: a1 = -1143
      mut as int64: a2 = 413

      println("Coeficientes do filtro Biquad Butterworth:")
      println("  b = [" + b0 + ", " + b1 + ", " + b2 + "]")
      println("  a = [1000, " + a1 + ", " + a2 + "]")

      #L Entrada: Degrau unitario com amplitude 1000
      #L x = [1000, 1000, 1000, 1000]
      #L Estados iniciais de atraso nulos
      mut as int64: x_prev1 = 0
      mut as int64: x_prev2 = 0
      mut as int64: y_prev1 = 0
      mut as int64: y_prev2 = 0

      #L Passo 1: x[0] = 1000
      #L y[0] = (b0*1000 + b1*0 + b2*0 - a1*0 - a2*0) / 1000 = b0 = 67
      mut as int64: num0 = b0 * 1000
      mut as int64: y0 = num0 /i 1000

      #L Passo 2: x[1] = 1000
      #L y[1] = (b0*1000 + b1*1000 + b2*0 - a1*y0 - a2*0) / 1000
      #L b0*1000 + b1*1000 = 67000 + 135000 = 202000
      #L - a1 * y0 = - (-1143) * 67 = 1143 * 67 = 76581
      #L Total = 202000 + 76581 = 278581 / 1000 = 278
      mut as int64: num1 = b0 * 1000 + b1 * 1000 - a1 * y0
      mut as int64: y1 = num1 /i 1000

      #L Passo 3: x[2] = 1000
      #L y[2] = (b0*1000 + b1*1000 + b2*1000 - a1*y1 - a2*y0) / 1000
      #L Feedforward = 67000 + 135000 + 67000 = 269000
      #L - a1*y1 = 1143 * 278 = 317754
      #L - a2*y0 = - 413 * 67 = -27671
      #L Total = 269000 + 317754 - 27671 = 559083 / 1000 = 559
      mut as int64: num2 = b0 * 1000 + b1 * 1000 + b2 * 1000 - a1 * y1 - a2 * y0
      mut as int64: y2 = num2 /i 1000

      println("Resposta ao degrau calculada recursivamente:")
      println("  y[0] = " + y0)
      println("  y[1] = " + y1)
      println("  y[2] = " + y2)

      route {
            y0 < y1 and y1 < y2 and y2 < 1000 ==> {
                  println("Resposta assintotica monotonicamente suave caracteristica do filtro Butterworth!")
            }
            _ ==> {
                  println("Instabilidade no filtro")
            }
      }

      println("Butterworth Low-Pass Filter concluido com sucesso.")
}
