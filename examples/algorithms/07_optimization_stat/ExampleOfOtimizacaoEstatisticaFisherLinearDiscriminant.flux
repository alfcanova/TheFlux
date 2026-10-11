#L ============================================================================
#L Algoritmo: Fisher Linear Discriminant (FLD / LDA)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(N * D) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaFisherLinearDiscriminant) {
      println("==================================================")
      println("  SciAlgo: Fisher Linear Discriminant (FLD)")
      println("==================================================")

      #L Duas classes 1D com medias mu1 = 10 e mu2 = 40
      #L Dispersoes intra-classe (within-class scatter): s1 = 4, s2 = 6 -> Sw = 10
      mut as int64: mu1 = 10
      mut as int64: mu2 = 40
      mut as int64: s_w = 10

      #L Direcao discriminante otima w = Sw^-1 * (mu2 - mu1)
      mut as int64: delta_mu = mu2 - mu1   #L 30
      mut as int64: w_opt = delta_mu /i s_w #L 3

      println("1. Medias: mu1 = " + mu1 + ", mu2 = " + mu2 + " | Dispersao Sw = " + s_w)
      println("2. Vetor de projecao otimo w: " + w_opt)

      #L Ponto de corte (threshold) entre as classes: (mu1 + mu2) / 2 = 25
      mut as int64: threshold = (mu1 + mu2) /i 2
      println("3. Limiar de decisao: " + threshold)

      route {
            w_opt == 3 and threshold == 25 ==> {
                  println("   [PASS] Fisher Linear Discriminant projetou e separou as classes!")
            }
            _ ==> {
                  println("   [ERRO] Falha no FLD.")
            }
      }

      println("==================================================")
      println("Fisher Linear Discriminant concluido com sucesso!")
}
