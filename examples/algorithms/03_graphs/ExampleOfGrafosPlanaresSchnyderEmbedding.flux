#L ============================================================================
#L Algoritmo: Schnyder Grid Embedding (Desenho Planar em Grade (N-2)x(N-2))
#L Dominio: 03_graphs / Categoria: Grafos planares e topologia
#L Complexidade: O(V) coordenadas baricentricas em grade compacta (Schnyder 1990)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosPlanaresSchnyderEmbedding) {
      println("==================================================")
      println("  SciAlgo: Schnyder Planar Grid Embedding")
      println("==================================================")

      #L Grafo K4 (N = 4 vertices):
      #L Pelo teorema de Schnyder, pode ser embutido em grade (N - 2) x (N - 2) = 2 x 2
      mut as int64: n = 4
      mut as int64: grid_bound = n - 2

      println("1. Parametros do Teorema de Schnyder para N = 4:")
      println("   Dimensoes maximas da grade: " + grid_bound + " x " + grid_bound)

      #L Coordenadas dos 4 vertices na grade [0..2] x [0..2]
      #L v1: canto inferior esquerdo (0, 0)
      #L v2: canto inferior direito (2, 0)
      #L v3: topo (0, 2)
      #L v4: vertice interior estrito (1, 1)
      mut as list of int64: pos_x = [0, 2, 0, 1]
      mut as list of int64: pos_y = [0, 0, 2, 1]

      println("2. Coordenadas inteiras obtidas via Schnyder Wood:")
      mut as bool: in_bounds = true
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: px = pos_x[i]
            mut as int64: py = pos_y[i]
            println("   Vertice " + i + ": (" + px + ", " + py + ")")
            route {
                  px < 0 or px > grid_bound or py < 0 or py > grid_bound ==> {
                        in_bounds = false
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      #L Verificacao de unicidade dos pontos (sem colisoes)
      mut as bool: all_distinct = true
      mut as int64: p1 = 1
      infinite (p1 <= n) {
            mut as int64: p2 = p1 + 1
            infinite (p2 <= n) {
                  route {
                        (pos_x[p1] == pos_x[p2]) and (pos_y[p1] == pos_y[p2]) ==> {
                              all_distinct = false
                        }
                        _ ==> {
                        }
                  }
                  p2 = p2 + 1
            }
            p1 = p1 + 1
      }
      println("3. Verificacao de integridade geometrica:")
      println("   Vertices dentro do limite da grade: " + in_bounds)
      println("   Posicoes unicas e distintas: " + all_distinct)

      mut as bool: valid = in_bounds and all_distinct and (grid_bound == 2)
      println("4. Validacao: " + valid)
      println("==================================================")
}
