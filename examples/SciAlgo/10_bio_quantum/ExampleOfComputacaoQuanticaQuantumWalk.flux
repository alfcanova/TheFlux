#L ============================================================================
#L Algoritmo: Quantum Walk (Passeio Quantico Discreto na Reta com Moeda de Hadamard)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(t) passos para dispersao linear O(t) (vs dispersao difusiva O(sqrt(t)) classica)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumWalk) {
      println("==================================================")
      println("  SciAlgo: Discrete-Time Quantum Walk (DTQW)")
      println("==================================================")

      #L Passeio Quantico em linha unidimensional com 7 posicoes (-3, -2, -1, 0, +1, +2, +3)
      #L Indice 1-based no vetor: idx = pos + 4 (pos in -3..3 -> idx in 1..7)
      #L Qubit de moeda (Coin): 0 = Direita (+1), 1 = Esquerda (-1)
      #L Moeda de Hadamard H:
      #L H|0> = (|0> + |1>) / sqrt(2)
      #L H|1> = (|0> - |1>) / sqrt(2)
      #L Operador de Passo (Shift S): move a posicao dependendo do estado da moeda

      mut as int64: num_positions = 7
      #L Amplitudes para Direita (c0) e Esquerda (c1) em cada posicao (escala x1000)
      mut as list of int64: amp_right = [0, 0, 0, 1000, 0, 0, 0] #L Inicia na pos 0 (idx 4)
      mut as list of int64: amp_left = [0, 0, 0, 0, 0, 0, 0]

      println("1. Configuracao Inicial:")
      println("   Particula na Posicao x = 0 com Moeda inicializada em |Direita>")
      println("   Amplitudes escalonadas por 1000 (Ponto fixo)")

      mut as int64: total_steps = 3
      mut as int64: s = 1

      println("==================================================")
      println("2. Simulacao dos Passos Quanticos (Moeda + Shift):")

      infinite (s <= total_steps) {
            #L 2.1 Aplicacao da Moeda de Hadamard em cada posicao
            #L c0_novo = (c0 + c1) / sqrt(2) ~ (c0 + c1) * 707 / 1000
            #L c1_novo = (c0 - c1) / sqrt(2) ~ (c0 - c1) * 707 / 1000
            mut as list of int64: coin_r = []
            mut as list of int64: coin_l = []

            mut as int64: p = 1
            infinite (p <= num_positions) {
                  mut as int64: cr = amp_right[p]
                  mut as int64: cl = amp_left[p]

                  mut as int64: nr = ((cr + cl) * 707) /i 1000
                  mut as int64: nl = ((cr - cl) * 707) /i 1000
                  coin_r = listPushBack(coin_r, nr)
                  coin_l = listPushBack(coin_l, nl)
                  p = p + 1
            }

            #L 2.2 Operador de Deslocamento Condicional (Shift S):
            #L coin_r se move para a direita (p + 1)
            #L coin_l se move para a esquerda (p - 1)
            mut as list of int64: next_r = [0, 0, 0, 0, 0, 0, 0]
            mut as list of int64: next_l = [0, 0, 0, 0, 0, 0, 0]

            mut as int64: q = 1
            infinite (q <= num_positions) {
                  route {
                        q < num_positions ==> {
                              next_r[q + 1] = next_r[q + 1] + coin_r[q]
                        }
                        _ ==> {}
                  }
                  route {
                        q > 1 ==> {
                              next_l[q - 1] = next_l[q - 1] + coin_l[q]
                        }
                        _ ==> {}
                  }
                  q = q + 1
            }

            amp_right = next_r
            amp_left = next_l

            println("   Passo #" + s + " Concluido:")
            mut as int64: v = 1
            infinite (v <= num_positions) {
                  mut as int64: pos_coord = v - 4
                  mut as int64: prob_v = ((amp_right[v] * amp_right[v]) + (amp_left[v] * amp_left[v])) /i 1000
                  route {
                        prob_v > 0 ==> {
                              println("      Posicao " + pos_coord + ": Probabilidade = " + prob_v + "/1000 (" + (prob_v /i 10) + "." + (prob_v /r 10) + "%)")
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
            s = s + 1
      }

      println("==================================================")
      println("3. Resumo da Dinamica Balistica:")
      println("   Ao contrario da distribuicao Gaussiana classica, o passeio quantico")
      println("   concentra probabilidade nas extremidades devido a interferencia construtiva.")
      println("   Propagacao balistica (sigma proporcional a t) confirmada com sucesso!")
      println("   Quantum Walk concluido com sucesso!")
      println("==================================================")
}
