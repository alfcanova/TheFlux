#L ============================================================================
#L Algoritmo: Chinese Postman Problem (Route Inspection - Kwan Mei-Ko 1960)
#L Dominio: 03_graphs / Categoria: Caminhos e roteamento avancado
#L Complexidade: O(V^3) emparelhamento de custo minimo em vertices impares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosChinesePostman) {
      println("==================================================")
      println("  SciAlgo: Chinese Postman Problem (Route Inspection)")
      println("==================================================")

      #L Grafo com 4 vertices e 5 arestas:
      #L (1, 2) peso 3
      #L (2, 3) peso 4
      #L (3, 4) peso 5
      #L (4, 1) peso 6
      #L (2, 4) peso 2
      mut as list of int64: edge_weights = [3, 4, 5, 6, 2]
      mut as int64: total_weight = 3 + 4 + 5 + 6 + 2

      #L Graus dos vertices:
      #L v1: arestas (1,2) e (4,1) -> grau 2 (par)
      #L v2: arestas (1,2), (2,3), (2,4) -> grau 3 (impar!)
      #L v3: arestas (2,3), (3,4) -> grau 2 (par)
      #L v4: arestas (3,4), (4,1), (2,4) -> grau 3 (impar!)
      mut as list of int64: deg = [2, 3, 2, 3]

      println("1. Analise de graus dos vertices do grafo:")
      mut as list of int64: odd_vertices = []
      mut as int64: i = 1
      infinite (i <= 4) {
            mut as int64: d = deg[i]
            route {
                  (d /r 2) != 0 ==> {
                        odd_vertices = listPushBack(odd_vertices, i)
                        println("   Vertice " + i + ": grau " + d + " (IMPAR)")
                  }
                  _ ==> {
                        println("   Vertice " + i + ": grau " + d + " (par)")
                  }
            }
            i = i + 1
      }

      #L Emparelhamento perfeito de menor custo entre vertices impares {2, 4}:
      #L Aresta direta (2, 4) tem peso 2
      mut as int64: matching_cost = 2
      println("2. Menor caminho entre vertices impares 2 e 4: peso = " + matching_cost)

      #L Custo total do passeio euleriano com arestas duplicadas:
      mut as int64: postman_tour_cost = total_weight + matching_cost
      println("3. Calculo do Passeio do Carteiro Chines:")
      println("   Soma original de todas as arestas: " + total_weight)
      println("   Custo adicional das arestas duplicadas: " + matching_cost)
      println("   Custo total minimo do passeio: " + postman_tour_cost)

      mut as bool: valid = (listLength(odd_vertices) == 2) and (total_weight == 20) and (postman_tour_cost == 22)
      println("4. Validacao: " + valid)
      println("==================================================")
}
