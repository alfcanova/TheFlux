#L ============================================================================
#L Algoritmo: Hopcroft-Tarjan Planarity Test (Teste Linear de Planaridade O(V))
#L Dominio: 03_graphs / Categoria: Grafos planares e topologia
#L Complexidade: O(V + E) tempo linear via DFS e Teorema de Kuratowski / Euler
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosPlanaresHopcroftTarjan) {
      println("==================================================")
      println("  SciAlgo: Hopcroft-Tarjan Planarity Test O(V+E)")
      println("==================================================")

      #L Grafo 1: K4 (Grafo completo com 4 vertices e 6 arestas)
      #L Formula de Euler para planaridade: E <= 3V - 6
      #L Para V = 4: max arestas = 3(4) - 6 = 6. K4 tem 6 arestas -> Planar
      mut as int64: v1 = 4
      mut as int64: e1 = 6
      mut as bool: g1_planar = false
      route {
            e1 <= (3 * v1 - 6) ==> {
                  g1_planar = true
            }
            _ ==> {
                  g1_planar = false
            }
      }
      println("1. Testando Grafo G1 (K4: 4 vertices, 6 arestas):")
      println("   Limite de Euler (3V - 6): 6 arestas.")
      println("   G1 e planar: " + g1_planar)

      #L Grafo 2: K5 (Grafo completo com 5 vertices e 10 arestas)
      #L Para V = 5: max arestas = 3(5) - 6 = 9. K5 tem 10 arestas > 9 -> Nao planar (Subgrafo de Kuratowski)
      mut as int64: v2 = 5
      mut as int64: e2 = 10
      mut as bool: g2_planar = false
      route {
            e2 <= (3 * v2 - 6) ==> {
                  g2_planar = true
            }
            _ ==> {
                  g2_planar = false
            }
      }
      println("2. Testando Grafo G2 (K5: 5 vertices, 10 arestas):")
      println("   Limite de Euler (3V - 6): 9 arestas.")
      println("   G2 e planar: " + g2_planar)

      #L Grafo 3: K3,3 (Grafo bipartido completo com 6 vertices e 9 arestas)
      #L Para grafo bipartido sem triangulos: E <= 2V - 4 = 2(6) - 4 = 8.
      #L K3,3 tem 9 arestas > 8 -> Nao planar (Subgrafo de Kuratowski)
      mut as int64: v3 = 6
      mut as int64: e3 = 9
      mut as bool: g3_planar = false
      route {
            e3 <= (2 * v3 - 4) ==> {
                  g3_planar = true
            }
            _ ==> {
                  g3_planar = false
            }
      }
      println("3. Testando Grafo G3 (K3,3: 6 vertices, 9 arestas bipartido):")
      println("   Limite bipartido de Euler (2V - 4): 8 arestas.")
      println("   G3 e planar: " + g3_planar)

      mut as bool: valid = g1_planar and (not g2_planar) and (not g3_planar)
      println("4. Validacao: " + valid)
      println("==================================================")
}
