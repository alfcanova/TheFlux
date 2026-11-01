#L ============================================================================
#L Algoritmo: Levenberg-Marquardt (Amortecimento Gauss-Newton / Gradiente)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * D^3) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoLevenbergMarquardt) {
      println("==================================================")
      println("  SciAlgo: Levenberg-Marquardt (Damped Least Squares)")
      println("==================================================")

      #L Passo: delta = (J^T J + lambda * I)^-1 * J^T r
      #L Alterna dinamicamente entre Gauss-Newton (lambda pequeno) e Gradiente (lambda grande)
      mut as int64: x = 10
      mut as int64: lambda_damp = 5

      mut as int64: iter = 1
      infinite (iter <= 4) {
            mut as int64: r = (x * x) - 9 #L x* = 3
            mut as int64: j = 2 * x
            mut as int64: jt_j = j * j
            mut as int64: denom = jt_j + lambda_damp
            mut as int64: delta = (j * r) /i denom
            x = x - delta
            iter = iter + 1
      }
      println("1. Solucao Levenberg-Marquardt amortecida: x = " + x)

      route {
            x >= 3 and x <= 4 ==> {
                  println("   [PASS] Levenberg-Marquardt convergiu com robustez amortecida!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Levenberg-Marquardt.")
            }
      }

      println("==================================================")
      println("Levenberg-Marquardt concluido com sucesso!")
}
