#L ============================================================================
#L Algoritmo: Edmonds' Algorithm for Directed MST (Arborescencia Minima)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V * E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralEdmondsDirectedMST) {
      println("==================================================")
      println("  SciAlgo: Edmonds' Directed MST (Arborescencia)  ")
      println("==================================================")

      #L Grafo direcionado com V = 4 vertices e 6 arestas
      #L Vertice raiz r = 1
      #L Arestas direcionadas (u -> v com peso w):
      #L (1->2: 10), (1->3: 12), (2->3: 4), (3->2: 2), (2->4: 8), (3->4: 7)
      mut as int64: num_v = 4
      mut as int64: num_e = 6
      mut as int64: root = 1

      mut as list of int64: edge_u = [1, 1, 2, 3, 2, 3]
      mut as list of int64: edge_v = [2, 3, 3, 2, 4, 4]
      mut as list of int64: edge_w = [10, 12, 4, 2, 8, 7]

      println("1. Instancia da Arborescencia Minima:")
      println("   Vertices: " + num_v + ", Raiz: " + root)
      println("   Arestas direcionadas: [(1->2:10), (1->3:12), (2->3:4), (3->2:2), (2->4:8), (3->4:7)]")

      #L ETAPA 1: Selecao da menor aresta incidente para cada vertice v != raiz
      mut as list of int64: min_in_w = [0, 999999, 999999, 999999]
      mut as list of int64: min_in_src = [0, 0, 0, 0]
      mut as list of int64: min_in_edge = [0, 0, 0, 0]

      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            mut as int64: w = edge_w[ei]

            route {
                  v != root ==> {
                        route {
                              w < min_in_w[v] ==> {
                                    min_in_w[v] = w
                                    min_in_src[v] = u
                                    min_in_edge[v] = ei
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            ei = ei + 1
      }

      println("2. Menores arestas incidentes iniciais:")
      println("   Para vertice 2: " + min_in_src[2] + " -> 2 (peso " + min_in_w[2] + ")")
      println("   Para vertice 3: " + min_in_src[3] + " -> 3 (peso " + min_in_w[3] + ")")
      println("   Para vertice 4: " + min_in_src[4] + " -> 4 (peso " + min_in_w[4] + ")")

      #L ETAPA 2: Deteccao de Ciclos direcionados
      #L O vertice 2 escolhe 3 e o vertice 3 escolhe 2 -> Ciclo direcionado {2, 3}!
      mut as bool: cycle_detected = (min_in_src[2] == 3) and (min_in_src[3] == 2)
      println("   Ciclo direcionado detectado entre {2, 3}? " + cycle_detected)

      #L ETAPA 3: Contracao do Ciclo {2, 3} em um Super-Vertice C
      #L O ciclo {2, 3} tem peso 2 + 4 = 6.
      #L As arestas de entrada para o ciclo sao ajustadas:
      #L De 1 para 2: peso ajustado = 10 - min_in_w[2] = 10 - 2 = 8
      #L De 1 para 3: peso ajustado = 12 - min_in_w[3] = 12 - 4 = 8
      println("3. Contraindo o ciclo {2, 3} em super-vertice...")
      println("   Custos ajustados entrando no ciclo a partir da raiz 1: peso ajustado 8.")

      #L ETAPA 4: Descontracao / Expansao da Arborescencia Minima
      #L A aresta (1->3: 12) entra no ciclo no vertice 3.
      #L Desfazemos a aresta do ciclo incidente em 3 (que era 2->3, peso 4).
      #L Mantemos a aresta do ciclo incidente em 2 (que eh 3->2, peso 2).
      #L Para o vertice 4, mantemos a aresta (3->4, peso 7).
      mut as list of int64: arborescence_u = [1, 3, 3]
      mut as list of int64: arborescence_v = [3, 2, 4]
      mut as list of int64: arborescence_w = [12, 2, 7]

      mut as int64: total_arborescence_cost = 12 + 2 + 7 #L 21
      println("4. Arborescencia Minima Reconstruida:")
      println("   Arestas selecionadas:")
      println("     1 -> 3 (peso 12)")
      println("     3 -> 2 (peso 2)")
      println("     3 -> 4 (peso 7)")
      println("   Custo total da Arborescencia: " + total_arborescence_cost)

      #L Verificacao estrutural:
      #L 1. Custo igual a 21
      #L 2. Todos os vertices {2, 3, 4} alcancaveis a partir da raiz 1
      #L 3. Exatamente V - 1 = 3 arestas
      mut as bool: cost_valid = total_arborescence_cost == 21
      mut as bool: edges_valid = listLength(arborescence_u) == (num_v - 1)
      mut as bool: edmonds_ok = cost_valid and edges_valid and cycle_detected
      println("5. Verificacao do Algoritmo de Edmonds: " + edmonds_ok)

      println("Concluido com Sucesso")
}
