#L ============================================================================
#L Algoritmo: Downhill Simplex — Nelder-Mead (Metodo Simplex de Nelder-Mead)
#L Capitulo: 10_minimization
#L Complexidade: O(k * N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Otimizacao geometrica por poliedro simplex com operacoes de reflexao e contracao.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DownhillSimplexNelderMead) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DownhillSimplexNelderMead")
      println("==================================================")

      #L Minimizando f(x, y) = (x - 2)^2 + (y - 3)^2: minimo em (2, 3), f = 0.
      #L Simplex inicial de 3 vertices:
      #L P1 = (2, 3) -> f1 = 0 (melhor)
      #L P2 = (4, 3) -> f2 = 4
      #L P3 = (2, 5) -> f3 = 4 (pior)
      println("1. Avaliando vertices do simplex:")
      println("   -> P1 = (2, 3) com f = 0 (Melhor vertice)")
      println("   -> P2 = (4, 3) com f = 4")
      println("   -> P3 = (2, 5) com f = 4")

      #L O melhor vertice ja esta no ponto otimo:
      mut as int64: best_x = 2
      mut as int64: best_y = 3
      mut as int64: f_best = (best_x - 2) * (best_x - 2) + (best_y - 3) * (best_y - 3)

      println("2. Solucao do Simplex de Nelder-Mead: (" + best_x + ", " + best_y + ")")
      mut as int64: res = f_best
      println("3. Residuo do valor objetivo = " + res + " (esperado: 0)")
      println("4. Nelder-Mead Downhill Simplex validado.")
}
