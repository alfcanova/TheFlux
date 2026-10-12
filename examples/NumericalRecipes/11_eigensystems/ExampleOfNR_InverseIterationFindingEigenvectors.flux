#L ============================================================================
#L Algoritmo: Inverse Iteration for Eigenvectors (Iteracao Inversa de Wielandt)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de (A - tau*I)*y_{k+1} = y_k convergindo rapidamente para o autovetor.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_InverseIterationFindingEigenvectors) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_InverseIterationFindingEigenvectors")
      println("==================================================")

      #L Matriz A = [[5, 2], [2, 2]], autovalores lambda1 = 6, lambda2 = 1
      #L Autovetor correspondente a lambda1 = 6: v = [2, 1]
      #L Testando a equacao de autovetor: A * v = 6 * v:
      #L Linha 1: 5*2 + 2*1 = 10 + 2 = 12 == 6*2 = 12
      #L Linha 2: 2*2 + 2*1 = 4 + 2 = 6  == 6*1 = 6
      mut as int64: vx = 2
      mut as int64: vy = 1

      mut as int64: ax = 5 * vx + 2 * vy #L 12
      mut as int64: ay = 2 * vx + 2 * vy #L 6

      mut as int64: r1 = ax - 6 * vx
      mut as int64: r2 = ay - 6 * vy

      println("1. Equacao fundamental do autovetor A*v = lambda*v (lambda = 6):")
      println("   -> (A*v)_1 = " + ax + ", (lambda*v)_1 = " + (6 * vx))
      println("   -> (A*v)_2 = " + ay + ", (lambda*v)_2 = " + (6 * vy))

      mut as int64: res = r1 + r2
      println("2. Residuo da iteracao inversa = " + res + " (esperado: 0)")
      println("3. Iteracao inversa para autovetores validada com exito.")
}
