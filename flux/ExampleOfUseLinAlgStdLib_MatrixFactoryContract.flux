use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixFactoryContract) {
      println("==================================================")
      println("  Exemplo: MatrixFactoryContract (Fabricas)")
      println("==================================================")

      #L 1. Matriz Identidade I_3
      mut as map: eye = matrixIdentity(3)
      println("1. Identidade 3x3 Shape: " + eye["shape"])
      println("   Diagonal [1, 1]: " + tensorGetAt(eye, [1, 1]))
      println("   Diagonal [2, 2]: " + tensorGetAt(eye, [2, 2]))
      println("   Diagonal [3, 3]: " + tensorGetAt(eye, [3, 3]))
      println("   Fora da diagonal [1, 2]: " + tensorGetAt(eye, [1, 2]))

      #L 2. Tensor 3x3x3 de Zeros e de Uns
      mut as map: z3d = matrixZeros([3, 3, 3])
      println("2. Tensor Zeros 3x3x3 Shape: " + z3d["shape"])
      println("   Zeros em [2, 2, 2]: " + tensorGetAt(z3d, [2, 2, 2]))

      mut as map: ones3d = matrixOnes([3, 3, 3])
      println("   Tensor Uns 3x3x3 Shape: " + ones3d["shape"])
      println("   Uns em [1, 2, 3]: " + tensorGetAt(ones3d, [1, 2, 3]))
      println("   Uns em [3, 3, 3]: " + tensorGetAt(ones3d, [3, 3, 3]))

      #L 3. Matriz Diagonal a partir de Lista
      mut as map: diag_mat = matrixDiagonal([5.0, 10.0, 15.0])
      println("3. Matriz Diagonal Shape: " + diag_mat["shape"])
      println("   Elemento [2, 2]: " + tensorGetAt(diag_mat, [2, 2]))

      #L 4. Extracao de Diagonal e Traco
      mut as map: m = tensorNew([3, 3])
      m = tensorSetAt(m, [1, 1], 2.0)
      m = tensorSetAt(m, [1, 2], 4.0)
      m = tensorSetAt(m, [2, 2], 5.0)
      m = tensorSetAt(m, [3, 3], 8.0)

      mut as list of data: d = matrixExtractDiagonal(m)
      println("4. Diagonal Extraida: " + d)
      mut as float64: tr = matrixTrace(m)
      println("   Traco da Matriz (2+5+8=15): " + tr)

      #L 5. Triangular Superior (Triu) e Inferior (Tril)
      mut as map: u = matrixTriu(m, 0)
      mut as map: l = matrixTril(m, 0)
      println("5. Triu [1, 2] (mantido 4.0): " + tensorGetAt(u, [1, 2]))
      println("   Tril [1, 2] (zerado 0.0): " + tensorGetAt(l, [1, 2]))
}
