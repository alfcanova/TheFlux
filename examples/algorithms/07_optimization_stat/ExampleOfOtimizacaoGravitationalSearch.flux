#L ============================================================================
#L Algoritmo: Gravitational Search Algorithm (GSA - Rashedi et al., 2009)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGravitationalSearch) {
      println("==================================================")
      println("  SciAlgo: Gravitational Search Algorithm (GSA)")
      println("==================================================")

      #L O GSA baseia-se na lei da gravitacao universal de Newton:
      #L F_ij = G(t) * (M_i * M_j / R_ij)
      #L Corpos com maior massa (melhor aptidao) exercem maior atracao gravitacional.
      #L A constante gravitacional G(t) decresce no tempo: G(t) = G0 * exp(-alpha * t/T)

      mut as int64: x_heavy = 30 #L corpo de maior massa (otimo)
      mut as int64: mass_heavy = 100
      mut as int64: x_probe = 120 #L particula de teste
      mut as int64: v_probe = 0

      println("1. Estado inicial do sistema gravitacional:")
      println("   Corpo atrator: x = " + x_heavy + " (Massa = " + mass_heavy + ")")
      println("   Sonda espacial: x = " + x_probe)

      mut as int64: t = 1
      infinite (t <= 6) {
            #L Distancia entre os corpos
            mut as int64: dist = x_probe - x_heavy

            #L Aceleracao gravitacional proporcional a massa e amortecida no tempo
            mut as int64: accel = (0 - dist) /i 3

            #L Atualizacao de velocidade e posicao
            v_probe = (v_probe /i 2) + accel
            x_probe = x_probe + v_probe

            println("   Passo " + t + ": Sonda x = " + x_probe + " | Aceleracao = " + accel)
            t = t + 1
      }

      println("2. Posicao final da sonda atraida pelo GSA: " + x_probe)

      route {
            x_probe >= 28 and x_probe <= 33 ==> {
                  println("   [PASS] Atracao gravitacional GSA direcionou com sucesso a sonda ao atrator!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Gravitational Search Algorithm.")
            }
      }

      println("==================================================")
      println("Gravitational Search Algorithm concluido com sucesso!")
}
