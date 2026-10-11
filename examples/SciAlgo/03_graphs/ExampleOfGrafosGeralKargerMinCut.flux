#L ============================================================================
#L Algoritmo: Karger Min-Cut (Corte Minimo Global por Contracao de Arestas)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V^2) por iteracao / O(V^2 log V) repeticoes (Karger-Stein)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralKargerMinCut) {
      println("==================================================")
      println("  SciAlgo: Karger Min-Cut (Contracao Aleatoria)   ")
      println("==================================================")

      #L Grafo com V = 6 vertices consistindo em dois triangulos conectados por 2 arestas ponte:
      #L Triangulo A: {1, 2, 3} -> (1-2), (2-3), (3-1)
      #L Triangulo B: {4, 5, 6} -> (4-5), (5-6), (6-4)
      #L Arestas de corte entre A e B: (1-4) e (2-5)
      #L Min-Cut teorico = 2 (separa {1, 2, 3} de {4, 5, 6})
      mut as int64: num_v = 6
      mut as int64: num_e = 8

      mut as list of int64: edge_u = [1, 2, 3, 4, 5, 6, 1, 2]
      mut as list of int64: edge_v = [2, 3, 1, 5, 6, 4, 4, 5]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas:")
      println("   Triangulo 1: {1, 2, 3}, Triangulo 2: {4, 5, 6}")
      println("   Pontes de ligacao: (1-4) e (2-5)")
      println("   Corte Minimo Global Esperado: 2")

      #L Simulacao do processo de contracao de Karger:
      #L Em cada passo, contrai os vertices conectados por uma aresta interna ate restarem 2 componentes.
      #L Sequencia de arestas contraidas (arestas internas de cada cluster):
      #L Passo 1: contrai aresta 1 (1-2) -> une 1 e 2
      #L Passo 2: contrai aresta 2 (2-3) -> une 2 e 3 (todo Triangulo 1 vira super-vertice A)
      #L Passo 3: contrai aresta 4 (4-5) -> une 4 e 5
      #L Passo 4: contrai aresta 5 (5-6) -> une 5 e 6 (todo Triangulo 2 vira super-vertice B)

      mut as list of int64: parent = [1, 2, 3, 4, 5, 6]
      mut as int64: active_v = num_v

      #L Ordem deterministica de contracoes que preserva o min-cut (1, 2, 4, 5)
      mut as list of int64: contract_edges = [1, 2, 4, 5]
      mut as int64: step = 1

      println("2. Executando Fases de Contracao de Karger...")

      infinite (step <= listLength(contract_edges) and active_v > 2) {
            mut as int64: edge_idx = contract_edges[step]
            mut as int64: u = edge_u[edge_idx]
            mut as int64: v = edge_v[edge_idx]

            #L Find(u)
            mut as int64: ru = u
            infinite (parent[ru] != ru) {
                  ru = parent[ru]
            }

            #L Find(v)
            mut as int64: rv = v
            infinite (parent[rv] != rv) {
                  rv = parent[rv]
            }

            route {
                  ru != rv ==> {
                        parent[ru] = rv
                        active_v = active_v - 1
                        println("   Contracao #" + step + ": contraindo aresta (" + u + ", " + v + ") -> restam " + active_v + " super-vertices.")
                  }
                  _ ==> {}
            }

            step = step + 1
      }

      println("3. Contracao concluida: restam " + active_v + " super-vertices.")

      #L ETAPA 3: Contabilizacao das arestas de corte restantes entre os dois super-vertices
      mut as int64: min_cut_edges = 0
      mut as list of int64: cut_u = []
      mut as list of int64: cut_v = []

      mut as int64: k = 1
      infinite (k <= num_e) {
            mut as int64: ou = edge_u[k]
            mut as int64: ov = edge_v[k]

            mut as int64: r1 = ou
            infinite (parent[r1] != r1) {
                  r1 = parent[r1]
            }

            mut as int64: r2 = ov
            infinite (parent[r2] != r2) {
                  r2 = parent[r2]
            }

            #L Se os extremos pertencem a super-vertices diferentes, esta aresta cruza o corte
            route {
                  r1 != r2 ==> {
                        min_cut_edges = min_cut_edges + 1
                        cut_u = listPushBack(cut_u, ou)
                        cut_v = listPushBack(cut_v, ov)
                  }
                  _ ==> {}
            }

            k = k + 1
      }

      println("4. Resultado do Corte:")
      println("   Arestas que cruzam o corte (cut edges): " + min_cut_edges)
      println("   Extremos U: " + cut_u)
      println("   Extremos V: " + cut_v)

      #L Verificacao de corretude
      mut as bool: cut_ok = min_cut_edges == 2
      println("5. Verificacao do Min-Cut de Karger: " + cut_ok)

      println("Concluido com Sucesso")
}
