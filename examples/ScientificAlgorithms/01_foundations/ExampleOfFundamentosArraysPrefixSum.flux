#L ============================================================================
#L Algoritmo: Prefix Sum (Soma de Prefixo 1D e 2D)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) pre-processamento | O(1) consulta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysPrefixSum) {
      println("==================================================")
      println("  SciAlgo: Prefix Sum (1D e 2D)")
      println("==================================================")

      #L --- PARTE 1: Soma de Prefixo 1D ---
      mut as list of int64: arr1d = [3, 2, 4, 5, 1, 1, 5, 3]
      mut as int64: n1 = listLength(arr1d)
      println("1. Array 1D (N = " + n1 + "): " + arr1d)

      #L Array de prefixo 1-based com tamanho N+1: pref1d[1] = 0
      mut as list of int64: pref1d = [0]
      mut as int64: i = 1
      infinite (i <= n1) {
            pref1d = listPushBack(pref1d, pref1d[i] + arr1d[i])
            i = i + 1
      }
      println("2. Tabela de prefixo 1D: " + pref1d)

      #L Consultas 1D em O(1): soma em [2..5] e [4..8]
      #L Intervalo [L, R] -> pref1d[R+1] - pref1d[L]
      mut as int64: sum_2_5 = pref1d[6] - pref1d[2]
      println("3. Soma [2..5]: " + sum_2_5 + " (esperado: 2+4+5+1 = 12)")
      mut as int64: sum_4_8 = pref1d[9] - pref1d[4]
      println("4. Soma [4..8]: " + sum_4_8 + " (esperado: 5+1+1+5+3 = 15)")

      #L --- PARTE 2: Soma de Prefixo 2D ---
      #L Matriz 3x3:
      #L [1, 2, 3]
      #L [4, 5, 6]
      #L [7, 8, 9]
      mut as list of int64: mat = [
            1, 2, 3,
            4, 5, 6,
            7, 8, 9
      ]
      mut as int64: rows = 3
      mut as int64: cols = 3
      println("5. Matriz 2D 3x3: [ [1,2,3], [4,5,6], [7,8,9] ]")

      #L Grid de prefixo 2D de dimensao 4x4 (indices de linha/coluna 0..3)
      #L Indice linear: r * 4 + c + 1
      mut as list of int64: pref2d = []
      mut as int64: total_cells = 16
      mut as int64: z = 1
      infinite (z <= total_cells) {
            pref2d = listPushBack(pref2d, 0)
            z = z + 1
      }

      mut as int64: r = 1
      infinite (r <= rows) {
            mut as int64: c = 1
            infinite (c <= cols) {
                  mut as int64: val = mat[(r - 1) * cols + c]
                  mut as int64: p_up = pref2d[(r - 1) * 4 + c + 1]
                  mut as int64: p_left = pref2d[r * 4 + (c - 1) + 1]
                  mut as int64: p_diag = pref2d[(r - 1) * 4 + (c - 1) + 1]

                  pref2d[r * 4 + c + 1] = val + p_up + p_left - p_diag
                  c = c + 1
            }
            r = r + 1
      }

      #L Consulta retangular em O(1): submatriz de (r1=2, c1=2) ate (r2=3, c2=3)
      #L Elementos: [5, 6], [8, 9] -> Soma = 5 + 6 + 8 + 9 = 28
      mut as int64: r1 = 2
      mut as int64: c1 = 2
      mut as int64: r2 = 3
      mut as int64: c2 = 3

      mut as int64: a2d = pref2d[r2 * 4 + c2 + 1]
      mut as int64: b2d = pref2d[(r1 - 1) * 4 + c2 + 1]
      mut as int64: c2d = pref2d[r2 * 4 + (c1 - 1) + 1]
      mut as int64: d2d = pref2d[(r1 - 1) * 4 + (c1 - 1) + 1]

      mut as int64: rect_sum = a2d - b2d - c2d + d2d
      println("6. Soma submatriz (2,2) a (3,3): " + rect_sum + " (esperado: 28)")
}
