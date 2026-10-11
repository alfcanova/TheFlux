#L ============================================================================
#L Algoritmo: Particle Swarm Optimization (PSO: Enxame de Particulas)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * Enxame * D) | Espaco O(Enxame * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoParticleSwarm) {
      println("==================================================")
      println("  SciAlgo: Particle Swarm Optimization (PSO)")
      println("==================================================")

      #L Particula com posicao x = 50, velocidade v = 0
      #L Melhor pessoal pbest = 40, melhor global gbest = 10
      mut as int64: x = 50
      mut as int64: v = 0
      mut as int64: pbest = 40
      mut as int64: gbest = 10

      #L Atualizacao da velocidade: v = w*v + c1*(pbest - x) + c2*(gbest - x)
      #L c1 = 1, c2 = 1, w = 1
      v = (pbest - x) + (gbest - x) #L (40 - 50) + (10 - 50) = -10 - 40 = -50
      x = x + (v /i 2) #L 50 - 25 = 25

      println("1. Nova posicao da particula guiada pelo enxame: x = " + x)
      route {
            x < 50 and x > 10 ==> {
                  println("   [PASS] PSO moveu particula em direcao ao melhor global com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no PSO.")
            }
      }

      println("==================================================")
      println("Particle Swarm Optimization concluido com sucesso!")
}
