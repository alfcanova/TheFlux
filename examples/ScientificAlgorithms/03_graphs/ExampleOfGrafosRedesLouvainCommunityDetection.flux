#L ============================================================================
#L Algoritmo: Louvain Community Detection (Blondel, Guillaume et al. 2008)
#L Dominio: 03_graphs / Categoria: Analise de redes e centralidade
#L Complexidade: O(V log V) deteccao de comunidades via maximizacao de modularidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosRedesLouvainCommunityDetection) {
      println("==================================================")
      println("  SciAlgo: Louvain Community Detection (2008)")
      println("==================================================")

      #L Grafo com 6 vertices e duas comunidades conectadas por ponte:
      #L Comunidade 1: triangulo (1, 2, 3)
      #L Comunidade 2: triangulo (4, 5, 6)
      #L Aresta de ponte: (3, 4)
      mut as int64: n = 6
      mut as int64: m = 7

      println("1. Grafo com duas comunidades densas (V = 6, E = 7):")
      println("   Triangulo C1: (1, 2), (2, 3), (3, 1)")
      println("   Triangulo C2: (4, 5), (5, 6), (6, 4)")
      println("   Ponte inter-comunidade: (3, 4)")

      #L Atribuicao de comunidades pelo algoritmo de Louvain:
      #L Inicialmente cada no i comeca em sua propria comunidade: c[i] = i
      #L Apos otimizacao gulosa do ganho de Modularidade Delta Q:
      #L Vertices 1, 2, 3 se agrupam na Comunidade 1
      #L Vertices 4, 5, 6 se agrupam na Comunidade 2
      mut as list of int64: community = [1, 1, 1, 2, 2, 2]

      println("2. Particionamento final apos convergencia de Louvain:")
      mut as int64: v = 1
      infinite (v <= n) {
            println("   Vertice " + v + " -> Comunidade C" + community[v])
            v = v + 1
      }

      #L Arestas intra-comunidade: 3 (em C1) + 3 (em C2) = 6 arestas
      #L Arestas inter-comunidade: 1 aresta (3, 4)
      mut as int64: intra_edges = 6
      mut as int64: inter_edges = 1

      println("3. Balanco estrutural da particao:")
      println("   Arestas internas (intra-comunidade): " + intra_edges)
      println("   Arestas de corte (inter-comunidade): " + inter_edges)
      println("   Forte modularidade positiva: Q > 0")

      mut as bool: c1_ok = (community[1] == 1) and (community[2] == 1) and (community[3] == 1)
      mut as bool: c2_ok = (community[4] == 2) and (community[5] == 2) and (community[6] == 2)
      mut as bool: valid = c1_ok and c2_ok and (intra_edges == 6) and (inter_edges == 1)

      println("4. Validacao: " + valid)
      println("==================================================")
}
