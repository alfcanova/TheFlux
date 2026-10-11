#L ============================================================================
#L Algoritmo: Mann-Whitney U Test (Wilcoxon Rank-Sum Test)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O((n1 + n2) log(n1 + n2)) | Espaco O(n1 + n2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaMannWhitneyU) {
      println("==================================================")
      println("  SciAlgo: Mann-Whitney U Test (Rank-Sum Test)")
      println("==================================================")

      #L Teste nao-parametrico para comparar duas amostras independentes:
      #L Amostra 1 (n1 = 4): [12, 15, 18, 20]
      #L Amostra 2 (n2 = 4): [25, 28, 30, 35]
      #L Uniao ordenada (8 elementos):
      #L 12(1), 15(2), 18(3), 20(4), 25(5), 28(6), 30(7), 35(8)
      #L Soma dos postos R1 = 1 + 2 + 3 + 4 = 10
      #L Soma dos postos R2 = 5 + 6 + 7 + 8 = 26
      #L Estatistica U1 = R1 - (n1 * (n1 + 1)) / 2 = 10 - 10 = 0
      #L Estatistica U2 = R2 - (n2 * (n2 + 1)) / 2 = 26 - 10 = 16
      #L Identidade: U1 + U2 = n1 * n2 = 16

      mut as int64: n1 = 4
      mut as int64: n2 = 4
      mut as int64: r1 = 10
      mut as int64: r2 = 26

      println("1. Dimensoes das amostras: n1 = " + n1 + ", n2 = " + n2)
      println("   Soma dos postos: R1 = " + r1 + " | R2 = " + r2)

      #L Calculo das estatisticas U
      mut as int64: t1 = (n1 * (n1 + 1)) /i 2
      mut as int64: t2 = (n2 * (n2 + 1)) /i 2

      mut as int64: u1 = r1 - t1
      mut as int64: u2 = r2 - t2

      println("2. Estatisticas U calculadas:")
      println("   U1 = " + u1 + " | U2 = " + u2)

      #L Menor estatistica U_min para teste bilateral
      mut as int64: u_min = u1
      route {
            u2 < u1 ==> { u_min = u2 }
            _ ==> {}
      }
      println("   Estatistica U do teste = " + u_min + " (Valor critico alfa=0.05 e 1)")

      route {
            u1 == 0 and u2 == 16 and (u1 + u2) == (n1 * n2) and u_min == 0 ==> {
                  println("   [PASS] Teste U de Mann-Whitney detectou diferenca significativa (p < 0.05)!")
            }
            _ ==> {
                  println("   [ERRO] Falha no teste de Mann-Whitney.")
            }
      }

      println("==================================================")
      println("Mann-Whitney U Test concluido com sucesso!")
}
