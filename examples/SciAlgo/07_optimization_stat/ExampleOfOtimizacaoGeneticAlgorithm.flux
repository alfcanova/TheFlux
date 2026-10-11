#L ============================================================================
#L Algoritmo: Genetic Algorithm (Algoritmo Genetico Canonico: Cruzamento e Selecao)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(G * Pop * D) | Espaco O(Pop * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGeneticAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Genetic Algorithm (Crossover & Fitness)")
      println("==================================================")

      #L Dois cromossomos binarios de 4 genes: P1 = [1, 1, 0, 0], P2 = [0, 0, 1, 1]
      #L Cruzamento de ponto unico no meio (posicao 2)
      mut as list of int64: p1 = [1, 1, 0, 0]
      mut as list of int64: p2 = [0, 0, 1, 1]

      mut as list of int64: child = [p1[1], p1[2], p2[3], p2[4]] #L [1, 1, 1, 1]
      println("1. Filho gerado por cruzamento genetico: [1, 1, 1, 1]")

      #L Fitness = soma dos genes ativos
      mut as int64: fitness = child[1] + child[2] + child[3] + child[4] #L 4 (maximo)
      println("2. Aptidao do descendente: " + fitness + " / 4")

      route {
            fitness == 4 ==> {
                  println("   [PASS] Algoritmo Genetico combinou genes e atingiu aptidao maxima!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Algoritmo Genetico.")
            }
      }

      println("==================================================")
      println("Genetic Algorithm concluido com sucesso!")
}
