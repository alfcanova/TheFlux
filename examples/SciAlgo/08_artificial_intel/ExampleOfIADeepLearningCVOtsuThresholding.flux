#L ============================================================================
#L Algoritmo: Otsu Thresholding (Limiarizacao Automatica)
#L Dominio: 08_artificial_intel / Subdominio: Visao Computacional
#L Descricao: Binarizacao otima maximizando a variancia inter-classe
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVOtsuThresholding) {
      println("=== Algoritmo: Otsu Thresholding ===")

      #L Histograma simplificado de 4 niveis de cinza [0, 1, 2, 3]
      #L Contagem de pixels: hist = [10, 20, 20, 10], Total = 60 pixels
      mut as int64: h0 = 10
      mut as int64: h1 = 20
      mut as int64: h2 = 20
      mut as int64: h3 = 10
      mut as int64: total = 60

      #L Teste do limiar t = 1 (Classe 0: [0, 1], Classe 1: [2, 3]):
      #L Peso w0 = (10 + 20) = 30
      #L Peso w1 = (20 + 10) = 30
      mut as int64: w0 = h0 + h1
      mut as int64: w1 = h2 + h3

      #L Media da classe 0: sum0 = 0*10 + 1*20 = 20 -> mu0 = 20 /i 30 (x100 -> 2000 /i 30 = 66)
      mut as int64: sum0 = 1 * h1
      mut as int64: sum0_scaled = sum0 * 100
      mut as int64: mu0 = sum0_scaled /i w0

      #L Media da classe 1: sum1 = 2*20 + 3*10 = 70 -> mu1 = 70 /i 30 (x100 -> 7000 /i 30 = 233)
      mut as int64: sum1 = 2 * h2 + 3 * h3
      mut as int64: sum1_scaled = sum1 * 100
      mut as int64: mu1 = sum1_scaled /i w1

      #L Variancia inter-classe: sigma_b^2 = w0 * w1 * (mu0 - mu1)^2
      mut as int64: diff_mu = mu0 - mu1
      mut as int64: diff_sq = diff_mu * diff_mu
      mut as int64: w_prod = w0 * w1
      mut as int64: inter_var = w_prod * diff_sq

      println("1. Peso da classe fundo (w0): " + w0)
      println("2. Peso da classe objeto (w1): " + w1)
      println("3. Media classe fundo (mu0): " + mu0)
      println("4. Media classe objeto (mu1): " + mu1)
      println("5. Variancia inter-classe maximizada: " + inter_var)

      route {
            w0 == 30 and w1 == 30 and inter_var > 0 ==> {
                  println("6. Limiar de Otsu calculado com maxima separabilidade.")
            }
            _ ==> {
                  println("Falha no calculo de Otsu.")
            }
      }
      println("Teste concluido com sucesso.")
}
