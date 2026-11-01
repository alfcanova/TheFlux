use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixQRContract) {
      println("==================================================")
      println("  Exemplo: MatrixQRContract (Householder QR)")
      println("==================================================")

      #L Matriz A 2x2: [[3.0, 1.0], [4.0, 2.0]]
      mut as map: a = tensorNew([2, 2])
      a = tensorSetAt(a, [1, 1], 3.0)
      a = tensorSetAt(a, [1, 2], 1.0)
      a = tensorSetAt(a, [2, 1], 4.0)
      a = tensorSetAt(a, [2, 2], 2.0)

      #L 1. Decomposicao QR via Householder
      mut as list of data: qr_res = matrixQR(a)
      mut as map: Q = qr_res[1] as map
      mut as map: R = qr_res[2] as map

      println("1. Q Shape: " + Q["shape"])
      println("   R Shape: " + R["shape"])
      #L R deve ser triangular superior (R[2, 1] == 0.0)
      println("   R [1, 1] (-5.0): " + tensorGetAt(R, [1, 1]))
      println("   R [2, 1] (0.0): " + tensorGetAt(R, [2, 1]))

      #L 2. Resolucao Ax = b via QRx = b: b = [5.0, 8.0] -> x = [1.0, 2.0]
      mut as list of data: b = [5.0, 8.0]
      mut as list of data: x = matrixSolveQR(Q, R, b)
      println("2. Solucao via QR (deve ser [1.0, 2.0]): " + x)
}
