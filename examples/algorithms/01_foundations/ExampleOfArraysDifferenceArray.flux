#L ============================================================================
#L Algoritmo: Difference Array (Array de Diferencas 1D e 2D)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(1) atualizacao em intervalo | O(N) reconstrucao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysDifferenceArray) {
      println("==================================================")
      println("  SciAlgo: Difference Array (1D e 2D)")
      println("==================================================")

      #L --- PARTE 1: Array de Diferenca 1D ---
      #L Array base de zeros com tamanho N = 8
      mut as int64: n1 = 8
      mut as list of int64: diff1d = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] #L tamanho N+2

      #L Aplicando atualizacoes O(1) em intervalos:
      #L U1: Somar 10 no intervalo [2..5]
      diff1d[2] = diff1d[2] + 10
      diff1d[6] = diff1d[6] - 10

      #L U2: Somar 5 no intervalo [4..7]
      diff1d[4] = diff1d[4] + 5
      diff1d[8] = diff1d[8] - 5

      #L U3: Somar 20 no intervalo [1..3]
      diff1d[1] = diff1d[1] + 20
      diff1d[4] = diff1d[4] - 20

      println("1. Array de diferencas apos 3 atualizacoes em O(1): " + diff1d)

      #L Reconstrucao por soma de prefixo em O(N)
      mut as list of int64: reconstructed1d = []
      mut as int64: run_sum = 0
      mut as int64: i = 1
      infinite (i <= n1) {
            run_sum = run_sum + diff1d[i]
            reconstructed1d = listPushBack(reconstructed1d, run_sum)
            i = i + 1
      }
      println("2. Array 1D reconstruido: " + reconstructed1d)
      #L Esperado:
      #L idx 1: 20
      #L idx 2: 20 + 10 = 30
      #L idx 3: 20 + 10 = 30
      #L idx 4: 10 + 5 = 15
      #L idx 5: 10 + 5 = 15
      #L idx 6: 5
      #L idx 7: 5
      #L idx 8: 0

      #L --- PARTE 2: Matriz de Diferencas 2D ---
      #L Grid 3x3 inicializado com zeros. Dimensao de diferenca 5x5
      mut as list of int64: diff2d = []
      mut as int64: z = 1
      infinite (z <= 25) {
            diff2d = listPushBack(diff2d, 0)
            z = z + 1
      }

      #L Atualizacao 2D: Somar 7 no retangulo (1,1) ate (2,2)
      #L diff[r1][c1] += v, diff[r1][c2+1] -= v, diff[r2+1][c1] -= v, diff[r2+1][c2+1] += v
      diff2d[1 * 5 + 1] = diff2d[1 * 5 + 1] + 7
      diff2d[1 * 5 + 3] = diff2d[1 * 5 + 3] - 7
      diff2d[3 * 5 + 1] = diff2d[3 * 5 + 1] - 7
      diff2d[3 * 5 + 3] = diff2d[3 * 5 + 3] + 7

      #L Atualizacao 2D: Somar 3 no retangulo (2,2) ate (3,3)
      diff2d[2 * 5 + 2] = diff2d[2 * 5 + 2] + 3
      diff2d[2 * 5 + 4] = diff2d[2 * 5 + 4] - 3
      diff2d[4 * 5 + 2] = diff2d[4 * 5 + 2] - 3
      diff2d[4 * 5 + 4] = diff2d[4 * 5 + 4] + 3

      #L Reconstrucao da matriz 3x3
      mut as list of int64: mat_res = []
      mut as int64: r = 1
      infinite (r <= 3) {
            mut as int64: c = 1
            infinite (c <= 3) {
                  #L Soma bidimensional de prefixos sobre diff2d
                  mut as int64: cur_cell = 0
                  mut as int64: pr = 1
                  infinite (pr <= r) {
                        mut as int64: pc = 1
                        infinite (pc <= c) {
                              cur_cell = cur_cell + diff2d[pr * 5 + pc]
                              pc = pc + 1
                        }
                        pr = pr + 1
                  }
                  mat_res = listPushBack(mat_res, cur_cell)
                  c = c + 1
            }
            r = r + 1
      }
      println("3. Matriz 2D reconstruida apos atualizacoes em subgrades:")
      println("   Linha 1: [" + mat_res[1] + ", " + mat_res[2] + ", " + mat_res[3] + "] (esperado: [7, 7, 0])")
      println("   Linha 2: [" + mat_res[4] + ", " + mat_res[5] + ", " + mat_res[6] + "] (esperado: [7, 10, 3])")
      println("   Linha 3: [" + mat_res[7] + ", " + mat_res[8] + ", " + mat_res[9] + "] (esperado: [0, 3, 3])")
}
