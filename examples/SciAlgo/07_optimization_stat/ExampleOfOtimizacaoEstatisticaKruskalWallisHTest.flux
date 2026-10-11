#L ============================================================================
#L Algoritmo: Kruskal-Wallis H Test (ANOVA Nao-Parametrica por Postos)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Teste de diferenca entre 3 ou mais grupos independentes via postos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKruskalWallisHTest) {
      println("=== Algoritmo: Kruskal-Wallis H Test ===")

      #L k = 3 grupos independentes com n = 3 observacoes cada
      #L N total = 9 observacoes
      mut as int64: k = 3
      mut as int64: n1 = 3
      mut as int64: n2 = 3
      mut as int64: n3 = 3
      mut as int64: big_n = 9

      #L Observacoes ordenadas e seus postos:
      #L Grupo 1 (controle):    postos 1, 2, 3 -> R1 = 6
      #L Grupo 2 (dose media):  postos 4, 5, 6 -> R2 = 15
      #L Grupo 3 (dose alta):   postos 7, 8, 9 -> R3 = 24
      mut as int64: r1 = 1 + 2 + 3
      mut as int64: r2 = 4 + 5 + 6
      mut as int64: r3 = 7 + 8 + 9

      println("Soma dos postos Grupo 1 (R1): " + r1)
      println("Soma dos postos Grupo 2 (R2): " + r2)
      println("Soma dos postos Grupo 3 (R3): " + r3)

      #L Termos R_j^2 / n_j
      mut as int64: r1_sq = r1 * r1
      mut as int64: term1 = r1_sq /i n1

      mut as int64: r2_sq = r2 * r2
      mut as int64: term2 = r2_sq /i n2

      mut as int64: r3_sq = r3 * r3
      mut as int64: term3 = r3_sq /i n3

      mut as int64: sum_r_norm = term1 + term2 + term3
      println("Soma normalizada sum(R_j^2 / n_j): " + sum_r_norm)

      #L Estatistica H = [12 / (N*(N+1))] * sum(R_j^2 / n_j) - 3*(N+1)
      #L Escalada por 100 para precisao inteira:
      #L N * (N + 1) = 9 * 10 = 90
      mut as int64: n_factor = big_n * 10
      mut as int64: h_num = 1200 * sum_r_norm
      mut as int64: h_termo1 = h_num /i n_factor
      mut as int64: h_termo2 = 300 * 10
      mut as int64: h_stat_x100 = h_termo1 - h_termo2

      mut as int64: h_int = h_stat_x100 /i 100
      mut as int64: h_dec = h_stat_x100 /r 100
      println("Estatistica H (x100): " + h_stat_x100)
      println("Estatistica H aproximada: " + h_int + "." + h_dec)

      #L Graus de liberdade df = k - 1 = 2
      #L Valor critico Qui-Quadrado (df=2, alpha=0.05) = 5.99 (599 em escala x100)
      route {
            h_stat_x100 >= 599 ==> {
                  println("Rejeita H0: Existe diferenca estatisticamente significativa entre os grupos")
            }
            h_stat_x100 < 599 ==> {
                  println("Nao rejeita H0: Sem diferenca significativa detectada")
            }
      }

      println("Kruskal-Wallis H Test concluido com sucesso.")
}
