use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorReductionContract) {
      println("==================================================")
      println("  Exemplo: TensorReductionContract (Soma e L2)")
      println("==================================================")

      #L Matriz T 2x3: [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
      mut as map: t = tensorNew([2, 3])
      t = tensorSetAt(t, [1, 1], 1.0)
      t = tensorSetAt(t, [1, 2], 2.0)
      t = tensorSetAt(t, [1, 3], 3.0)
      t = tensorSetAt(t, [2, 1], 4.0)
      t = tensorSetAt(t, [2, 2], 5.0)
      t = tensorSetAt(t, [2, 3], 6.0)

      #L 1. Reducao por Soma no Eixo 1 (Linhas -> Shape [1, 3])
      mut as map: sum_ax1 = tensorSumAxis(t, 1)
      println("1. Soma Eixo 1 Shape: " + sum_ax1["shape"])
      println("   Soma Col 1 (1+4=5): " + tensorGetAt(sum_ax1, [1, 1]))
      println("   Soma Col 2 (2+5=7): " + tensorGetAt(sum_ax1, [1, 2]))
      println("   Soma Col 3 (3+6=9): " + tensorGetAt(sum_ax1, [1, 3]))

      #L 2. Reducao por Soma no Eixo 2 (Colunas -> Shape [2, 1])
      mut as map: sum_ax2 = tensorSumAxis(t, 2)
      println("2. Soma Eixo 2 Shape: " + sum_ax2["shape"])
      println("   Soma Lin 1 (1+2+3=6): " + tensorGetAt(sum_ax2, [1, 1]))
      println("   Soma Lin 2 (4+5+6=15): " + tensorGetAt(sum_ax2, [2, 1]))

      #L 3. Reducao por Norma L2 no Eixo 1: Matriz [[3.0, 0.0], [4.0, 5.0]]
      mut as map: m = tensorNew([2, 2])
      m = tensorSetAt(m, [1, 1], 3.0)
      m = tensorSetAt(m, [1, 2], 0.0)
      m = tensorSetAt(m, [2, 1], 4.0)
      m = tensorSetAt(m, [2, 2], 5.0)

      mut as map: l2_ax1 = tensorNormL2Axis(m, 1)
      println("3. Norma L2 Eixo 1 Shape: " + l2_ax1["shape"])
      println("   Norma L2 Col 1 (sqrt(3^2 + 4^2) = 5.0): " + tensorGetAt(l2_ax1, [1, 1]))
      println("   Norma L2 Col 2 (sqrt(0^2 + 5^2) = 5.0): " + tensorGetAt(l2_ax1, [1, 2]))
}
