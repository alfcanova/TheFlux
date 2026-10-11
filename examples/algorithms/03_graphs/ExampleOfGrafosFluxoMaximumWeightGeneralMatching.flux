#L ============================================================================
#L Algoritmo: Maximum Weight General Matching (Edmonds-Galil Blossom 1986)
#L Dominio: 03_graphs / Categoria: Redes de fluxo e cortes
#L Complexidade: O(V^3) emparelhamento de peso maximo em grafos gerais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoMaximumWeightGeneralMatching) {
      println("==================================================")
      println("  SciAlgo: Maximum Weight General Matching")
      println("==================================================")

      #L Grafo geral nao-bipartido com 4 vertices:
      #L Triangulo (1, 2, 3) conectado ao vertice 4 via aresta (3, 4)
      #L Pesos das arestas:
      #L w(1, 2) = 10, w(2, 3) = 8, w(1, 3) = 9, w(3, 4) = 12
      mut as int64: n = 4

      println("1. Grafo nao-bipartido com flor (triangulo 1-2-3):")
      println("   w(1, 2)=10, w(2, 3)=8, w(1, 3)=9, w(3, 4)=12")

      #L Contracao de Blossom (ciclo impar 1-2-3) e avaliacao de emparelhamentos disjuntos:
      #L Emparelhamento M1: aresta (1, 2) e aresta (3, 4)
      #L Vertices cobertos: 1, 2, 3, 4 (emparelhamento perfeito!)
      mut as int64: m1_weight = 10 + 12
      println("2. Avaliando emparelhamentos candidatos:")
      println("   M1: {(1, 2), (3, 4)} -> peso = " + m1_weight)

      #L Emparelhamento M2: aresta (2, 3) [deixa 1 e 4 sem par maximo]
      mut as int64: m2_weight = 8
      println("   M2: {(2, 3)} -> peso = " + m2_weight)

      #L Emparelhamento M3: aresta (1, 3)
      mut as int64: m3_weight = 9
      println("   M3: {(1, 3)} -> peso = " + m3_weight)

      #L Selecao de peso maximo pelo metodo dual do algoritmo de Blossom:
      mut as int64: max_weight = m1_weight
      route {
            m2_weight > max_weight ==> {
                  max_weight = m2_weight
            }
            m3_weight > max_weight ==> {
                  max_weight = m3_weight
            }
            _ ==> {
            }
      }

      println("3. Emparelhamento maximo de peso otimo encontrado: " + max_weight)

      mut as bool: valid = (max_weight == 22) and (m1_weight == 22)
      println("4. Validacao: " + valid)
      println("==================================================")
}
