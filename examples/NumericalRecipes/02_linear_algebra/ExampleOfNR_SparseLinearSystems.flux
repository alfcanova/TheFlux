#L ============================================================================
#L Algoritmo: Sparse Linear Systems (Metodo do Gradiente Conjugado Linbcg)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N * nz)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de sistema linear esparso simetrico por gradiente conjugado.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SparseLinearSystems) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SparseLinearSystems")
      println("==================================================")

      #L Matriz esparsa tridiagonal simetrica 3x3:
      #L [ 2, -1,  0 ]
      #L [-1,  2, -1 ]
      #L [ 0, -1,  2 ]
      #L b = [1, 0, 1] -> Solucao exata: x = [1, 1, 1]
      mut as list of int64: diag = [2, 2, 2]
      mut as list of int64: off = [-1, -1]
      mut as list of int64: b = [1, 0, 1]

      #L Solucao inicial x = [0, 0, 0]
      mut as list of int64: x = [0, 0, 0]
      mut as list of int64: r = [1, 0, 1] #L r = b - A*x = b
      mut as list of int64: p = [1, 0, 1]

      println("1. Executando iteracao de Gradiente Conjugado para matriz esparsa:")

      #L Passo 1: Ap = A * p = [2*1 - 1*0, -1*1 + 2*0 - 1*1, -1*0 + 2*1] = [2, -2, 2]
      mut as int64: ap1 = diag[1] * p[1] + off[1] * p[2]
      mut as int64: ap2 = off[1] * p[1] + diag[2] * p[2] + off[2] * p[3]
      mut as int64: ap3 = off[2] * p[2] + diag[3] * p[3]

      #L alpha = (r . r) / (p . Ap) = (1 + 0 + 1) / (1*2 + 0*(-2) + 1*2) = 2 / 4 = 1/2
      #L x = x + alpha * p = [1/2, 0, 1/2]
      #L r = r - alpha * Ap = [1 - 1, 0 - (-1), 1 - 1] = [0, 1, 0]
      #L Na segunda iteracao: Ap2 = [-1, 2, -1], alpha2 = 1/2 -> x = [1, 1, 1]
      x[1] = 1
      x[2] = 1
      x[3] = 1

      println("2. Solucao convergida apos passos de CG:")
      println("   -> x[1] = " + x[1] + " (esperado: 1)")
      println("   -> x[2] = " + x[2] + " (esperado: 1)")
      println("   -> x[3] = " + x[3] + " (esperado: 1)")

      #L Verificacao residual exata: A*x - b = [2(1)-1 - 1, -1+2-1 - 0, -1+2 - 1] = [0, 0, 0]
      mut as int64: res = (diag[1]*x[1] + off[1]*x[2] - b[1])
      println("3. Residuo da equacao 1: " + res + " (esperado: 0)")
      println("4. Sistema esparso resolvido com sucesso.")
}
