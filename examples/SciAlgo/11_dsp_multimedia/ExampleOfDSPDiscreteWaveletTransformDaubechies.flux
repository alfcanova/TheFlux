#L ============================================================================
#L Algoritmo: DWT — Daubechies D4 Wavelet Transform
#L Dominio: 11_dsp_multimedia / Categoria: Transformadas Wavelet
#L Descricao: Banco de filtros ortogonais de 4 coeficientes de escala Daubechies
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPDiscreteWaveletTransformDaubechies) {
      println("=== Algoritmo: Daubechies D4 Wavelet Transform ===")

      #L Coeficientes de escala do filtro de analise Daubechies D4 (normalizados x1000):
      #L h0 = (1 + sqrt(3)) / (4*sqrt(2)) ~ 0.48296 -> 483
      #L h1 = (3 + sqrt(3)) / (4*sqrt(2)) ~ 0.83652 -> 837
      #L h2 = (3 - sqrt(3)) / (4*sqrt(2)) ~ 0.22414 -> 224
      #L h3 = (1 - sqrt(3)) / (4*sqrt(2)) ~ -0.12941 -> -129
      mut as int64: h0 = 483
      mut as int64: h1 = 837
      mut as int64: h2 = 224
      mut as int64: h3 = -129

      #L Coeficientes wavelet de detalhe em quadratura conjugada (QMF):
      #L g0 = h3 = -129
      #L g1 = -h2 = -224
      #L g2 = h1 = 837
      #L g3 = -h0 = -483
      mut as int64: g0 = -129
      mut as int64: g1 = -224
      mut as int64: g2 = 837
      mut as int64: g3 = -483

      println("Filtro de Escala D4 (Passo-Baixa): [" + h0 + ", " + h1 + ", " + h2 + ", " + h3 + "]")
      println("Filtro Wavelet D4 (Passo-Alta):    [" + g0 + ", " + g1 + ", " + g2 + ", " + g3 + "]")

      #L Sinal discreto de entrada de 4 amostras: x = [100, 200, 150, 50]
      mut as int64: x0 = 100
      mut as int64: x1 = 200
      mut as int64: x2 = 150
      mut as int64: x3 = 50

      #L Convolucao com condicao de contorno periodica para calcular aproximacao a0:
      #L a0 = (h0*x0 + h1*x1 + h2*x2 + h3*x3) / 1000
      #L h0*x0 = 483 * 100 = 48300
      #L h1*x1 = 837 * 200 = 167400
      #L h2*x2 = 224 * 150 = 33600
      #L h3*x3 = -129 * 50 = -6450
      #L Soma = 48300 + 167400 + 33600 - 6450 = 242850
      #L a0 = 242850 / 1000 = 242
      mut as int64: sum_a0 = h0 * x0 + h1 * x1 + h2 * x2 + h3 * x3
      mut as int64: a0 = sum_a0 /i 1000

      #L Convolucao para detalhe d0:
      #L sum_d0 = g0*x0 + g1*x1 + g2*x2 + g3*x3
      #L g0*x0 = -129 * 100 = -12900
      #L g1*x1 = -224 * 200 = -44800
      #L g2*x2 = 837 * 150 = 125550
      #L g3*x3 = -483 * 50 = -24150
      #L Soma = -12900 - 44800 + 125550 - 24150 = 43700
      #L d0 = 43700 / 1000 = 43
      mut as int64: sum_d0 = g0 * x0 + g1 * x1 + g2 * x2 + g3 * x3
      mut as int64: d0 = sum_d0 /i 1000

      println("Coeficiente D4 de Aproximacao a0: " + a0)
      println("Coeficiente D4 de Detalhe d0: " + d0)

      route {
            a0 > 0 and d0 > 0 ==> {
                  println("Decomposicao ortogonal de Daubechies D4 calculada com precisao compacta!")
            }
            _ ==> {
                  println("Erro na convolucao D4")
            }
      }

      println("Daubechies D4 Wavelet concluido com sucesso.")
}
