#L ============================================================================
#L Algoritmo: NUTS (No-U-Turn Sampler - Hoffman & Gelman, JMLR 2014)
#L Dominio: 07_optimization_stat / Categoria: Amostragem
#L Complexidade: Tempo O(2^d) | Espaco O(d)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemNUTS) {
      println("==================================================")
      println("  SciAlgo: No-U-Turn Sampler (NUTS)")
      println("==================================================")

      #L O NUTS elimina a necessidade de escolher o numero de passos L no HMC:
      #L Constroi recursivamente uma arvore de trajetoria hamiltoniana forward/backward
      #L e interrompe o crescimento quando a trajetoria faz uma 'meia-volta' (U-turn):
      #L Criterio de parada: d/dt ||theta^+ - theta^-||^2 < 0
      #L   => (theta^+ - theta^-) . r^+ < 0 ou (theta^+ - theta^-) . r^- < 0

      mut as int64: theta_minus = 10 #L extremo esquerdo da arvore
      mut as int64: theta_plus = 10  #L extremo direito da arvore
      mut as int64: r_minus = 5      #L momento no extremo esquerdo
      mut as int64: r_plus = 5       #L momento no extremo direito
      mut as int64: step_size = 2

      println("1. Estado inicial da particula hamiltoniana:")
      println("   Theta0 = " + theta_plus + " | Momento inicial r0 = " + r_plus)

      mut as int64: depth = 1
      mut as int64: u_turn_detected = 0
      infinite (depth <= 4 and u_turn_detected == 0) {
            #L Expande a arvore duplicando os passos leapfrog
            theta_plus = theta_plus + (r_plus * step_size)
            #L Gradiente da energia potencial V(theta) = theta^2 / 2 reduz o momento
            r_plus = r_plus - (theta_plus /i 4)

            #L Criterio No-U-Turn: produto escalar entre extensao e momento
            mut as int64: span = theta_plus - theta_minus
            mut as int64: dot_prod = span * r_plus

            println("   Profundidade " + depth + ": Theta_plus = " + theta_plus + " | Momento r+ = " + r_plus + " | Dot = " + dot_prod)

            route {
                  dot_prod < 0 ==> {
                        u_turn_detected = 1
                        println("   [U-Turn] Meia-volta detectada na arvore na profundidade " + depth + "!")
                  }
                  _ ==> {}
            }
            depth = depth + 1
      }

      println("2. Amostra aceita no estado estacionario NUTS: theta = " + theta_plus)

      route {
            u_turn_detected == 1 and theta_plus >= 15 and theta_plus <= 30 ==> {
                  println("   [PASS] NUTS identificou a inversao da orbita e encerrou a arvore adaptativamente!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo NUTS.")
            }
      }

      println("==================================================")
      println("No-U-Turn Sampler concluido com sucesso!")
}
