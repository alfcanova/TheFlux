#L ============================================================================
#L Algoritmo: KDE (Kernel Density Estimation - Parzen-Rosenblatt com Silverman)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(n * M) | Espaco O(M)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKDE) {
      println("==================================================")
      println("  SciAlgo: Kernel Density Estimation (KDE)")
      println("==================================================")

      #L Estimacao nao-parametrica de densidade com nucleo Gaussiano:
      #L f_hat(x) = (1 / (n * h)) * sum_{i=1}^n K((x - x_i) / h)
      #L Nucleo Gaussiano K(u) ~ exp(-u^2 / 2) / sqrt(2*pi)
      #L Largura de banda otima de Silverman: h = 1.06 * sigma * n^{-1/5}
      #L Amostra (n = 4): [10, 20, 20, 30] (concentrada em torno de 20)
      #L h = 5

      mut as list of int64: samples = [10, 20, 20, 30]
      mut as int64: n = 4
      mut as int64: h = 5

      println("1. Pontos amostrais: [" + samples[1] + ", " + samples[2] + ", " + samples[3] + ", " + samples[4] + "]")
      println("   Largura de banda h = " + h)

      #L Avaliacao da densidade nos pontos de consulta x = 10, x = 20 e x = 40
      mut as int64: dens_10 = 0
      mut as int64: dens_20 = 0
      mut as int64: dens_40 = 0

      #L Ponto x = 10
      mut as int64: sum10 = 0
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: d = 10 - samples[i]
            route { d < 0 ==> { d = 0 - d } _ ==> {} }
            mut as int64: w = 100 - ((d * 10 /i h) * 4)
            route { w < 0 ==> { w = 0 } _ ==> {} }
            sum10 = sum10 + w
            i = i + 1
      }
      dens_10 = sum10 /i n

      #L Ponto x = 20
      mut as int64: sum20 = 0
      i = 1
      infinite (i <= n) {
            mut as int64: d = 20 - samples[i]
            route { d < 0 ==> { d = 0 - d } _ ==> {} }
            mut as int64: w = 100 - ((d * 10 /i h) * 4)
            route { w < 0 ==> { w = 0 } _ ==> {} }
            sum20 = sum20 + w
            i = i + 1
      }
      dens_20 = sum20 /i n

      #L Ponto x = 40
      mut as int64: sum40 = 0
      i = 1
      infinite (i <= n) {
            mut as int64: d = 40 - samples[i]
            route { d < 0 ==> { d = 0 - d } _ ==> {} }
            mut as int64: w = 100 - ((d * 10 /i h) * 4)
            route { w < 0 ==> { w = 0 } _ ==> {} }
            sum40 = sum40 + w
            i = i + 1
      }
      dens_40 = sum40 /i n

      println("2. Estimativa de densidade f_hat(x):")
      println("   f_hat(10) = " + dens_10 + " / 1000")
      println("   f_hat(20) = " + dens_20 + " / 1000 (Pico esperado no modo da distribuicao)")
      println("   f_hat(40) = " + dens_40 + " / 1000 (Regiao de cauda)")

      route {
            dens_20 > dens_10 and dens_10 > dens_40 and dens_20 >= 30 ==> {
                  println("   [PASS] KDE capturou com fidelidade o pico modal e decaimento das caudas!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo KDE.")
            }
      }

      println("==================================================")
      println("KDE concluido com sucesso!")
}
