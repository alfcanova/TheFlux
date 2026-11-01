#L ============================================================================
#L Algoritmo: Viterbi (Decodificacao HMM para Bioinformatica)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(T * S^2) tempo | O(T * S) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaViterbi) {
      println("==================================================")
      println("  SciAlgo: Viterbi HMM State Decoding")
      println("==================================================")

      #L Estados Ocultos HMM: 1 = CpG Island (+), 2 = Regiao Neutra/Fundo (-)
      #L Observacoes (DNA): 1='A', 2='C', 3='G', 4='T'
      #L Sequencia Observada: "C G C G A T" -> [2, 3, 2, 3, 1, 4] (tam T=6)
      mut as list of int64: obs = [2, 3, 2, 3, 1, 4]
      mut as int64: t_len = 6
      mut as int64: num_states = 2

      println("1. Modelo HMM para Deteccao de Ilhas CpG:")
      println("   Estados: 1=CpG Island (+), 2=Fundo (-)")
      println("   Observacoes: C G C G A T (Comprimento T = " + t_len + ")")

      #L Matrizes de Escore Logaritmico Escalonado (Inteiros x10):
      #L Probabilidades Iniciais Pi:
      #L Pi[1] (CpG) = -7, Pi[2] (Fundo) = -7
      mut as list of int64: init_prob = [-7, -7]

      #L Transicoes Trans[from, to]:
      #L 1->1: -3, 1->2: -12
      #L 2->1: -16, 2->2: -2
      #L Indice: ((from - 1) * 2) + to
      mut as list of int64: trans = [
            -3,  -12, #L de 1 para 1 e 2
            -16, -2   #L de 2 para 1 e 2
      ]

      #L Emissoes Emiss[state, obs]:
      #L Estado 1 (CpG rico em C e G): A=-16, C=-6, G=-6, T=-16
      #L Estado 2 (Fundo rico em A e T): A=-6, C=-16, G=-16, T=-6
      #L Indice: ((state - 1) * 4) + obs
      mut as list of int64: emiss = [
            -16, -6,  -6,  -16, #L Estado 1 (CpG)
            -6,  -16, -16, -6   #L Estado 2 (Fundo)
      ]

      #L Trellis Viterbi V[t, state] e Ponteiros Ptr[t, state]
      #L Dimensoes: t in 1..t_len, state in 1..2
      mut as list of int64: v_table = []
      mut as list of int64: ptr_table = []
      mut as int64: total_cells = t_len * num_states
      mut as int64: z = 1
      infinite (z <= total_cells) {
            v_table = listPushBack(v_table, -999999)
            ptr_table = listPushBack(ptr_table, 0)
            z = z + 1
      }

      println("==================================================")
      println("2. Inicializacao do Trellis (t = 1):")

      mut as int64: s = 1
      infinite (s <= num_states) {
            mut as int64: e_idx = ((s - 1) * 4) + obs[1]
            mut as int64: initial_v = init_prob[s] + emiss[e_idx]
            v_table[((1 - 1) * 2) + s] = initial_v
            ptr_table[((1 - 1) * 2) + s] = 0
            println("   V[t=1, estado=" + s + "] = " + initial_v)
            s = s + 1
      }

      println("==================================================")
      println("3. Passo Indutivo de Programacao Dinamica (t = 2 .. T):")

      mut as int64: t = 2
      infinite (t <= t_len) {
            mut as int64: o = obs[t]
            mut as int64: s_cur = 1
            infinite (s_cur <= num_states) {
                  mut as int64: e_cost = emiss[((s_cur - 1) * 4) + o]
                  mut as int64: max_prev = -999999
                  mut as int64: best_prev_state = 1

                  mut as int64: s_prev = 1
                  infinite (s_prev <= num_states) {
                        mut as int64: prior_v = v_table[((t - 2) * 2) + s_prev]
                        mut as int64: tr_cost = trans[((s_prev - 1) * 2) + s_cur]
                        mut as int64: candidate = prior_v + tr_cost

                        route {
                              candidate > max_prev ==> {
                                    max_prev = candidate
                                    best_prev_state = s_prev
                              }
                              _ ==> {}
                        }
                        s_prev = s_prev + 1
                  }

                  mut as int64: cur_idx = ((t - 1) * 2) + s_cur
                  v_table[cur_idx] = max_prev + e_cost
                  ptr_table[cur_idx] = best_prev_state
                  s_cur = s_cur + 1
            }
            println("   Passo t=" + t + " (Obs=" + o + "): V[E1]=" + v_table[((t - 1) * 2) + 1] + " | V[E2]=" + v_table[((t - 1) * 2) + 2])
            t = t + 1
      }

      println("==================================================")
      println("4. Terminacao e Traceback do Caminho Otimo:")

      #L Escolhe o melhor estado final em t = t_len
      mut as int64: best_final_state = 1
      mut as int64: best_final_v = v_table[((t_len - 1) * 2) + 1]
      route {
            v_table[((t_len - 1) * 2) + 2] > best_final_v ==> {
                  best_final_v = v_table[((t_len - 1) * 2) + 2]
                  best_final_state = 2
            }
            _ ==> {}
      }

      #L Backtracking para reconstruir o caminho de estados
      mut as list of int64: path = []
      mut as int64: curr_s = best_final_state
      mut as int64: step = t_len
      infinite (step >= 1) {
            path = listPushBack(path, curr_s)
            curr_s = ptr_table[((step - 1) * 2) + curr_s]
            step = step - 1
      }

      println("   Escore Log-Odds Otimo: " + best_final_v)
      println("   Sequencia Oculta Mais Provavel (do fim ao inicio): " + path)
      println("   Anotacao: Primeiras 4 bases = Ilha CpG, Ultimas 2 bases = Fundo Neutro")
      println("   Viterbi concluido com sucesso!")
      println("==================================================")
}
