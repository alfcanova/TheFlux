#L ============================================================================
#L Algoritmo: Bayesian Optimization com Expected Improvement (EI)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao Bayesiana
#L Descricao: Funcao de aquisicao EI para otimizacao eficiente de funcoes caras de caixa-preta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBayesianOptExpectedImprovement) {
      println("=== Algoritmo: Bayesian Optimization (Expected Improvement) ===")

      #L Melhor valor observado ate o momento (maximizacao): f_best = 100
      mut as int64: f_best = 100

      #L Ponto Candidato A (alta exploracao): media mu = 95, incerteza/desvio sigma = 30
      #L Ponto Candidato B (alta explotacao): media mu = 108, incerteza sigma = 5

      #L Melhora prevista sobre f_best:
      #L Ponto A: delta_mu = 95 - 100 = -5 (media abaixo do melhor)
      #L Incerteza sigma_A = 30 oferece grande potencial de superacao!
      #L Expected Improvement aproximado EI = max(0, delta_mu) + (sigma * 40) /i 100
      #L EI_A = 0 + (30 * 40) /i 100 = 12
      mut as int64: sigma_A = 30
      mut as int64: ei_A = (sigma_A * 40) /i 100

      #L Ponto B: delta_mu = 108 - 100 = 8 (ja supera f_best)
      #L EI_B = delta_mu + (sigma_B * 40) /i 100 = 8 + (5 * 40) /i 100 = 8 + 2 = 10
      mut as int64: delta_mu_B = 108 - 100
      mut as int64: sigma_B = 5
      mut as int64: bonus_B = (sigma_B * 40) /i 100
      mut as int64: ei_B = delta_mu_B + bonus_B

      println("1. Melhor valor atual (f_best): " + f_best)
      println("2. Score de aquisicao EI do Candidato A (exploratorio): " + ei_A)
      println("3. Score de aquisicao EI do Candidato B (explotativo): " + ei_B)

      #L Selecao da proxima amostra de teste cara: candidato com maior EI
      mut as int64: proximoPonto = 1
      route {
            ei_A > ei_B ==> {
                  proximoPonto = 1
            }
            _ ==> {
                  proximoPonto = 2
            }
      }

      println("4. Candidato escolhido para avaliacao cara: Ponto " + proximoPonto)

      route {
            ei_A == 12 and ei_B == 10 and proximoPonto == 1 ==> {
                  println("5. Selecao bayesiana de aquisicao balanceada validada.")
            }
            _ ==> {
                  println("Falha na otimizacao bayesiana.")
            }
      }
      println("Teste concluido com sucesso.")
}
