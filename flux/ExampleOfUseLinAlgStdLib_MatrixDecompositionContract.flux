use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixDecompositionContract) {
      println("==================================================")
      println("  Exemplo: MatrixDecompositionContract (LU & Inv)")
      println("==================================================")

      #L Matriz A 2x2: [[2.0, 1.0], [6.0, 8.0]]
      mut as map: a = tensorNew([2, 2])
      a = tensorSetAt(a, [1, 1], 2.0)
      a = tensorSetAt(a, [1, 2], 1.0)
      a = tensorSetAt(a, [2, 1], 6.0)
      a = tensorSetAt(a, [2, 2], 8.0)

      #L 1. Decomposicao PA = LU
      mut as list of data: lu_res = matrixLU(a)
      mut as map: L = lu_res[1] as map
      mut as map: U = lu_res[2] as map
      mut as list of data: P = lu_res[3] as list of data

      println("1. Vetor de Permutacao P: " + P)
      println("   L [2, 1]: " + tensorGetAt(L, [2, 1]))
      println("   U [1, 1]: " + tensorGetAt(U, [1, 1]))
      println("   U [1, 2]: " + tensorGetAt(U, [1, 2]))
      println("   U [2, 2]: " + tensorGetAt(U, [2, 2]))

      #L 2. Resolucao de Sistema Linear Ax = b: b = [5.0, 30.0] -> x = [1.0, 3.0]
      mut as list of data: b = [5.0, 30.0]
      mut as list of data: x = matrixSolveLU(L, U, P, b)
      println("2. Solucao Ax = b (deve ser [1.0, 3.0]): " + x)

      #L 3. Determinante O(n3): det(A) = 2*8 - 1*6 = 10.0
      mut as float64: det = matrixDeterminant(a)
      println("3. Determinante de A (deve ser 10.0): " + det)

      #L 4. Matriz Inversa A^(-1): [[0.8, -0.1], [-0.6, 0.2]]
      mut as map: inv = matrixInverse(a)
      println("4. Inversa [1, 1] (0.8): " + tensorGetAt(inv, [1, 1]))
      println("   Inversa [1, 2] (-0.1): " + tensorGetAt(inv, [1, 2]))
      println("   Inversa [2, 1] (-0.6): " + tensorGetAt(inv, [2, 1]))
      println("   Inversa [2, 2] (0.2): " + tensorGetAt(inv, [2, 2]))
}
