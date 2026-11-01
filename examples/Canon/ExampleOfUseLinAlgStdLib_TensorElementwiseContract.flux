use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorElementwiseContract) {
      println("==================================================")
      println("  Exemplo: TensorElementwiseContract (Tensores 3D)")
      println("==================================================")

      #L Criando Tensor 3x3x3 com valores 1.0 a 27.0
      mut as map: t1 = tensorNew([3, 3, 3])
      mut as int64: idx = 1
      mut as int64: i = 1
      infinite (i <= 3) {
            mut as int64: j = 1
            infinite (j <= 3) {
                  mut as int64: k = 1
                  infinite (k <= 3) {
                        t1 = tensorSetAt(t1, [i, j, k], idx as float64)
                        idx = idx + 1
                        k = k + 1
                  }
                  j = j + 1
            }
            i = i + 1
      }

      #L Tensor 3x3x3 de Uns
      mut as map: t2 = matrixOnes([3, 3, 3])

      #L 1. Subtracao Elemento a Elemento: t1 - t2
      mut as map: sub = tensorSubElementwise(t1, t2)
      println("1. Subtracao Elementwise [1, 1, 1] (1 - 1 = 0): " + tensorGetAt(sub, [1, 1, 1]))
      println("   Subtracao Elementwise [3, 3, 3] (27 - 1 = 26): " + tensorGetAt(sub, [3, 3, 3]))

      #L 2. Multiplicacao de Hadamard: t1 (o) t2 (com escala 2.0)
      mut as map: scaled2 = tensorMulScalar(t2, 2.0)
      mut as map: hadamard = tensorMulElementwise(t1, scaled2)
      println("2. Hadamard Product [2, 2, 2] (14 * 2 = 28): " + tensorGetAt(hadamard, [2, 2, 2]))

      #L 3. Divisao Elemento a Elemento: hadamard / scaled2 = t1
      mut as map: div = tensorDivElementwise(hadamard, scaled2)
      println("3. Divisao Elementwise [2, 2, 2] (28 / 2 = 14): " + tensorGetAt(div, [2, 2, 2]))

      #L 4. Media por Eixo (Mean Axis 1 -> Shape [1, 3, 3])
      #L Linha 1, col 1, prof 1: (1 + 10 + 19) / 3 = 30 / 3 = 10.0
      mut as map: mean_ax1 = tensorMeanAxis(t1, 1)
      println("4. Media Eixo 1 Shape: " + mean_ax1["shape"])
      println("   Media Eixo 1 em [1, 1, 1] ((1+10+19)/3 = 10.0): " + tensorGetAt(mean_ax1, [1, 1, 1]))

      #L 5. Minimo e Maximo por Eixo 1
      mut as map: min_ax1 = tensorMinAxis(t1, 1)
      mut as map: max_ax1 = tensorMaxAxis(t1, 1)
      println("5. Minimo Eixo 1 em [1, 1, 1] (1.0): " + tensorGetAt(min_ax1, [1, 1, 1]))
      println("   Maximo Eixo 1 em [1, 1, 1] (19.0): " + tensorGetAt(max_ax1, [1, 1, 1]))

      #L 6. Clamping / Saturacao de Valores no Intervalo [5.0, 20.0]
      mut as map: clamped = tensorClamp(t1, 5.0, 20.0)
      println("6. Clamped [1, 1, 1] (1.0 limitado a 5.0): " + tensorGetAt(clamped, [1, 1, 1]))
      println("   Clamped [2, 2, 2] (14.0 inalterado): " + tensorGetAt(clamped, [2, 2, 2]))
      println("   Clamped [3, 3, 3] (27.0 limitado a 20.0): " + tensorGetAt(clamped, [3, 3, 3]))
}
