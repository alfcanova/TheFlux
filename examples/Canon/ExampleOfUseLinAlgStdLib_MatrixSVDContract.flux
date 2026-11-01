use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixSVDContract) {
      println("==================================================")
      println("  Exemplo: MatrixSVDContract (SVD, P-Inv, Minimos Q)")
      println("==================================================")

      #L 1. Decomposicao SVD em Matriz 2x2
      #L A = [[3.0, 0.0], [0.0, 2.0]]
      mut as map: a = tensorNew([2, 2])
      a = tensorSetAt(a, [1, 1], 3.0)
      a = tensorSetAt(a, [2, 2], 2.0)

      mut as list of data: svd = matrixSVD(a)
      mut as map: u = svd[1] as map
      mut as list of data: s = svd[2] as list of data
      mut as map: v = svd[3] as map

      println("1. Valores Singulares de diag(3, 2): " + s)
      println("   U [1, 1] (1.0): " + tensorGetAt(u, [1, 1]))
      println("   V [2, 2] (1.0): " + tensorGetAt(v, [2, 2]))

      #L 2. Pseudo-Inversa de Moore-Penrose A^+
      #L Para diag(3, 2), A^+ deve ser diag(1/3, 1/2) = [0.3333333333333333, 0.5]
      mut as map: pinv = matrixPseudoInverse(a)
      println("2. Pseudo-Inversa [1, 1] (1/3): " + tensorGetAt(pinv, [1, 1]))
      println("   Pseudo-Inversa [2, 2] (1/2): " + tensorGetAt(pinv, [2, 2]))
      println("   Pseudo-Inversa [1, 2] (0.0): " + tensorGetAt(pinv, [1, 2]))

      #L 3. Minimos Quadrados via Householder QR
      #L Ajuste linear y = c1 * x + c0 pelos pontos (1, 2), (2, 3), (3, 5)
      #L Matriz A (3x2): [[1.0, 1.0], [2.0, 1.0], [3.0, 1.0]]
      #L Vetor b (3): [2.0, 3.0, 5.0]
      mut as map: a_ls = tensorNew([3, 2])
      a_ls = tensorSetAt(a_ls, [1, 1], 1.0)
      a_ls = tensorSetAt(a_ls, [1, 2], 1.0)
      a_ls = tensorSetAt(a_ls, [2, 1], 2.0)
      a_ls = tensorSetAt(a_ls, [2, 2], 1.0)
      a_ls = tensorSetAt(a_ls, [3, 1], 3.0)
      a_ls = tensorSetAt(a_ls, [3, 2], 1.0)

      mut as list of data: b_ls = [2.0, 3.0, 5.0]
      mut as list of data: sol_ls = matrixLeastSquares(a_ls, b_ls)
      println("3. Minimos Quadrados coeficientes [c1, c0]: " + sol_ls)
}
