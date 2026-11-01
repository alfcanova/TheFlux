#L ============================================================================
#L Algoritmo: Approximation Algorithm (Algoritmo de Aproximacao)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(V + E) tempo | Razao de Aproximacao <= 2
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasApproximationAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Approximation Algorithm (Vertex Cover)")
      println("==================================================")

      #L Grafo com 7 vertices e 8 arestas (Problema da Cobertura de Vertices)
      #L Arestas: (1,2), (1,3), (2,4), (3,4), (4,5), (5,6), (5,7), (6,7)
      mut as list of int64: edge_u = [1, 1, 2, 3, 4, 5, 5, 6]
      mut as list of int64: edge_v = [2, 3, 4, 4, 5, 6, 7, 7]
      mut as int64: num_edges = listLength(edge_u)
      mut as int64: num_vertices = 7

      println("1. Vertices: 1.." + num_vertices + " | Arestas: " + num_edges)

      #L Vetor booleano de vertices pertencentes a cobertura C (1-based: 1..7)
      mut as list of int64: in_cover = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: matching_edges = []
      mut as int64: ei = 1

      #L 2-Aproximacao via Emparelhamento Maximal:
      #L Enquanto houver aresta (u, v) nao coberta, adiciona AMBOS u e v a cobertura C
      infinite (ei <= num_edges) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]

            route {
                  in_cover[u] == 0 and in_cover[v] == 0 ==> {
                        #L Ambos os extremos entram na cobertura
                        in_cover[u] = 1
                        in_cover[v] = 1
                        matching_edges = listPushBack(matching_edges, ei)
                  }
                  _ ==> {
                  }
            }
            ei = ei + 1
      }

      #L Coleta vertices selecionados
      mut as list of int64: cover_set = []
      mut as int64: vi = 1
      infinite (vi <= num_vertices) {
            route {
                  in_cover[vi] == 1 ==> {
                        cover_set = listPushBack(cover_set, vi)
                  }
                  _ ==> {
                  }
            }
            vi = vi + 1
      }

      #L Verificacao de validade da cobertura (todas as arestas devem ter ao menos 1 extremo em C)
      mut as bool: all_covered = true
      mut as int64: check_e = 1
      infinite (check_e <= num_edges) {
            mut as int64: cu = edge_u[check_e]
            mut as int64: cv = edge_v[check_e]
            route {
                  in_cover[cu] == 0 and in_cover[cv] == 0 ==> {
                        all_covered = false
                  }
                  _ ==> {
                  }
            }
            check_e = check_e + 1
      }

      mut as int64: cover_size = listLength(cover_set)
      mut as int64: match_size = listLength(matching_edges)

      println("2. Arestas do emparelhamento maximal: " + matching_edges)
      println("3. Vertices na cobertura C (2-Aproximacao): " + cover_set)
      println("4. Tamanho da cobertura obtida: " + cover_size)
      println("5. Limite inferior otimo (|M| <= |OPT|): " + match_size)
      route {
            all_covered ==> {
                  println("6. Verificacao: Todas as arestas cobertas com sucesso (OK)")
            }
            _ ==> {
                  println("6. Falha na cobertura")
            }
      }
      println("Concluido com Sucesso")
}
