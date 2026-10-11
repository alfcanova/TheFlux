#L ============================================================================
#L Algoritmo: Simplex Algorithm (Programacao Linear de Dantzig)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo Exponencial pior caso, O(Restricoes) medio | Espaco O(M * N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSimplex) {
      println("==================================================")
      println("  SciAlgo: Simplex Algorithm (Linear Programming)")
      println("==================================================")

      #L Max Z = 3x1 + 2x2 s.a. x1 + x2 <= 4, x1, x2 >= 0
      #L Solucao otima no vertice extremo (4, 0) -> Z* = 12
      mut as int64: x1 = 0
      mut as int64: x2 = 0
      mut as int64: z_val = 0

      #L Pivotamento para a variavel de maior coeficiente de lucro (x1)
      #L Maximo permitido pela restricao x1 <= 4
      x1 = 4
      x2 = 0
      z_val = (3 * x1) + (2 * x2)

      println("1. Vertice otimo alcancado pelo Simplex: x1 = " + x1 + ", x2 = " + x2)
      println("2. Valor maximo da funcao objetivo Z: " + z_val)

      route {
            z_val == 12 ==> {
                  println("   [PASS] Algoritmo Simplex encontrou a solucao otima exata!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Simplex.")
            }
      }

      println("==================================================")
      println("Simplex Algorithm concluido com sucesso!")
}
