#L ============================================================================
#L Algoritmo: Particle Swarm com Fator de Constricao de Clerc
#L Dominio: 07_optimization_stat / Categoria: Otimizacao por Enxame (PSO)
#L Descricao: Estabilizacao da convergencia de particulas com o coeficiente de constricao chi
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoParticleSwarmConstriction) {
      println("=== Algoritmo: PSO com Constricao de Clerc ===")

      #L Fator de constricao padrao chi = 0.729 (multiplicado por 1000 -> 729)
      mut as int64: chi_factor = 729

      #L Particula atual x = 20, velocidade v = 10
      #L Melhor individual pbest = 5 (termo cognitivo)
      #L Melhor global gbest = 2 (termo social)
      mut as int64: x = 20
      mut as int64: v = 10
      mut as int64: pbest = 5
      mut as int64: gbest = 2

      #L Coeficientes c1 = 2, c2 = 2
      #L delta_cognitivo = 2 * (5 - 20) = -30
      #L delta_social     = 2 * (2 - 20) = -36
      mut as int64: delta_cog = 2 * (pbest - x)
      mut as int64: delta_soc = 2 * (gbest - x)

      #L Soma de forcas: v + delta_cog + delta_soc = 10 - 30 - 36 = -56
      mut as int64: v_unconstricted = v + delta_cog + delta_soc

      #L Aplicacao da constricao de Clerc:
      #L v_new = (chi_factor * v_unconstricted) /i 1000 = (729 * -56) /i 1000 = -40824 /i 1000 = -40
      mut as int64: num_v = chi_factor * v_unconstricted
      mut as int64: v_new = num_v /i 1000

      #L Atualizacao da posicao: x_new = x + v_new = 20 - 40 = -20
      mut as int64: x_new = x + v_new

      println("1. Velocidade nao-restringida: " + v_unconstricted)
      println("2. Fator de constricao chi (x1000): " + chi_factor)
      println("3. Velocidade amortecida pela constricao: " + v_new)
      println("4. Nova posicao da particula: " + x_new)

      route {
            v_unconstricted == -56 and v_new == -40 and x_new == -20 ==> {
                  println("5. Dinamica de enxame com constricao de Clerc validada.")
            }
            _ ==> {
                  println("Falha no PSO com constricao.")
            }
      }
      println("Teste concluido com sucesso.")
}
