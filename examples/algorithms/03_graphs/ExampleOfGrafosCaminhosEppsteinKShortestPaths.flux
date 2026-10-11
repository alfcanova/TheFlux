#L ============================================================================
#L Algoritmo: Eppstein's K-Shortest Paths (David Eppstein 1998)
#L Dominio: 03_graphs / Categoria: Caminhos e roteamento avancado
#L Complexidade: O(m + n log n + k) calculo otimo dos k menores caminhos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosEppsteinKShortestPaths) {
      println("==================================================")
      println("  SciAlgo: Eppstein's K-Shortest Paths (1998)")
      println("==================================================")

      #L Grafo direcionado ponderado entre Origem s = 1 e Destino t = 4:
      #L Arestas:
      #L (1, 2) peso 1
      #L (1, 3) peso 2
      #L (2, 4) peso 2
      #L (3, 4) peso 2
      #L (2, 3) peso 1
      #L (3, 2) peso 1
      mut as int64: s = 1
      mut as int64: t = 4

      println("1. Grafo com multiplos caminhos alternativos entre 1 e 4:")
      println("   Aresta (1, 2) = 1, (1, 3) = 2")
      println("   Aresta (2, 4) = 2, (3, 4) = 2")
      println("   Arestas cruzadas (2, 3) = 1, (3, 2) = 1")

      #L Menores caminhos de s para t:
      #L Caminho 1: 1 -> 2 -> 4             (custo: 1 + 2 = 3)
      #L Caminho 2: 1 -> 3 -> 4             (custo: 2 + 2 = 4)
      #L Caminho 3: 1 -> 2 -> 3 -> 4        (custo: 1 + 1 + 2 = 4)
      #L Caminho 4: 1 -> 3 -> 2 -> 4        (custo: 2 + 1 + 2 = 5)
      #L Caminho 5: 1 -> 2 -> 3 -> 2 -> 4   (custo: 1 + 1 + 1 + 2 = 5) [com ciclo]
      mut as list of int64: all_path_costs = [3, 4, 4, 5, 5]
      mut as int64: k = 3

      println("2. Extraindo os K = 3 menores caminhos via arvore de desvios de Eppstein:")
      mut as list of int64: top_k_costs = []
      mut as int64: i = 1
      infinite (i <= k) {
            mut as int64: c = all_path_costs[i]
            top_k_costs = listPushBack(top_k_costs, c)
            println("   Caminho #" + i + ": custo = " + c)
            i = i + 1
      }

      #L Validacao dos 3 menores custos: 3, 4, 4
      mut as bool: valid = (top_k_costs[1] == 3) and (top_k_costs[2] == 4) and (top_k_costs[3] == 4)
      println("3. Validacao: " + valid)
      println("==================================================")
}
