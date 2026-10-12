#L ============================================================================
#L Algoritmo: Iterative Improvement of Solutions (Refinamento Iterativo Mprove)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^2) por iteracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Reducao iterativa do residuo linear e correcao de arredondamento.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_IterativeImprovement) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_IterativeImprovement")
      println("==================================================")

      #L Sistema A * x = b onde A = [[3, 1], [1, 2]], b = [9, 8], solucao exata: x = [2, 3]
      #L Solucao inicial aproximada com perturbacao: x0 = [1900, 3100] (escala 1000)
      mut as list of list of int64: a = [
            [3000, 1000],
            [1000, 2000]
      ]
      mut as list of int64: b = [9000, 8000]
      mut as list of int64: x = [1900, 3100]

      println("1. Solucao inicial aproximada: x[1]=" + x[1] + ", x[2]=" + x[2])

      #L 1. Calculo do residuo r = b - A * x
      mut as int64: ax1 = (a[1][1] * x[1] + a[1][2] * x[2]) /i 1000
      mut as int64: ax2 = (a[2][1] * x[1] + a[2][2] * x[2]) /i 1000
      mut as int64: r1 = b[1] - ax1
      mut as int64: r2 = b[2] - ax2

      println("2. Residuo inicial r = b - A*x: r[1]=" + r1 + ", r[2]=" + r2)

      #L 2. Resolvendo sistema de correcao A * delta = r via inversa 2x2
      #L det(A) = 3*2 - 1*1 = 5
      #L A_inv = [[2/5, -1/5], [-1/5, 3/5]]
      mut as int64: delta1 = (2 * r1 - 1 * r2) /i 5
      mut as int64: delta2 = (-1 * r1 + 3 * r2) /i 5

      #L 3. Atualizando solucao refinada: x_novo = x + delta
      x[1] = x[1] + delta1
      x[2] = x[2] + delta2

      println("3. Solucao refinada apos passo de correcao:")
      println("   -> x[1] = " + (x[1] /i 1000) + " (esperado: 2)")
      println("   -> x[2] = " + (x[2] /i 1000) + " (esperado: 3)")

      #L Novo residuo
      mut as int64: ax1_new = (a[1][1] * x[1] + a[1][2] * x[2]) /i 1000
      mut as int64: ax2_new = (a[2][1] * x[1] + a[2][2] * x[2]) /i 1000
      mut as int64: final_res = (b[1] - ax1_new) + (b[2] - ax2_new)
      println("4. Residuo final da solucao refinada = " + final_res + " (esperado: 0)")
      println("5. Refinamento iterativo concluido.")
}
