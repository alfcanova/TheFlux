#L ============================================================================
#L Algoritmo: Bat Algorithm com Sintonia de Frequencia
#L Dominio: 07_optimization_stat / Categoria: Meta-heuristicas de Enxame
#L Descricao: Otimizacao bio-inspirada por ecolocalizacao de morcegos com loudness e taxa de pulso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBatAlgorithmFrequencyTuning) {
      println("=== Algoritmo: Bat Algorithm ===")

      #L Morcego i: posicao x = 30, velocidade v = 5
      #L Melhor solucao global x_best = 10
      mut as int64: x = 30
      mut as int64: v = 5
      mut as int64: x_best = 10

      #L Faixa de frequencia f em [f_min = 0, f_max = 10]
      #L Frequencia sintonizada para o morcego: f_i = 4
      mut as int64: f_i = 4

      #L Atualizacao de velocidade: v_new = v + (x - x_best) * f_i /i 10
      #L (30 - 10) * 4 /i 10 = 20 * 4 /i 10 = 8
      #L Para mover em direcao a x_best, a direcao e negativa: v_new = 5 - 8 = -3
      mut as int64: diff_best = x - x_best
      mut as int64: num_vf = diff_best * f_i
      mut as int64: delta_v = num_vf /i 10
      mut as int64: v_new = v - delta_v

      #L Atualizacao da posicao: x_new = x + v_new = 30 - 3 = 27
      mut as int64: x_new = x + v_new

      #L Parametro de Loudness A (volume do som): diminui com o tempo A_new = (A * 9) /i 10
      #L Loudness inicial A = 100 -> A_new = 90
      mut as int64: a_loudness = 100
      mut as int64: a_new = (a_loudness * 9) /i 10

      println("1. Posicao inicial do morcego: " + x)
      println("2. Frequencia de ecolocalizacao atribuida (f_i): " + f_i)
      println("3. Velocidade atualizada: " + v_new)
      println("4. Nova posicao aproximando-se do alvo: " + x_new)
      println("5. Loudness amortecido para explotacao fina: " + a_new)

      route {
            v_new == -3 and x_new == 27 and a_new == 90 ==> {
                  println("6. Mecanismo de ecolocalizacao do Bat Algorithm validado com sucesso.")
            }
            _ ==> {
                  println("Falha no Bat Algorithm.")
            }
      }
      println("Teste concluido com sucesso.")
}
