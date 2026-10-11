#L ============================================================================
#L Algoritmo: MCMC Metropolis-Hastings com Burn-in
#L Dominio: 07_optimization_stat / Categoria: Amostragem e Simulacao Estocastica
#L Descricao: Cadeia de Markov para amostragem probabilistica com criterio de aceitacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaMarkovChainMonteCarloMetropolis) {
      println("=== Algoritmo: MCMC Metropolis-Hastings com Burn-in ===")

      #L Estado inicial da cadeia x_0 = 10 (fora da regiao central x ~ 0)
      mut as int64: current_x = 10
      mut as int64: burn_in_steps = 4
      mut as int64: sample_steps = 6

      #L Gerador pseudo-aleatorio estavel e livre de overflow de 64 bits
      mut as int64: rng_state = 29

      #L Fase 1: Burn-in (convergencia para a distribuicao estacionaria)
      println("Iniciando fase de Burn-in (4 passos)...")
      mut as int64: step = 1
      infinite (step <= burn_in_steps) {
            #L Proposta de perturbacao dx em {-2, +2}
            rng_state = (rng_state * 79 + 17) /r 100
            mut as int64: dx = 2
            route {
                  rng_state < 50 ==> {
                        dx = -2
                  }
            }
            mut as int64: cand_x = current_x + dx

            mut as int64: cur_e = current_x * current_x
            mut as int64: cand_e = cand_x * cand_x

            #L Aceitacao em direcao a menor energia (maior probabilidade)
            route {
                  cand_e <= cur_e ==> {
                        current_x = cand_x
                  }
                  cand_e > cur_e ==> {
                        mut as int64: delta_e = cand_e - cur_e
                        route {
                              delta_e <= 10 ==> {
                                    current_x = cand_x
                              }
                        }
                  }
            }

            step = step + 1
      }

      println("Estado apos Burn-in: x = " + current_x)

      #L Fase 2: Amostragem estacionaria
      println("Iniciando fase de amostragem (6 passos)...")
      mut as int64: sum_samples = 0
      mut as int64: accepted_count = 0

      step = 1
      infinite (step <= sample_steps) {
            rng_state = (rng_state * 79 + 17) /r 100
            mut as int64: dx_s = 2
            route {
                  rng_state < 50 ==> {
                        dx_s = -2
                  }
            }
            mut as int64: cand_xs = current_x + dx_s

            mut as int64: cur_es = current_x * current_x
            mut as int64: cand_es = cand_xs * cand_xs

            route {
                  cand_es <= cur_es ==> {
                        current_x = cand_xs
                        accepted_count = accepted_count + 1
                  }
                  cand_es > cur_es ==> {
                        mut as int64: delta_es = cand_es - cur_es
                        route {
                              delta_es <= 5 ==> {
                                    current_x = cand_xs
                                    accepted_count = accepted_count + 1
                              }
                        }
                  }
            }

            sum_samples = sum_samples + current_x
            step = step + 1
      }

      mut as int64: mean_x = sum_samples /i sample_steps
      println("Passos de amostragem coletados: " + sample_steps)
      println("Propostas aceitas: " + accepted_count)
      println("Media amostral posterior: " + mean_x)

      println("MCMC Metropolis-Hastings concluido com sucesso.")
}
