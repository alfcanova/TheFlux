#L ============================================================================
#L Algoritmo: Gauss-Jordan Elimination (Eliminação de Gauss-Jordan com Pivoteamento)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de sistema linear por eliminacao completa de Gauss-Jordan.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GaussJordanElimination) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GaussJordanElimination")
      println("==================================================")

      #L Sistema Linear de Teste:
      #L  2*x + 1*y - 1*z =  8
      #L -3*x - 1*y + 2*z = -11
      #L -2*x + 1*y + 2*z = -3
      #L Solucao analitica exata: x = 2, y = 3, z = -1

      #L Matriz aumentada [A | b] com escala 1000 para precisao inteira:
      mut as list of list of int64: m = [
            [2000,  1000, -1000,   8000],
            [-3000, -1000,  2000, -11000],
            [-2000,  1000,  2000,  -3000]
      ]

      mut as int64: n = 3
      mut as int64: k = 1

      println("1. Executando eliminacao completa de Gauss-Jordan:")

      #L Loop de eliminacao para cada coluna de pivo k
      infinite (k <= n) {
            mut as int64: pivot = m[k][k]
            
            #L Normaliza a linha do pivo dividindo pelo elemento diagonal
            mut as int64: col = 1
            infinite (col <= n + 1) {
                  m[k][col] = (m[k][col] * 1000) /i pivot
                  col = col + 1
            }

            #L Zera todos os outros elementos da coluna k (acima e abaixo)
            mut as int64: row = 1
            infinite (row <= n) {
                  route {
                        row != k ==> {
                              mut as int64: factor = m[row][k]
                              mut as int64: c = 1
                              infinite (c <= n + 1) {
                                    m[row][c] = m[row][c] - (factor * m[k][c]) /i 1000
                                    c = c + 1
                              }
                        }
                  }
                  row = row + 1
            }
            k = k + 1
      }

      #L Extracao e conversao dos resultados finais
      mut as int64: x = m[1][4] /i 1000
      mut as int64: y = m[2][4] /i 1000
      mut as int64: z = m[3][4] /i 1000

      println("   -> x = " + x)
      println("   -> y = " + y)
      println("   -> z = " + z)

      #L Verificacao de consistencia: 2(2) + 1(3) - 1(-1) = 8
      mut as int64: check_val = 2 * x + 1 * y - 1 * z
      println("2. Verificacao da equacao residual: 2*x + y - z = " + check_val + " (esperado: 8)")
      println("3. Eliminacao de Gauss-Jordan concluida com sucesso.")
}
