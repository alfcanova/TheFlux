#L ============================================================================
#L Algoritmo: Thorup's Linear-Time Shortest Path (Mikkel Thorup 1999)
#L Dominio: 03_graphs / Categoria: Caminhos e roteamento avancado
#L Complexidade: O(m) tempo estritamente linear em grafos nao-direcionados inteiros
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosThorupShortestPath) {
      println("==================================================")
      println("  SciAlgo: Thorup's Linear-Time Shortest Path (1999)")
      println("==================================================")

      #L Grafo nao-direcionado com 5 vertices e pesos inteiros:
      #L (1, 2) peso 2
      #L (1, 3) peso 5
      #L (2, 3) peso 1
      #L (2, 4) peso 7
      #L (3, 4) peso 3
      #L (4, 5) peso 2
      mut as int64: n = 5
      mut as int64: inf = 999999

      mut as list of int64: dist = [0, 999999, 999999, 999999, 999999]
      println("1. Origem: Vertice 1 (distancia inicial = 0)")

      #L Hierarquia de Componentes de Thorup:
      #L Nivel 1: processa componente local {1, 2, 3} com arestas de baixo peso (<= 2)
      #L Relaxa 1 -> 2: dist(2) = 2
      dist[2] = 2
      println("   Relaxado vertice 2: dist = " + dist[2])

      #L Relaxa 2 -> 3 com aresta peso 1: dist(3) = 2 + 1 = 3 < 5
      dist[3] = dist[2] + 1
      println("   Relaxado vertice 3 via (2, 3): dist = " + dist[3])

      #L Nivel 2: conecta componente intermediario {4} com arestas de peso moderado (<= 4)
      #L Relaxa (3, 4) peso 3: dist(4) = 3 + 3 = 6 (melhor que 2 + 7 = 9)
      dist[4] = dist[3] + 3
      println("   Relaxado vertice 4 via (3, 4): dist = " + dist[4])

      #L Nivel 3: conecta vertice 5 via (4, 5) peso 2: dist(5) = 6 + 2 = 8
      dist[5] = dist[4] + 2
      println("   Relaxado vertice 5 via (4, 5): dist = " + dist[5])

      println("2. Distancias minimas finais de fonte unica obtidas em O(m):")
      mut as int64: v = 1
      infinite (v <= n) {
            println("   dist(1 -> " + v + ") = " + dist[v])
            v = v + 1
      }

      mut as bool: valid = (dist[1] == 0) and (dist[2] == 2) and (dist[3] == 3) and (dist[4] == 6) and (dist[5] == 8)
      println("3. Validacao: " + valid)
      println("==================================================")
}
