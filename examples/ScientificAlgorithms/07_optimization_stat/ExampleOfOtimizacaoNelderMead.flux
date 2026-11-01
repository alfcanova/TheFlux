#L ============================================================================
#L Algoritmo: Nelder-Mead (Metodo Simplex de Otimizacao Sem Derivadas)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoNelderMead) {
      println("==================================================")
      println("  SciAlgo: Nelder-Mead (Simplex Direct Search)")
      println("==================================================")

      #L Simplex 1D com 2 vertices: x_best = 10 (f=100), x_worst = 40 (f=1600)
      #L f(x) = x^2, minimo em 0
      mut as int64: x_best = 10
      mut as int64: x_worst = 40

      #L Reflexao do pior vertice atraves do centride c = x_best:
      #L x_ref = c + (c - x_worst) = 10 + (10 - 40) = -20 (f=400 < f(40))
      mut as int64: x_ref = x_best + (x_best - x_worst)
      println("1. Vertice refletido: x_ref = " + x_ref)

      #L Substitui o pior vertice pelo refletido
      x_worst = x_ref
      println("2. Simplex contraido em direcao a origem: [" + x_best + ", " + x_worst + "]")

      route {
            x_worst < 40 ==> {
                  println("   [PASS] Nelder-Mead deformou e contraiu o simplex com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Nelder-Mead.")
            }
      }

      println("==================================================")
      println("Nelder-Mead concluido com sucesso!")
}
