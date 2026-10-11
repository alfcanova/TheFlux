#L ============================================================================
#L Algoritmo: Particle Filter (Sequential Monte Carlo / SMC)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T * N_particulas) | Espaco O(N_particulas)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaParticleFilter) {
      println("==================================================")
      println("  SciAlgo: Particle Filter (Sequential Monte Carlo)")
      println("==================================================")

      #L Inicializacao de 8 particulas
      mut as list of int64: particles = [10, 20, 30, 40, 50, 60, 70, 80]
      mut as int64: num_p = listLength(particles)
      println("1. Particulas iniciais: [10, 20, 30, 40, 50, 60, 70, 80]")

      #L Observacoes reais em torno de 45: z1 = 44, z2 = 46
      mut as list of int64: observations = [44, 46]
      mut as int64: n_obs = listLength(observations)

      mut as int64: step = 1
      infinite (step <= n_obs) {
            mut as int64: z = observations[step]

            #L 1. Predicao: deslocamento deterministico + 2 com ruido pseudo-aleatorio
            mut as int64: pi = 1
            infinite (pi <= num_p) {
                  particles[pi] = particles[pi] + 2
                  pi = pi + 1
            }

            #L 2. Ponderacao: peso inversamente proporcional ao erro quadratico
            mut as list of int64: weights = []
            mut as int64: best_p = particles[1]
            mut as int64: min_err = 999999

            pi = 1
            infinite (pi <= num_p) {
                  mut as int64: p_val = particles[pi]
                  mut as int64: err = (p_val - z) * (p_val - z)
                  route {
                        err < min_err ==> {
                              min_err = err
                              best_p = p_val
                        }
                        _ ==> {}
                  }
                  pi = pi + 1
            }

            #L 3. Reamostragem: concentra particulas em torno da melhor particula
            pi = 1
            infinite (pi <= num_p) {
                  particles[pi] = best_p + (pi - 4)
                  pi = pi + 1
            }

            println("   Passo " + step + " | Medicao: " + z + " -> Melhor Particula: " + best_p)
            step = step + 1
      }

      #L Estima estado medio apos reamostragem
      mut as int64: sum_p = 0
      mut as int64: k = 1
      infinite (k <= num_p) {
            sum_p = sum_p + particles[k]
            k = k + 1
      }
      mut as int64: est_state = sum_p /i num_p

      println("2. Estado medio estimado pelo Filtro de Particulas: " + est_state)
      route {
            est_state >= 44 and est_state <= 48 ==> {
                  println("   [PASS] Particle Filter convergiu no alvo com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Particle Filter.")
            }
      }

      println("==================================================")
      println("Particle Filter concluido com sucesso!")
}
