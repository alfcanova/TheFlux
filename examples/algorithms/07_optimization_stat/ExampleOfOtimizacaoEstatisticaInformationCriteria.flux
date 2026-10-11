#L ============================================================================
#L Algoritmo: Criterios de Informacao AIC e BIC (Akaike & Bayesian Criteria)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(1) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaInformationCriteria) {
      println("==================================================")
      println("  SciAlgo: Information Criteria (AIC & BIC)")
      println("==================================================")

      #L Criterios de selecao parcimoniosa de modelos:
      #L AIC (Akaike) = 2*k - 2*ln(L)
      #L BIC (Schwarz) = k*ln(n) - 2*ln(L)
      #L n: numero de observacoes (ex: n = 100 -> ln(n) ~ 4.6, escala x10 = 46)
      #L -2*ln(L): desvio (deviance) residual
      #L Comparacao entre Modelo 1 (simples, k=2) e Modelo 2 (complexo, k=5):
      #L Modelo 1: k1 = 2, deviance1 = 120
      #L   AIC1 = 2*2 + 120 = 124
      #L   BIC1 = (2 * 46) / 10 + 120 = 9 + 120 = 129
      #L Modelo 2: k2 = 5, deviance2 = 110 (pouco melhor no ajuste, mas com mais parametros)
      #L   AIC2 = 2*5 + 110 = 120
      #L   BIC2 = (5 * 46) / 10 + 110 = 23 + 110 = 133

      mut as int64: n = 100
      mut as int64: ln_n_x10 = 46 #L ln(100) = 4.605 (escala x10)

      #L Modelo 1 (k=2)
      mut as int64: k1 = 2
      mut as int64: dev1 = 120
      mut as int64: aic1 = (2 * k1) + dev1
      mut as int64: bic1 = ((k1 * ln_n_x10) /i 10) + dev1

      #L Modelo 2 (k=5)
      mut as int64: k2 = 5
      mut as int64: dev2 = 110
      mut as int64: aic2 = (2 * k2) + dev2
      mut as int64: bic2 = ((k2 * ln_n_x10) /i 10) + dev2

      println("1. Avaliacao do Modelo 1 (k = 2):")
      println("   Deviance = " + dev1 + " | AIC = " + aic1 + " | BIC = " + bic1)

      println("2. Avaliacao do Modelo 2 (k = 5):")
      println("   Deviance = " + dev2 + " | AIC = " + aic2 + " | BIC = " + bic2)

      #L Selecao: BIC penaliza mais fortemente a complexidade, favorecendo o Modelo 1
      mut as int64: best_model_bic = 1
      route {
            bic2 < bic1 ==> { best_model_bic = 2 }
            _ ==> { best_model_bic = 1 }
      }

      println("3. Modelo selecionado pelo criterio BIC: Modelo " + best_model_bic)

      route {
            aic1 == 124 and aic2 == 120 and bic1 == 129 and bic2 == 133 and best_model_bic == 1 ==> {
                  println("   [PASS] AIC e BIC computados e penalidade de complexidade validada!")
            }
            _ ==> {
                  println("   [ERRO] Falha nos criterios de informacao AIC/BIC.")
            }
      }

      println("==================================================")
      println("Information Criteria concluido com sucesso!")
}
