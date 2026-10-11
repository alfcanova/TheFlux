#L ============================================================================
#L Algoritmo: DWT — Discrete Wavelet Transform (Haar Wavelet 1D)
#L Dominio: 11_dsp_multimedia / Categoria: Transformadas Wavelet
#L Descricao: Decomposicao e reconstrucao exata em coeficientes de aproximacao e detalhe
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPDiscreteWaveletTransformHaar) {
      println("=== Algoritmo: Discrete Wavelet Transform (Haar) ===")

      #L Sinal de entrada discreto x de comprimento N = 4:
      #L x = [12, 16, 20, 10]
      mut as int64: x0 = 12
      mut as int64: x1 = 16
      mut as int64: x2 = 20
      mut as int64: x3 = 10

      println("Sinal discreto original: [" + x0 + ", " + x1 + ", " + x2 + ", " + x3 + "]")

      #L Decomposicao Haar DWT Nivel 1:
      #L Coeficientes de Aproximacao a (filtro passo-baixa):
      #L a0 = (x0 + x1) / 2 = (12 + 16) / 2 = 14
      #L a1 = (x2 + x3) / 2 = (20 + 10) / 2 = 15
      mut as int64: a0 = (x0 + x1) /i 2
      mut as int64: a1 = (x2 + x3) /i 2

      #L Coeficientes de Detalhe d (filtro passo-alta):
      #L d0 = (x0 - x1) / 2 = (12 - 16) / 2 = -2
      #L d1 = (x2 - x3) / 2 = (20 - 10) / 2 = 5
      mut as int64: d0 = (x0 - x1) /i 2
      mut as int64: d1 = (x2 - x3) /i 2

      println("Coeficientes de Aproximacao (Baixa Frequencia): [" + a0 + ", " + a1 + "]")
      println("Coeficientes de Detalhe (Alta Frequencia): [" + d0 + ", " + d1 + "]")

      #L Reconstrucao Perfeita IDWT (Inverse Haar Transform):
      #L x0_rec = a0 + d0 = 14 + (-2) = 12
      #L x1_rec = a0 - d0 = 14 - (-2) = 16
      #L x2_rec = a1 + d1 = 15 + 5 = 20
      #L x3_rec = a1 - d1 = 15 - 5 = 10
      mut as int64: x0_rec = a0 + d0
      mut as int64: x1_rec = a0 - d0
      mut as int64: x2_rec = a1 + d1
      mut as int64: x3_rec = a1 - d1

      println("Sinal reconstruido pela IDWT: [" + x0_rec + ", " + x1_rec + ", " + x2_rec + ", " + x3_rec + "]")

      #L Verificacao de conservacao e reconstrucao sem perda:
      route {
            x0_rec == x0 and x1_rec == x1 and x2_rec == x2 and x3_rec == x3 ==> {
                  println("Reconstrucao Perfeita (Perfect Reconstruction) garantida!")
            }
            _ ==> {
                  println("Falha na sintese do sinal Haar")
            }
      }

      println("DWT Haar concluido com sucesso.")
}
