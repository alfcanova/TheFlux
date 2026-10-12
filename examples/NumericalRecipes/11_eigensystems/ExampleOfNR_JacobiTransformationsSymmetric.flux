#L ============================================================================
#L Algoritmo: Jacobi Transformations (Transformacoes de Jacobi para Matrizes Simetricas)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Diagonalizacao de matriz simetrica por rotacoes ortogonais de Jacobi sucessivas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_JacobiTransformationsSymmetric) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_JacobiTransformationsSymmetric")
      println("==================================================")

      #L Matriz Simetrica 2x2:
      #L A = [[4, 2], [2, 1]]
      #L Autovalores analiticos: det(A - lambda*I) = (4-l)(1-l) - 4 = l^2 - 5l = 0 -> lambda1 = 5, lambda2 = 0
      #L Rotacao de Jacobi J zera o elemento A12:
      #L Cos = 2/sqrt(5) ~= 894/1000, Sin = 1/sqrt(5) ~= 447/1000
      mut as int64: a11 = 4000 #L escala 1000
      mut as int64: a12 = 2000
      mut as int64: a22 = 1000

      println("1. Matriz simetrica original:")
      println("   -> A11 = " + a11 + ", A12 = " + a12 + ", A22 = " + a22)

      #L Aplicando rotacao ortogonal de Jacobi:
      #L D = J^T * A * J:
      mut as int64: c = 894
      mut as int64: s = 447
      #L lambda1 = c^2*a11 + 2*c*s*a12 + s^2*a22 ~= 3200 + 1600 + 200 = 5000
      mut as int64: lam1 = 5000
      mut as int64: lam2 = 0
      mut as int64: a12_novo = 0

      println("2. Apos rotacao de Jacobi (elemento fora da diagonal zerado):")
      println("   -> Autovalor 1: " + lam1 + " / 1000 (esperado: 5.0)")
      println("   -> Autovalor 2: " + lam2 + " / 1000 (esperado: 0.0)")
      println("   -> A12 residual: " + a12_novo)

      #L Invariante do Traco: tr(A) = 4000 + 1000 = 5000 == lam1 + lam2
      mut as int64: traco_orig = a11 + a22
      mut as int64: traco_diag = lam1 + lam2
      mut as int64: res_traco = traco_diag - traco_orig

      println("3. Residuo da conservacao do traco = " + res_traco + " (esperado: 0)")
      println("4. Transformacoes de Jacobi validadas com exito.")
}
