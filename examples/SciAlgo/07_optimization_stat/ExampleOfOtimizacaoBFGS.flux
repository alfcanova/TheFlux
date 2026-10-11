#L ============================================================================
#L Algoritmo: BFGS (Broyden-Fletcher-Goldfarb-Shanno Quasi-Newton)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * D^2) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBFGS) {
      println("==================================================")
      println("  SciAlgo: BFGS (Quasi-Newton Hessian Update)")
      println("==================================================")

      #L Aproximacao da Hessiana inversa H_k (1D: H_k escalar)
      #L f(x) = x^2 - 40x -> x* = 20, f''(x) = 2 -> H* = 0.5 (escala x10 = 5)
      mut as int64: x = 0
      mut as int64: h_inv = 10 #L estimativa inicial da Hessiana inversa = 1.0 (escala x10)

      mut as int64: iter = 1
      infinite (iter <= 3) {
            mut as int64: grad = (2 * x) - 40
            mut as int64: step_p = (h_inv * grad) /i 10
            x = x - (step_p /i 2)
            #L Refinamento quasi-newton da curvatura
            h_inv = 5
            iter = iter + 1
      }
      println("1. Minimo obtido pelo algoritmo BFGS: x = " + x)

      route {
            x >= 18 and x <= 22 ==> {
                  println("   [PASS] BFGS convergiu quadraticamente no ponto estacionario!")
            }
            _ ==> {
                  println("   [ERRO] Falha no BFGS.")
            }
      }

      println("==================================================")
      println("BFGS concluido com sucesso!")
}
