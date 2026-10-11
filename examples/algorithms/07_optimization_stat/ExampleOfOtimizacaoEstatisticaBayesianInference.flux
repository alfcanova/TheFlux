#L ============================================================================
#L Algoritmo: Bayesian Inference (Conjugada Beta-Binomial)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(1) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaBayesianInference) {
      println("==================================================")
      println("  SciAlgo: Bayesian Inference (Beta-Binomial)")
      println("==================================================")

      #L Prior: Beta(alpha=2, beta=2) (distribuicao a priori)
      mut as int64: alpha_prior = 2
      mut as int64: beta_prior = 2

      #L Evidencia observada: 8 sucessos em 10 ensaios
      mut as int64: sucessos = 8
      mut as int64: falhas = 2

      #L Atualizacao conjugada a posteriori: Beta(alpha + s, beta + f)
      mut as int64: alpha_post = alpha_prior + sucessos  #L 10
      mut as int64: beta_post = beta_prior + falhas      #L 4

      #L Media a posteriori = alpha / (alpha + beta)
      mut as int64: post_mean_pct = (alpha_post * 100) /i (alpha_post + beta_post) #L 1000 / 14 = 71%

      println("1. Prior: Beta(2, 2)")
      println("2. Evidencia: " + sucessos + " sucessos, " + falhas + " falhas")
      println("3. Posterior analitica: Beta(" + alpha_post + ", " + beta_post + ")")
      println("   -> Media a posteriori estimada: " + post_mean_pct + "%")

      route {
            post_mean_pct == 71 ==> {
                  println("   [PASS] Inferencia Bayesiana conjugada computada com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia na inferencia Bayesiana.")
            }
      }

      println("==================================================")
      println("Bayesian Inference concluido com sucesso!")
}
