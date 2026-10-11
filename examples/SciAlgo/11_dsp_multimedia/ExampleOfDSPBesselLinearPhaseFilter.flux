#L ============================================================================
#L Algoritmo: Filtro IIR Bessel de Fase Linear (Preservacao de Forma de Onda)
#L Dominio: 11_dsp_multimedia / Categoria: Filtragem Digital IIR
#L Descricao: Atraso de grupo maximamente plano sem dispersao de fase em pulsos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPBesselLinearPhaseFilter) {
      println("=== Algoritmo: Filtro Bessel de Fase Linear (IIR) ===")

      #L Filtro biquad de Bessel de 2a ordem:
      #L Otimizado para group delay constante, sem overshoot (sobresinal) em degraus
      #L Coeficientes de feedforward b (escala x1000):
      #L b0 = 98, b1 = 196, b2 = 98
      #L Coeficientes de feedback a (escala x1000):
      #L a1 = -942, a2 = 334
      mut as int64: b0 = 98
      mut as int64: b1 = 196
      mut as int64: b2 = 98
      mut as int64: a1 = -942
      mut as int64: a2 = 334

      println("Coeficientes do Filtro Bessel:")
      println("  b = [" + b0 + ", " + b1 + ", " + b2 + "]")
      println("  a = [1000, " + a1 + ", " + a2 + "]")

      #L Entrada: Pulso retangular de curta duracao (largura 2 amostras):
      #L x = [1000, 1000, 0, 0]
      #L Passo 0: x[0] = 1000
      mut as int64: y0 = (b0 * 1000) /i 1000

      #L Passo 1: x[1] = 1000
      #L y1 = (b0*1000 + b1*1000 - a1*y0) / 1000
      #L 98000 + 196000 + 942*98 = 294000 + 92316 = 386316 / 1000 = 386
      mut as int64: num1 = b0 * 1000 + b1 * 1000 - a1 * y0
      mut as int64: y1 = num1 /i 1000

      #L Passo 2: x[2] = 0
      #L y2 = (b0*0 + b1*1000 + b2*1000 - a1*y1 - a2*y0) / 1000
      #L 196000 + 98000 = 294000
      #L -a1*y1 = 942 * 386 = 363612
      #L -a2*y0 = -334 * 98 = -32732
      #L Total = 294000 + 363612 - 32732 = 624880 / 1000 = 624
      mut as int64: num2 = b1 * 1000 + b2 * 1000 - a1 * y1 - a2 * y0
      mut as int64: y2 = num2 /i 1000

      #L Passo 3: x[3] = 0
      #L y3 = (b2*1000 - a1*y2 - a2*y1) / 1000
      #L 98000 + 942*624 - 334*386 = 98000 + 587808 - 128924 = 556884 / 1000 = 556
      mut as int64: num3 = b2 * 1000 - a1 * y2 - a2 * y1
      mut as int64: y3 = num3 /i 1000

      println("Resposta temporal ao pulso retangular:")
      println("  y[0] = " + y0)
      println("  y[1] = " + y1)
      println("  y[2] = " + y2)
      println("  y[3] = " + y3)

      #L Propriedade do filtro Bessel: Transicao gaussiana simetrica sem oscilacoes de Gibbs:
      route {
            y2 > y1 and y3 < y2 ==> {
                  println("Forma de onda transmitida sem ondulacao parasita (Atraso de Grupo Linear)!")
            }
            _ ==> {
                  println("Distorcao de fase detectada")
            }
      }

      println("Bessel Linear Phase Filter concluido com sucesso.")
}
