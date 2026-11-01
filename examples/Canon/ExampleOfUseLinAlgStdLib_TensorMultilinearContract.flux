use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorMultilinearContract) {
      println("==================================================")
      println("  Exemplo: TensorMultilinearContract (Tensores 3D)")
      println("==================================================")

      #L 1. Construcao de Tensor 3x3x3 com valores ordenados 1.0 a 27.0
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
      println("1. Tensor 3x3x3 criado com shape: " + t3d["shape"])

      #L 2. Extracao de Fatia 2D (Frontal Slice: fixando axis 1 no indice 2 -> Matriz 3x3)
      #L Elementos: t3d[2, j, k] -> valores de 10.0 a 18.0
      mut as map: slice_ax1 = tensorExtractSlice(t3d, 1, 2)
      println("2. Fatia Extraida no Eixo 1, Indice 2 Shape: " + slice_ax1["shape"])
      println("   Elemento [1, 1] da Fatia (10.0): " + tensorGetAt(slice_ax1, [1, 1]))
      println("   Elemento [2, 2] da Fatia (14.0): " + tensorGetAt(slice_ax1, [2, 2]))
      println("   Elemento [3, 3] da Fatia (18.0): " + tensorGetAt(slice_ax1, [3, 3]))

      #L 3. Diagonal Espacial 3D e Traco 3D
      #L Elementos [1, 1, 1]=1.0, [2, 2, 2]=14.0, [3, 3, 3]=27.0
      #L Traco 3D = 1 + 14 + 27 = 42.0
      mut as list of data: diag3d = tensorDiagonal3D(t3d)
      println("3. Diagonal Espacial 3D: " + diag3d)
      mut as float64: tr3d = tensorTrace3D(t3d)
      println("   Traco Espacial 3D (1 + 14 + 27 = 42.0): " + tr3d)

      #L 4. Troca de Eixos (Swap Axes 1 e 3: shape [3, 3, 3] -> [3, 3, 3])
      #L Valor original em [1, 2, 3] deve estar em [3, 2, 1] apos troca
      mut as float64: orig_val = tensorGetAt(t3d, [1, 2, 3])
      mut as map: swapped = tensorSwapAxes(t3d, 1, 3)
      println("4. Valor original [1, 2, 3] (6.0): " + orig_val)
      println("   Valor em [3, 2, 1] apos troca de eixos (6.0): " + tensorGetAt(swapped, [3, 2, 1]))

      #L 5. Norma de Frobenius N-D para Tensor 3x3x3
      #L sqrt(1^2 + 2^2 + ... + 27^2) = sqrt(27*28*55/6 = 6930) = 83.24662155306446
      mut as float64: frob = tensorFrobeniusNormND(t3d)
      println("5. Norma Frobenius N-D (83.24662155306446): " + frob)

      #L 6. Contracao Tensorial: Tensor 3x3x3 (Eixo 3) x Matriz 3x3 de Uns (Eixo 1)
      #L Contracao soma ao longo da terceira dimensao -> resultado e Tensor 3D [3, 3, 3]
      mut as map: ones_m = matrixOnes([3, 3])
      mut as map: contracted = tensorContract(t3d, ones_m, 3, 1)
      println("6. Contracao Tensorial Shape: " + contracted["shape"])
      #L Em [1, 1, 1]: t3d[1, 1, 1]*1 + t3d[1, 1, 2]*1 + t3d[1, 1, 3]*1 = 1+2+3 = 6.0
      println("   Elemento [1, 1, 1] (1+2+3 = 6.0): " + tensorGetAt(contracted, [1, 1, 1]))
}
