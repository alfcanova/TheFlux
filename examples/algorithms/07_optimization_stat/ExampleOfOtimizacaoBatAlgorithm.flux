#L ============================================================================
#L Algoritmo: Bat Algorithm (Algoritmo do Morcego - Xin-She Yang, 2010)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBatAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Bat Algorithm (Echolocation Search)")
      println("==================================================")

      #L O algoritmo do morcego simula a ecolocalizacao de micro-morcegos:
      #L Frequencia sonora f_i varia de f_min a f_max
      #L Velocidade: v_i(t) = v_i(t-1) + (x_i(t-1) - x*) * f_i
      #L Posicao: x_i(t) = x_i(t-1) + v_i(t)
      #L Emissao de pulsos e volume sonoro (loudness) A_i decrescem com a convergencia.

      mut as int64: x_star = 45 #L melhor posicao global conhecida (presa)
      mut as int64: x_bat = 110 #L morcego individual
      mut as int64: v_bat = 0   #L velocidade inicial
      mut as int64: loudness = 100 #L intensidade sonora inicial

      println("1. Parametros iniciais:")
      println("   Morcego x = " + x_bat + " | Presa alvo x* = " + x_star)

      mut as int64: iter = 1
      infinite (iter <= 6) {
            #L Frequencia f_i (escala 1 a 3)
            mut as int64: freq = 1 + (iter /r 3)

            #L Atualizacao de velocidade em direcao a melhor solucao
            v_bat = (x_star - x_bat) /i 2

            #L Atualizacao de posicao
            x_bat = x_bat + v_bat

            #L Decaimento de loudness e aproximacao refinada
            loudness = (loudness * 8) /i 10

            println("   Iteracao " + iter + ": Posicao = " + x_bat + " | Velocidade = " + v_bat)
            iter = iter + 1
      }

      println("2. Posicao final do morcego: " + x_bat)

      route {
            x_bat >= 44 and x_bat <= 46 ==> {
                  println("   [PASS] Morcego convergiu com precisao de ecolocalizacao na presa!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Bat Algorithm.")
            }
      }

      println("==================================================")
      println("Bat Algorithm concluido com sucesso!")
}
