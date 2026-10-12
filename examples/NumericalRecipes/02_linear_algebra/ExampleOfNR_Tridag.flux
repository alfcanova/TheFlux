#L ============================================================================
#L Algoritmo: Tridag (Algoritmo Tridiagonal de Thomas em Tempo Linear)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao direta de sistema tridiagonal a_i x_{i-1} + b_i x_i + c_i x_{i+1} = d_i.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Tridag) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Tridag")
      println("==================================================")

      #L Sistema Tridiagonal 3x3:
      #L [ 2, -1,  0 ] [x1]   [ 1 ]
      #L [-1,  2, -1 ] [x2] = [ 0 ]
      #L [ 0, -1,  2 ] [x3]   [ 1 ]
      #L Diagonais: b = [2, 2, 2], c = [-1, -1], a = [0, -1, -1], d = [1, 0, 1]
      mut as list of int64: b_diag = [2000, 2000, 2000] #L escala 1000
      mut as list of int64: c_diag = [-1000, -1000]
      mut as list of int64: a_diag = [0, -1000, -1000]
      mut as list of int64: d_vec  = [1000, 0, 1000]

      println("1. Executando varredura para a frente (Forward sweep):")
      mut as list of int64: cp = [0, 0]
      mut as list of int64: dp = [0, 0, 0]

      #L Passo i = 1:
      cp[1] = (c_diag[1] * 1000) /i b_diag[1] #L -1000 / 2 = -500
      dp[1] = (d_vec[1] * 1000) /i b_diag[1]  #L 1000 / 2 =  500

      #L Passo i = 2:
      mut as int64: m2 = b_diag[2] - (a_diag[2] * cp[1]) /i 1000 #L 2000 - (-1000 * -500)/1000 = 1500
      cp[2] = (c_diag[2] * 1000) /i m2 #L -1000 * 1000 / 1500 = -666
      dp[2] = ((d_vec[2] - (a_diag[2] * dp[1]) /i 1000) * 1000) /i m2 #L 500 * 1000 / 1500 = 333

      #L Passo i = 3:
      mut as int64: m3 = b_diag[3] - (a_diag[3] * cp[2]) /i 1000
      dp[3] = ((d_vec[3] - (a_diag[3] * dp[2]) /i 1000) * 1000) /i m3

      println("2. Executando substituicao regressiva (Back substitution):")
      mut as list of int64: x = [0, 0, 0]
      x[3] = dp[3]
      x[2] = dp[2] - (cp[2] * x[3]) /i 1000
      x[1] = dp[1] - (cp[1] * x[2]) /i 1000

      println("   -> x[1] = " + (x[1] /i 1000) + " (esperado: 1)")
      println("   -> x[2] = " + (x[2] /i 1000) + " (esperado: 1)")
      println("   -> x[3] = " + (x[3] /i 1000) + " (esperado: 1)")

      println("3. Algoritmo tridiagonal de Thomas concluido com sucesso.")
}
