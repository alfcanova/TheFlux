#L ============================================================================
#L Algoritmo: Metaheuristic Optimization (Recozimento Simulado / Annealing)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(Iteracoes) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasMetaheuristicOptimization) {
      println("==================================================")
      println("  SciAlgo: Metaheuristic Optimization (Simulated Annealing)")
      println("==================================================")

      #L Paisagem de energia com multiplos minimos locais (Estados 1..15)
      #L Minimo global esta no estado 9 (energia 5). Minimos locais em 3 (18) e 6 (12).
      mut as list of int64: landscape = [45, 30, 18, 25, 35, 12, 28, 40, 5, 22, 38, 15, 29, 36, 50]
      mut as int64: n_states = listLength(landscape)
      println("1. Paisagem de energia (15 estados com minimos locais):")
      println("   " + landscape)

      #L PRNG LCG deterministico
      mut as int64: seed = 777123456
      mut as int64: lcg_m = 2147483647
      mut as int64: lcg_a = 48271

      #L Parametros do Recozimento Simulado (Simulated Annealing)
      mut as int64: current_state = 1
      mut as int64: current_energy = landscape[current_state]
      mut as int64: best_state = current_state
      mut as int64: best_energy = current_energy
      mut as int64: temp = 100
      mut as int64: iterations = 40
      mut as int64: accepted_uphill = 0
      mut as int64: iter = 1

      println("2. Estado inicial: " + current_state + " (Energia = " + current_energy + ") | Temp inicial = " + temp)

      infinite (iter <= iterations and temp > 0) {
            #L Gera vizinho no espaco 1D (x - 1 ou x + 1)
            seed = ((seed * lcg_a) + 1) /r lcg_m
            route {
                  seed < 0 ==> {
                        seed = 0 - seed
                  }
                  _ ==> {
                  }
            }
            mut as int64: dir = (seed /r 2)
            mut as int64: next_state = current_state
            route {
                  dir == 0 ==> {
                        next_state = current_state - 1
                  }
                  _ ==> {
                        next_state = current_state + 1
                  }
            }

            #L Limites de contorno do espaco de busca [1, 15]
            route {
                  next_state < 1 ==> {
                        next_state = 2
                  }
                  next_state > n_states ==> {
                        next_state = n_states - 1
                  }
                  _ ==> {
                  }
            }

            mut as int64: next_energy = landscape[next_state]
            mut as int64: delta_e = next_energy - current_energy

            mut as bool: accept_move = false
            route {
                  delta_e <= 0 ==> {
                        #L Melhora energetica: sempre aceita
                        accept_move = true
                  }
                  _ ==> {
                        #L Piora energetica: aceita com probabilidade de Boltzmann proporcional a Temperatura
                        #L Limiar aproximado deterministico: P = (100 * temp) / (temp + delta_e * 8)
                        mut as int64: prob_threshold = (100 * temp) /i (temp + (delta_e * 8))
                        seed = ((seed * lcg_a) + 1) /r lcg_m
                        route {
                              seed < 0 ==> {
                                    seed = 0 - seed
                              }
                              _ ==> {
                              }
                        }
                        mut as int64: roll = seed /r 100
                        route {
                              roll < prob_threshold ==> {
                                    accept_move = true
                                    accepted_uphill = accepted_uphill + 1
                              }
                              _ ==> {
                              }
                        }
                  }
            }

            route {
                  accept_move ==> {
                        current_state = next_state
                        current_energy = next_energy
                        route {
                              current_energy < best_energy ==> {
                                    best_energy = current_energy
                                    best_state = current_state
                              }
                              _ ==> {
                              }
                        }
                  }
                  _ ==> {
                  }
            }

            #L Resfriamento geometrico: T = T * 0.92
            temp = (temp * 92) /i 100
            iter = iter + 1
      }

      println("3. Movimentos de subida aceitos (escapes de minimos locais): " + accepted_uphill)
      println("4. Melhor estado alcancado: " + best_state)
      println("5. Menor energia alcancada: " + best_energy)
      println("Concluido com Sucesso")
}
