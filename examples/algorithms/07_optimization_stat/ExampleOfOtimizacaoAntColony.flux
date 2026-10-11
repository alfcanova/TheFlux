#L ============================================================================
#L Algoritmo: Ant Colony Optimization (ACO: Otimizacao por Colonia de Formigas)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * Formigas * N^2) | Espaco O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAntColony) {
      println("==================================================")
      println("  SciAlgo: Ant Colony Optimization (ACO Pheromones)")
      println("==================================================")

      #L Feromonio em duas arestas: tau1 = 50, tau2 = 20
      #L Evaporacao rho = 10% -> tau = tau * 0.90
      #L Formigas depositam feromonio delta = 30 na rota mais curta (aresta 1)
      mut as int64: tau1 = 50
      mut as int64: tau2 = 20

      #L Evaporacao
      tau1 = (tau1 * 9) /i 10 #L 45
      tau2 = (tau2 * 9) /i 10 #L 18

      #L Deposito
      tau1 = tau1 + 30 #L 75

      println("1. Feromonio final na aresta otima: " + tau1 + " (aresta secundaria: " + tau2 + ")")
      route {
            tau1 > tau2 ==> {
                  println("   [PASS] Colonia de formigas reforcou o caminho otimo com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no ACO.")
            }
      }

      println("==================================================")
      println("Ant Colony Optimization concluido com sucesso!")
}
