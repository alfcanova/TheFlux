#L ============================================================================
#L Algoritmo: Newton's Method (Otimizacao de Segunda Ordem com Hessiana)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * D^3) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoNewton) {
      println("==================================================")
      println("  SciAlgo: Newton's Method (Hessian Optimization)")
      println("==================================================")

      #L Minimiza f(x) = 3x^2 - 18x + 20. Minimo em x* = 3
      #L f'(x) = 6x - 18, f''(x) = 6
      #L Passo de Newton puro: x_{t+1} = x_t - f'(x) / f''(x)
      mut as int64: x = 25
      println("1. Ponto de partida: x = " + x)

      mut as int64: grad = (6 * x) - 18
      mut as int64: hessian = 6
      x = x - (grad /i hessian)

      println("2. Ponto apos 1 passo de Newton exato: x = " + x)
      route {
            x == 3 ==> {
                  println("   [PASS] Metodo de Newton convergiu exatamente em 1 passo quadratico!")
            }
            _ ==> {
                  println("   [ERRO] Falha no metodo de Newton.")
            }
      }

      println("==================================================")
      println("Newton Optimization concluido com sucesso!")
}
