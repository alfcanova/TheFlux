use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorMathContract) {
      println("==================================================")
      println("  Exemplo: TensorMathContract (Reducoes e Unarias)")
      println("==================================================")

      #L 1. Construcao de Tensor 3x3x3 com valores 1.0 a 27.0
      #L Soma total: 27 * 28 / 2 = 378.0
      #L Media: 378 / 27 = 14.0
      mut as map: t3d = tensorNew([3, 3, 3])
      mut as int64: val = 1
      mut as int64: i = 1
      infinite (i <= 3) {
            mut as int64: j = 1
            infinite (j <= 3) {
                  mut as int64: k = 1
                  infinite (k <= 3) {
                        t3d = tensorSetAt(t3d, [i, j, k], val as float64)
                        val = val + 1
                        k = k + 1
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("1. Reducoes Globais no Tensor 3x3x3:")
      mut as float64: sum_all = tensorSumAll(t3d)
      println("   Soma Total (378.0): " + sum_all)
      mut as float64: mean_all = tensorMeanAll(t3d)
      println("   Media Total (14.0): " + mean_all)
      mut as float64: min_all = tensorMinAll(t3d)
      println("   Minimo Total (1.0): " + min_all)
      mut as float64: max_all = tensorMaxAll(t3d)
      println("   Maximo Total (27.0): " + max_all)

      #L 2. Operacoes Elementwise Unarias
      mut as map: neg_t = tensorNeg(t3d)
      println("2. Negacao [1, 1, 1] (-1.0): " + tensorGetAt(neg_t, [1, 1, 1]))
      println("   Negacao [3, 3, 3] (-27.0): " + tensorGetAt(neg_t, [3, 3, 3]))

      mut as map: abs_t = tensorAbs(neg_t)
      println("   Absoluto do Negado [3, 3, 3] (27.0): " + tensorGetAt(abs_t, [3, 3, 3]))

      #L 3. Raiz Quadrada Elementwise em Tensor 3x3x3
      mut as map: sqrt_t = tensorSqrtElementwise(t3d)
      println("3. Raiz Quadrada [1, 1, 1] (sqrt(1)=1.0): " + tensorGetAt(sqrt_t, [1, 1, 1]))
      println("   Raiz Quadrada [1, 1, 4... ops [1, 2, 1]=4 -> sqrt(4)=2.0]: " + tensorGetAt(sqrt_t, [1, 2, 1]))
      println("   Raiz Quadrada [1, 3, 3]=9 -> sqrt(9)=3.0: " + tensorGetAt(sqrt_t, [1, 3, 3]))

      #L 4. Potencia Escalar Elementwise (ex: x^2)
      mut as map: pow2 = tensorPowerScalar(t3d, 2)
      println("4. Potencia ao Quadrado [1, 1, 2]=2 -> 2^2=4.0: " + tensorGetAt(pow2, [1, 1, 2]))
      println("   Potencia ao Quadrado [1, 2, 2]=5 -> 5^2=25.0: " + tensorGetAt(pow2, [1, 2, 2]))
}
