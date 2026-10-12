#L ============================================================================
#L Algoritmo: Vector and Matrix Operations (Operacoes Vetoriais e Matriciais)
#L Capitulo: 01_preliminaries
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Operacoes lineares fundamentais de produto escalar e matriz-vetor.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_VectorMatrixObjects) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_VectorMatrixObjects")
      println("==================================================")

      #L Vetores de dimensao 3: u = [1, 2, 3], v = [4, 5, 6]
      mut as list of int64: u = [1, 2, 3]
      mut as list of int64: v = [4, 5, 6]

      #L 1. Produto escalar (dot product): u . v = 1*4 + 2*5 + 3*6 = 32
      mut as int64: dot_prod = 0
      mut as int64: i = 1
      infinite (i <= 3) {
            dot_prod = dot_prod + u[i] * v[i]
            i = i + 1
      }
      println("1. Produto escalar u . v = " + dot_prod + " (esperado: 32)")

      #L 2. Multiplicacao matriz-vetor: y = A * u
      #L Matriz A 3x3:
      #L [1, 2, 0]
      #L [0, 1, 1]
      #L [2, 0, 1]
      mut as list of list of int64: a = [
            [1, 2, 0],
            [0, 1, 1],
            [2, 0, 1]
      ]

      mut as list of int64: y = [0, 0, 0]
      mut as int64: r = 1
      infinite (r <= 3) {
            mut as int64: sum_row = 0
            mut as int64: c = 1
            infinite (c <= 3) {
                  sum_row = sum_row + a[r][c] * u[c]
                  c = c + 1
            }
            y[r] = sum_row
            r = r + 1
      }

      #L y[1] = 1*1 + 2*2 + 0*3 = 5
      #L y[2] = 0*1 + 1*2 + 1*3 = 5
      #L y[3] = 2*1 + 0*2 + 1*3 = 5
      println("2. Multiplicacao Matriz-Vetor y = A * u:")
      println("   -> y[1] = " + y[1] + " (esperado: 5)")
      println("   -> y[2] = " + y[2] + " (esperado: 5)")
      println("   -> y[3] = " + y[3] + " (esperado: 5)")

      println("3. Operacoes com vetores e matrizes concluidas com sucesso.")
}
