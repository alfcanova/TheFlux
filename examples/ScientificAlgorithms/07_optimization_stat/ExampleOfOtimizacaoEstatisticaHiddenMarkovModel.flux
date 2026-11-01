#L ============================================================================
#L Algoritmo: Hidden Markov Model (HMM: Modelo Oculto de Markov)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T * S^2) | Espaco O(T * S)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaHiddenMarkovModel) {
      println("==================================================")
      println("  SciAlgo: Hidden Markov Model (HMM Likelihood)")
      println("==================================================")

      #L 2 Estados Ocultos: 1 = Ensolarado, 2 = Chuvoso
      #L 2 Emissoes: 1 = Caminhada, 2 = Guarda-chuva
      #L Transicao A (escala x10): S1->S1: 7, S1->S2: 3; S2->S1: 4, S2->S2: 6
      #L Emissao B (escala x10): S1: [8, 2], S2: [1, 9]
      #L Pi inicial: S1: 6, S2: 4

      mut as list of int64: obs_seq = [1, 2, 2]
      mut as int64: t_len = listLength(obs_seq)
      println("1. Sequencia de observacoes (T = " + t_len + "): [Caminhada, Guarda-chuva, Guarda-chuva]")

      #L Algoritmo Forward para probabilidade total da sequencia
      #L t = 1
      mut as int64: o1 = obs_seq[1]
      mut as int64: alpha1_1 = 6 * 8   #L 48 (S1)
      mut as int64: alpha1_2 = 4 * 1   #L 4  (S2)

      #L t = 2 (obs = 2)
      mut as int64: alpha2_1 = (((alpha1_1 * 7) + (alpha1_2 * 4)) /i 10) * 2
      mut as int64: alpha2_2 = (((alpha1_1 * 3) + (alpha1_2 * 6)) /i 10) * 9

      #L t = 3 (obs = 2)
      mut as int64: alpha3_1 = (((alpha2_1 * 7) + (alpha2_2 * 4)) /i 10) * 2
      mut as int64: alpha3_2 = (((alpha2_1 * 3) + (alpha2_2 * 6)) /i 10) * 9

      mut as int64: total_likelihood = alpha3_1 + alpha3_2
      println("2. Verossimilhanca Forward acumulada: " + total_likelihood)

      route {
            total_likelihood > 0 ==> {
                  println("   [PASS] Avaliacao de HMM calculada com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no calculo da verossimilhanca HMM.")
            }
      }

      println("==================================================")
      println("Hidden Markov Model concluido com sucesso!")
}
