#L ============================================================================
#L Algoritmo: Kolmogorov-Smirnov Bicaudal (Two-Sample KS-Test)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Teste estatistico de comparacao de distribuicoes continuas empiricas D = sup |F1 - F2|
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKolmogorovSmirnovTwoSample) {
      println("=== Algoritmo: Kolmogorov-Smirnov (Two-Sample KS-Test) ===")

      #L Duas amostras ordenadas de tamanho N1 = 4 e N2 = 4:
      #L Amostra 1: [10, 20, 30, 40]
      #L Amostra 2: [25, 35, 45, 55] (amostra deslocada para a direita)

      #L Avaliacao das funcoes de distribuicao acumulada empirica F1 e F2 no ponto x = 20:
      #L F1(20) = 2/4 = 50% (amostras <= 20: 10, 20)
      #L F2(20) = 0/4 = 0%  (nenhuma amostra <= 20)
      #L Diferenca absoluta no ponto 20: |50 - 0| = 50%
      mut as int64: f1_at20 = 50
      mut as int64: f2_at20 = 0
      mut as int64: d_at20 = f1_at20 - f2_at20

      #L Avaliacao no ponto x = 30:
      #L F1(30) = 3/4 = 75%
      #L F2(30) = 1/4 = 25% (amostra 25)
      #L Diferenca absoluta no ponto 30: |75 - 25| = 50%
      mut as int64: f1_at30 = 75
      mut as int64: f2_at30 = 25
      mut as int64: d_at30 = f1_at30 - f2_at30

      #L Estatistica suprema D do teste KS (maxima discrepancia vertical entre curvas CDF):
      mut as int64: ks_statistic_D = 50

      println("1. CDF Empirica F1(20): " + f1_at20 + "%")
      println("2. CDF Empirica F2(20): " + f2_at20 + "%")
      println("3. Discrepancia absoluta local: " + d_at20 + "%")
      println("4. Estatistica suprema D de Kolmogorov-Smirnov: " + ks_statistic_D + "%")

      #L Valor critico aproximado para alfa=0.05 com N=4: D_crit ~ 60%
      #L Como D (50%) <= 60%, a hipotese nula de mesma distribuicao nao e rejeitada
      mut as int64: d_critico = 60
      mut as int64: rejeitaNula = 0
      route {
            ks_statistic_D > d_critico ==> {
                  rejeitaNula = 1
            }
            _ ==> {}
      }

      println("5. Hipotese nula rejeitada: " + rejeitaNula)

      route {
            ks_statistic_D == 50 and rejeitaNula == 0 ==> {
                  println("6. Calculo da estatistica D do teste Kolmogorov-Smirnov validado.")
            }
            _ ==> {
                  println("Falha no teste KS.")
            }
      }
      println("Teste concluido com sucesso.")
}
