#L ============================================================================
#L Algoritmo: Vertex Cover Approximation (2-Aproximacao via Maximal Matching)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(V + E) tempo | Fator de Aproximacao: <= 2 * OPT
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeVertexCoverApproximation) {
      println("==================================================")
      println("  SciAlgo: Vertex Cover 2-Aproximacao")
      println("==================================================")

      #L Grafo com V = 6 vertices e E = 7 arestas:
      #L Arestas: (1-2), (2-3), (3-4), (4-5), (5-6), (6-1), (2-5)
      mut as int64: num_vertices = 6
      mut as list of int64: edge_u = [1, 2, 3, 4, 5, 6, 2]
      mut as list of int64: edge_v = [2, 3, 4, 5, 6, 1, 5]
      mut as int64: num_edges = listLength(edge_u)

      println("1. Grafo com 6 vertices e 7 arestas inicializado.")

      #L Algoritmo de 2-Aproximacao (Gavril-Yannakakis):
      #L Encontra um emparelhamento maximal de arestas independentes.
      #L Para cada aresta (u, v) no emparelhamento, inclui AMBOS u e v na cobertura.
      mut as list of bool: in_cover = [false, false, false, false, false, false]
      mut as list of int64: matching_u = []
      mut as list of int64: matching_v = []

      mut as int64: ei = 1
      infinite (ei <= num_edges) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]

            #L Se nem u nem v estao na cobertura, a aresta (u, v) e independente
            mut as bool: u_covered = in_cover[u]
            mut as bool: v_covered = in_cover[v]

            route {
                  (not u_covered) and (not v_covered) ==> {
                        #L Adiciona ambos ao Vertex Cover
                        in_cover[u] = true
                        in_cover[v] = true
                        matching_u = listPushBack(matching_u, u)
                        matching_v = listPushBack(matching_v, v)
                  }
            }
            ei = ei + 1
      }

      println("2. Emparelhamento maximal selecionado: " + listLength(matching_u) + " arestas:")
      mut as int64: mi = 1
      infinite (mi <= listLength(matching_u)) {
            println("   Aresta (" + matching_u[mi] + " - " + matching_v[mi] + ")")
            mi = mi + 1
      }

      #L Coleta vertices na cobertura C
      mut as list of int64: cover = []
      mut as int64: vi = 1
      infinite (vi <= num_vertices) {
            route {
                  in_cover[vi] ==> {
                        cover = listPushBack(cover, vi)
                  }
            }
            vi = vi + 1
      }

      println("3. Cobertura de vertices C calculada: " + cover)
      mut as int64: cover_size = listLength(cover)
      println("   Tamanho da cobertura aproximada: |C| = " + cover_size)

      #L 4. Verificacao de validade da cobertura (todas as 7 arestas cobertas)
      mut as bool: all_edges_covered = true
      ei = 1
      infinite (ei <= num_edges) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            mut as bool: ok = in_cover[u] or in_cover[v]
            route {
                  not ok ==> { all_edges_covered = false }
            }
            ei = ei + 1
      }

      println("4. Todas as arestas cobertas com sucesso: " + all_edges_covered)

      #L 5. Prova do Fator de 2-Aproximacao:
      #L O tamanho do emparelhamento maximal e |M|. Qualquer cobertura valida
      #L precisa de pelo menos 1 vertice de cada aresta disjunta de M, logo |OPT| >= |M|.
      #L Como pegamos ambos os vertices de cada aresta em M, temos |C| = 2 * |M| <= 2 * |OPT|.
      mut as int64: m_size = listLength(matching_u)
      mut as bool: approx_guarantee = (cover_size == (2 * m_size))
      println("5. Garantia teorica |C| = 2 * |M| <= 2 * OPT comprovada: " + approx_guarantee)

      mut as bool: final_ok = all_edges_covered and approx_guarantee
      println("6. Verificacao geral do Algoritmo de Aproximacao: " + final_ok)
      println("Concluido com Sucesso")
}
