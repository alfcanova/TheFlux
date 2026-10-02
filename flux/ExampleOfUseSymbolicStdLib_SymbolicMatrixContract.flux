use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicMatrixContract) {
      println("==================================================")
      println("  Exemplo: SymbolicMatrixContract (Fase 2)")
      println("==================================================")

      mut as list of data: r1_2x2 = ["x", "1"]
      mut as list of data: r2_2x2 = ["2", "x"]
      mut as list of data: m2x2 = [r1_2x2, r2_2x2]
      println("1. symbolicMatrixDeterminant 2x2: " + SymbolicStdLib.symbolicMatrixDeterminant(m2x2))

      mut as list of data: r1_3x3 = ["1", "0", "0"]
      mut as list of data: r2_3x3 = ["0", "2", "0"]
      mut as list of data: r3_3x3 = ["0", "0", "3"]
      mut as list of data: m3x3 = [r1_3x3, r2_3x3, r3_3x3]
      println("2. symbolicMatrixDeterminant 3x3: " + SymbolicStdLib.symbolicMatrixDeterminant(m3x3))

      mut as list of data: funcs = ["x ^e 2 + y", "3 * x * y"]
      mut as list of data: vars = ["x", "y"]
      mut as list of data: jac = SymbolicStdLib.symbolicMatrixJacobian(funcs, vars)
      mut as list of data: j_r1 = jac[1] as list of data
      mut as list of data: j_r2 = jac[2] as list of data
      println("3. symbolicMatrixJacobian:")
      println("   Linha 1: " + j_r1[1] + ", " + j_r1[2])
      println("   Linha 2: " + j_r2[1] + ", " + j_r2[2])

      mut as list of data: hess = SymbolicStdLib.symbolicMatrixHessian("x ^e 3 + x * y ^e 2", vars)
      mut as list of data: h_r1 = hess[1] as list of data
      mut as list of data: h_r2 = hess[2] as list of data
      println("4. symbolicMatrixHessian:")
      println("   Linha 1: " + h_r1[1] + ", " + h_r1[2])
      println("   Linha 2: " + h_r2[1] + ", " + h_r2[2])
}
