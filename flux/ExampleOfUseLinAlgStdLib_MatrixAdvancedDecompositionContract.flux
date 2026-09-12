use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract) {
      println("==================================================")
      println("  Exemplo: MatrixAdvancedDecompositionContract")
      println("==================================================")

      #L 1. Fatoracao de Cholesky A = L * L^T em Matriz Positiva-Definida
      #L A = [[4.0, 12.0], [12.0, 45.0]] -> L = [[2.0, 0.0], [6.0, 3.0]]
      mut as map: a_spd = tensorNew([2, 2])
      a_spd = tensorSetAt(a_spd, [1, 1], 4.0)
      a_spd = tensorSetAt(a_spd, [1, 2], 12.0)
      a_spd = tensorSetAt(a_spd, [2, 1], 12.0)
      a_spd = tensorSetAt(a_spd, [2, 2], 45.0)

      mut as map: L = matrixCholesky(a_spd)
      println("1. Cholesky L [1, 1] (2.0): " + tensorGetAt(L, [1, 1]))
      println("   Cholesky L [2, 1] (6.0): " + tensorGetAt(L, [2, 1]))
      println("   Cholesky L [2, 2] (3.0): " + tensorGetAt(L, [2, 2]))

      #L 2. Resolucao Eficiente via Cholesky: Ax = b com b = [20.0, 69.0] -> x = [2.0, 1.0]
      mut as list of data: b = [20.0, 69.0]
      mut as list of data: x = matrixSolveCholesky(L, b)
      println("2. Solucao via Cholesky (deve ser [2.0, 1.0]): " + x)

      #L 3. Metodo das Potencias (Power Iteration para Autovalor Dominante)
      mut as map: a_sym = tensorNew([2, 2])
      a_sym = tensorSetAt(a_sym, [1, 1], 2.0)
      a_sym = tensorSetAt(a_sym, [1, 2], 1.0)
      a_sym = tensorSetAt(a_sym, [2, 1], 1.0)
      a_sym = tensorSetAt(a_sym, [2, 2], 2.0)

      mut as list of data: p_res = matrixPowerIteration(a_sym, 20, 0.0001)
      println("3. Autovalor Dominante via Power Iteration (3.0): " + p_res[1])

      #L 4. Posto (Rank) e Norma Matricial de Frobenius
      mut as int64: r = matrixRank(a_sym, 0.00001)
      println("4. Posto da Matriz (Rank 2): " + r)
      mut as float64: frob = matrixFrobeniusNorm(a_sym)
      mut as bool: frob_ok = (frob > 3.1622) and (frob < 3.1624)
      println("   Norma de Frobenius sqrt(10) (~3.162): " + frob_ok)
}
