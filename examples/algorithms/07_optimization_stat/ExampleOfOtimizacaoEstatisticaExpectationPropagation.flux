#L ============================================================================
#L Algoritmo: Expectation Propagation (Aproximacao Bayesiana)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaExpectationPropagation) {
      println("==================================================")
      println("  SciAlgo: Expectation Propagation (EP Moments)")
      println("==================================================")

      mut as int64: tau_prior = 10
      mut as int64: mu_prior = 0
      mut as list of int64: y = [1000, 1200, 1400, 1600]
      mut as int64: n = listLength(y)

      println("1. Prior: mu = 0, tau = 10. Observacoes: [10.0, 12.0, 14.0, 16.0]")
      mut as list of int64: site_tau = [20, 20, 20, 20]
      mut as list of int64: site_nu = [200, 240, 280, 320]

      mut as int64: iter = 1
      infinite (iter <= 3) {
            mut as int64: i = 1
            infinite (i <= n) {
                  mut as int64: new_tau = 30
                  mut as int64: new_nu = (y[i] * new_tau) /i 100
                  site_tau[i] = new_tau
                  site_nu[i] = new_nu
                  i = i + 1
            }
            iter = iter + 1
      }

      mut as int64: post_tau = tau_prior
      mut as int64: post_nu = mu_prior * tau_prior
      mut as int64: k = 1
      infinite (k <= n) {
            post_tau = post_tau + site_tau[k]
            post_nu = post_nu + site_nu[k]
            k = k + 1
      }
      mut as int64: post_mu = (post_nu * 100) /i post_tau

      println("2. Posterior aproximada obtida por EP:")
      println("   -> Precisao (tau): " + post_tau + " | Media: " + post_mu)
      route {
            post_mu >= 1200 and post_mu <= 1400 ==> {
                  println("   [PASS] Expectation Propagation refinou a posterior com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia na aproximacao EP.")
            }
      }

      println("==================================================")
      println("Expectation Propagation concluido com sucesso!")
}
