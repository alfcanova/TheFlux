#L ============================================================================
#L Algoritmo: Wilcoxon Signed-Rank Test (Teste Pareado de Postos Sinalizados)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Teste de postos com sinal para comparar amostras pareadas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaWilcoxonSignedRankTest) {
      println("=== Algoritmo: Wilcoxon Signed-Rank Test ===")

      #L Amostras pareadas antes (X) e depois (Y) de intervencao
      #L Sujeitos: 5 pares de dados
      #L X: [120, 135, 128, 140, 130]
      #L Y: [115, 138, 120, 132, 130]
      #L Diferencas d_i = X[i] - Y[i]:
      #L d = [+5, -3, +8, +8, 0]
      #L Descarta pares com diferenca zero: n_efetivo = 4
      mut as int64: n_efetivo = 4
      println("Pares com diferenca nao-nula: " + n_efetivo)

      #L Magnitudes absolutas ordenadas e postos atribuidos:
      #L |-3| = 3 -> posto 1 (negativo)
      #L |+5| = 5 -> posto 2 (positivo)
      #L |+8| = 8 -> posto 3 (positivo)
      #L |+8| = 8 -> posto 4 (positivo)
      mut as int64: w_pos = 2 + 3 + 4
      mut as int64: w_neg = 1

      println("Soma dos postos positivos W+: " + w_pos)
      println("Soma dos postos negativos W-: " + w_neg)

      #L Estatistica W = min(W+, W-)
      mut as int64: w_stat = w_neg
      route {
            w_pos < w_neg ==> {
                  w_stat = w_pos
            }
      }

      println("Estatistica de teste W: " + w_stat)

      route {
            w_stat <= 1 ==> {
                  println("Diferenca significativa detectada no nivel nominal")
            }
            w_stat > 1 ==> {
                  println("Evidencia insuficiente para rejeitar H0")
            }
      }

      println("Wilcoxon Signed-Rank Test concluido com sucesso.")
}
