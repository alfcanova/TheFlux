#L ============================================================================
#L Algoritmo: Goertzel Frequency Detection (Deteccao DTMF de Frequencia Unica)
#L Dominio: 11_dsp_multimedia / Categoria: Analise Espectral
#L Descricao: Filtro IIR de segunda ordem de alta eficiencia para tom especifico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPGoertzelFrequencyDetection) {
      println("=== Algoritmo: Goertzel Frequency Detection ===")

      #L Frequencia alvo normalizada: omega = pi/2 (rad/amostra)
      #L Coeficiente IIR: coeff = 2 * cos(omega) = 2 * cos(pi/2) = 0
      #L Equacao de diferencas recursiva: s[n] = x[n] + coeff * s[n-1] - s[n-2]
      #L com coeff = 0, simplifica para: s[n] = x[n] - s[n-2]
      println("Frequencia analisada: omega = pi/2 (coeficiente de realimentacao = 0)")

      #L Sinal de entrada com frequencia ressonante exata em omega = pi/2:
      #L x = [10, 0, -10, 0] (4 amostras)
      mut as int64: s_prev1 = 0
      mut as int64: s_prev2 = 0

      #L Passo 0: x[0] = 10
      #L s[0] = 10 - 0 = 10
      mut as int64: s0 = 10 - s_prev2
      s_prev2 = s_prev1
      s_prev1 = s0

      #L Passo 1: x[1] = 0
      #L s[1] = 0 - 0 = 0
      mut as int64: s1 = 0 - s_prev2
      s_prev2 = s_prev1
      s_prev1 = s1

      #L Passo 2: x[2] = -10
      #L s[2] = -10 - 10 = -20
      mut as int64: s2 = -10 - s_prev2
      s_prev2 = s_prev1
      s_prev1 = s2

      #L Passo 3: x[3] = 0
      #L s[3] = 0 - 0 = 0
      mut as int64: s3 = 0 - s_prev2
      s_prev2 = s_prev1
      s_prev1 = s3

      println("Estados finais do acumulador IIR: s[N-1] = " + s_prev1 + ", s[N-2] = " + s_prev2)

      #L Calculo final da potencia / magnitude ao quadrado do tom alvo:
      #L |X|^2 = s[N-1]^2 + s[N-2]^2 - coeff * s[N-1] * s[N-2]
      #L |X|^2 = 0^2 + (-20)^2 - 0 = 400
      mut as int64: p_sq1 = s_prev1 * s_prev1
      mut as int64: p_sq2 = s_prev2 * s_prev2
      mut as int64: power = p_sq1 + p_sq2

      println("Potencia espectral detectada no tom alvo |X|^2: " + power)

      route {
            power >= 400 ==> {
                  println("Tom ressonante DTMF detectado com alta amplitude pelo algoritmo de Goertzel!")
            }
            power < 400 ==> {
                  println("Sinal sem energia na frequencia sintonizada")
            }
      }

      println("Goertzel Frequency Detection concluido com sucesso.")
}
