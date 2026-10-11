#L ============================================================================
#L Algoritmo: Push-Relabel com Heuristica de Gap (Cherkassky & Goldberg 1997)
#L Dominio: 03_graphs / Categoria: Redes de fluxo e cortes
#L Complexidade: O(V^2 * sqrt(E)) fluxo maximo ultra-rapido com poda de gaps
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoPushRelabelGapHeuristic) {
      println("==================================================")
      println("  SciAlgo: Push-Relabel Gap Heuristic (1997)")
      println("==================================================")

      #L Rede com N = 5 vertices (sink = vertice 1 na altura 0)
      mut as int64: n = 5

      #L Alturas correntes dos vertices 1..5:
      #L h(1) = 0 (sink)
      #L h(2) = 1
      #L h(3) = 3 (gap na altura 2!)
      #L h(4) = 4
      #L h(5) = 5 (source na altura N)
      mut as list of int64: h = [0, 1, 3, 4, 5]

      println("1. Alturas dos vertices antes da deteccao de gap:")
      mut as int64: i = 1
      infinite (i <= n) {
            println("   Vertice " + i + ": altura h = " + h[i])
            i = i + 1
      }

      #L Contagem de vertices por altura [0..4]:
      #L h = 0: 1 vertice
      #L h = 1: 1 vertice
      #L h = 2: 0 vertices -> GAP DETECTADO!
      #L h = 3: 1 vertice
      #L h = 4: 1 vertice
      mut as list of int64: count_h = [1, 1, 0, 1, 1]
      mut as int64: gap_level = 2

      println("2. Analise de contagem de alturas:")
      println("   Altura " + gap_level + " tem contagem 0 -> GAP IDENTIFICADO!")

      #L Aplicacao da Heuristica de Gap:
      #L Todo vertice com h > gap_level e h < N e desconectado do sink;
      #L sua altura e imediatamente elevada para N (5).
      println("3. Aplicando Heuristica de Gap (elevando nos para N = " + n + "):")
      mut as int64: updated_nodes = 0
      i = 1
      infinite (i <= n) {
            route {
                  h[i] > gap_level and h[i] < n ==> {
                        println("   Elevando vertice " + i + " de altura " + h[i] + " para " + n)
                        h[i] = n
                        updated_nodes = updated_nodes + 1
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("4. Alturas apos a heuristica de gap: " + h)

      mut as bool: valid = (h[3] == 5) and (h[4] == 5) and (h[2] == 1) and (updated_nodes == 2)
      println("5. Validacao: " + valid)
      println("==================================================")
}
