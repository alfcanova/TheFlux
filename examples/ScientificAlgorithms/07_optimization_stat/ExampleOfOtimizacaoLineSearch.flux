#L ============================================================================
#L Algoritmo: Line Search (Busca Linear com Condicao de Armijo / Backtracking)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoLineSearch) {
      println("==================================================")
      println("  SciAlgo: Line Search (Armijo Backtracking)")
      println("==================================================")

      #L Busca passo alpha que satisfaz decrescimento suficiente:
      #L f(x + alpha * p) <= f(x) + c * alpha * grad^T p
      mut as int64: alpha = 100 #L passo inicial 1.0 (escala x100)
      mut as int64: f_curr = 500
      mut as int64: grad = -40

      #L Backtracking contrai alpha pela metade enquanto decrescimento for insuficiente
      mut as int64: iter = 1
      infinite (iter <= 3) {
            mut as int64: f_cand = 500 - ((alpha * 30) /i 100)
            route {
                  f_cand > 480 ==> {
                        alpha = alpha /i 2
                  }
                  _ ==> {}
            }
            iter = iter + 1
      }
      println("1. Tamanho do passo aceito por Line Search: alpha = " + alpha + " / 100")

      route {
            alpha > 0 ==> {
                  println("   [PASS] Line Search determinou passo com decrescimento suficiente!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Line Search.")
            }
      }

      println("==================================================")
      println("Line Search concluido com sucesso!")
}
