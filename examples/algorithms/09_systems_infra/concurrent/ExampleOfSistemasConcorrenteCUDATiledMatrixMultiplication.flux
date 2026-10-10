#L ============================================================================
#L Algoritmo: CUDA Tiled Matrix Multiplication (Shared Memory Block Tiling)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N^3) trabalho | Reducao de O(TILE_SIZE) em acessos globais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteCUDATiledMatrixMultiplication) {
      println("==================================================")
      println("  SciAlgo: CUDA Tiled Matrix Multiplication (GPU) ")
      println("==================================================")

      #L Matrizes 4 x 4 (N = 4) com Tile Size = 2 x 2
      mut as int64: n = 4
      mut as int64: tile_size = 2

      #L Matriz A (4 x 4):
      #L [ 1, 2, 3, 4 ]
      #L [ 5, 6, 7, 8 ]
      #L [ 1, 0, 1, 0 ]
      #L [ 0, 1, 0, 1 ]
      mut as list of int64: a = [
            1, 2, 3, 4,
            5, 6, 7, 8,
            1, 0, 1, 0,
            0, 1, 0, 1
      ]

      #L Matriz B (4 x 4) Identidade escalada por 2:
      #L [ 2, 0, 0, 0 ]
      #L [ 0, 2, 0, 0 ]
      #L [ 0, 0, 2, 0 ]
      #L [ 0, 0, 0, 2 ]
      mut as list of int64: b = [
            2, 0, 0, 0,
            0, 2, 0, 0,
            0, 0, 2, 0,
            0, 0, 0, 2
      ]

      #L Matriz C de saida inicializada com zeros
      mut as list of int64: c = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]

      println("1. Dimensoes do Kernel CUDA:")
      println("   Matriz: 4 x 4 (16 elementos)")
      println("   Tile Size: 2 x 2 (4 threads por Thread Block)")
      println("   Total de Fases de Tiling: 2 (N / TILE_SIZE)")

      println("2. Executando Tiled Multiplication com Memoria Compartilhada:")

      #L Simula o bloco de threads cooperativo calculando cada elemento (r, col)
      mut as int64: r = 1
      infinite (r <= n) {
            mut as int64: col = 1
            infinite (col <= n) {
                  mut as int64: acc = 0

                  #L Itera sobre as fases de tiles (2 fases para cobrir k de 1 a 4)
                  mut as int64: tile_phase = 1
                  infinite (tile_phase <= 2) {
                        #L Coordenadas base do tile nesta fase
                        mut as int64: k_base = (tile_phase - 1) * tile_size

                        #L Carregamento cooperativo de A_tile e B_tile na Shared Memory
                        #L e multiplicacao parcial dentro do tile
                        mut as int64: k = 1
                        infinite (k <= tile_size) {
                              mut as int64: curr_k = k_base + k
                              mut as int64: val_a = a[(r - 1) * n + curr_k]
                              mut as int64: val_b = b[(curr_k - 1) * n + col]
                              acc = acc + val_a * val_b
                              k = k + 1
                        }

                        #L Barreira conceitual: __syncthreads()
                        tile_phase = tile_phase + 1
                  }

                  c[(r - 1) * n + col] = acc
                  col = col + 1
            }
            r = r + 1
      }

      println("3. Matriz Resultado C = A x B:")
      r = 1
      infinite (r <= n) {
            mut as string: row_str = ""
            mut as int64: cl = 1
            infinite (cl <= n) {
                  row_str = row_str + c[(r - 1) * n + cl] + " "
                  cl = cl + 1
            }
            println("   Linha " + r + ": [ " + row_str + "]")
            r = r + 1
      }

      #L Como B = 2 * I, C deve ser exatamente 2 * A:
      #L C[1,1] = 2, C[1,2] = 4, C[2,1] = 10, C[2,2] = 12
      mut as bool: correct = (c[1] == 2) and (c[2] == 4) and (c[5] == 10) and (c[6] == 12)
      println("4. Verificacao de Exatidao da Multiplicacao CUDA: " + correct)

      println("CUDA Tiled Matrix Multiplication concluido com sucesso.")
}
