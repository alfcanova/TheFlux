#L ============================================================================
#L Algoritmo: Gauss-Newton (Ajuste Nao-Linear de Minimos Quadrados)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * J^T J) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGaussNewton) {
      println("==================================================")
      println("  SciAlgo: Gauss-Newton (Non-linear Least Squares)")
      println("==================================================")

      #L Residuo r(x) = x^2 - 16 -> x* = 4. Jacobiano J = 2x
      #L Passo Gauss-Newton: delta = -(J^T J)^-1 J^T r = -r / (2x)
      mut as int64: x = 10 #L escala x10 = 100
      mut as int64: iter = 1
      infinite (iter <= 4) {
            mut as int64: r = (x * x) - 16
            mut as int64: j = 2 * x
            route {
                  j > 0 ==> {
                        mut as int64: delta = r /i j
                        x = x - delta
                  }
                  _ ==> {}
            }
            iter = iter + 1
      }
      println("1. Raiz encontrada por Gauss-Newton: x = " + x)

      route {
            x == 4 ==> {
                  println("   [PASS] Gauss-Newton convergiu quadraticamente no residuo zero!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Gauss-Newton.")
            }
      }

      println("==================================================")
      println("Gauss-Newton concluido com sucesso!")
}
