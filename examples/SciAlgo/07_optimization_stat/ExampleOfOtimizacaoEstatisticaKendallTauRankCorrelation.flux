#L ============================================================================
#L Algoritmo: Kendall's Tau Rank Correlation (Coeficiente de Correlacao Tau)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Coeficiente de correlacao de postos baseado em pares concordantes e discordantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKendallTauRankCorrelation) {
      println("=== Algoritmo: Kendall's Tau Rank Correlation ===")

      #L Amostra bivariada de tamanho n = 5
      #L Ranks observados de X e Y:
      #L Item 1: X = 1, Y = 1
      #L Item 2: X = 2, Y = 3
      #L Item 3: X = 3, Y = 2
      #L Item 4: X = 4, Y = 4
      #L Item 5: X = 5, Y = 5
      mut as int64: n = 5
      mut as int64: total_pairs = 10

      #L Analise de todos os 10 pares (i < j):
      #L Par (1,2): X cresce (1->2), Y cresce (1->3) -> Concordante
      #L Par (1,3): X cresce (1->3), Y cresce (1->2) -> Concordante
      #L Par (1,4): X cresce (1->4), Y cresce (1->4) -> Concordante
      #L Par (1,5): X cresce (1->5), Y cresce (1->5) -> Concordante
      #L Par (2,3): X cresce (2->3), Y decresce (3->2) -> Discordante
      #L Par (2,4): X cresce (2->4), Y cresce (3->4) -> Concordante
      #L Par (2,5): X cresce (2->5), Y cresce (3->5) -> Concordante
      #L Par (3,4): X cresce (3->4), Y cresce (2->4) -> Concordante
      #L Par (3,5): X cresce (3->5), Y cresce (2->5) -> Concordante
      #L Par (4,5): X cresce (4->5), Y cresce (4->5) -> Concordante

      #L Contagem: Concordantes = 9, Discordantes = 1
      mut as int64: concordant = 9
      mut as int64: discordant = 1

      println("Total de pares combinatorios: " + total_pairs)
      println("Pares concordantes (C): " + concordant)
      println("Pares discordantes (D): " + discordant)

      #L Tau = (C - D) / total_pairs
      #L Tau = (9 - 1) / 10 = 8 / 10 = 0.8
      mut as int64: diff_cd = concordant - discordant
      mut as int64: tau_num = diff_cd * 1000
      mut as int64: tau_x1000 = tau_num /i total_pairs

      mut as int64: tau_int = tau_x1000 /i 1000
      mut as int64: tau_dec = tau_x1000 /r 1000
      println("Kendall Tau (x1000): " + tau_x1000)
      println("Coeficiente Tau: " + tau_int + "." + tau_dec)

      route {
            tau_x1000 >= 700 ==> {
                  println("Interpretacao: Forte correlacao positiva entre os postos")
            }
            tau_x1000 < 700 ==> {
                  println("Interpretacao: Correlacao moderada ou fraca")
            }
      }

      println("Kendall's Tau Rank Correlation concluido com sucesso.")
}
