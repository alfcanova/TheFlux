use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorTransformContract) {
      println("==================================================")
      println("  Exemplo: TensorTransformContract (Tensores 3D)")
      println("==================================================")

      #L 1. Construcao de Tensor 3x3x3 (27 elementos)
      mut as map: t3x3x3 = tensorNew([3, 3, 3])
      mut as int64: idx = 1
      mut as int64: i = 1
      infinite (i <= 3) {
            mut as int64: j = 1
            infinite (j <= 3) {
                  mut as int64: k = 1
                  infinite (k <= 3) {
                        t3x3x3 = tensorSetAt(t3x3x3, [i, j, k], idx as float64)
                        idx = idx + 1
                        k = k + 1
                  }
                  j = j + 1
            }
            i = i + 1
      }
      println("1. Tensor 3D Original Shape: " + t3x3x3["shape"])
      println("   Elemento [1, 1, 1] (1.0): " + tensorGetAt(t3x3x3, [1, 1, 1]))
      println("   Elemento [2, 2, 2] (14.0): " + tensorGetAt(t3x3x3, [2, 2, 2]))
      println("   Elemento [3, 3, 3] (27.0): " + tensorGetAt(t3x3x3, [3, 3, 3]))

      #L 2. Reshape de Tensor 3x3x3 para Matriz 9x3 e Matriz 1x27
      mut as map: t9x3 = tensorReshape(t3x3x3, [9, 3])
      println("2. Reshape 3x3x3 -> 9x3 Shape: " + t9x3["shape"])
      println("   Elemento [5, 2] no Reshape (deve ser 14.0): " + tensorGetAt(t9x3, [5, 2]))

      #L 3. Flatten (Achatamento para Lista 1D)
      mut as list of data: flat = tensorFlatten(t3x3x3)
      mut as int64: flat_len = 0
      infinite (x in flat) { flat_len = flat_len + 1 }
      println("3. Tamanho da Lista Flattened (27): " + flat_len)
      println("   Primeiro elemento: " + flat[1])
      println("   Ultimo elemento: " + flat[27])

      #L 4. Squeeze e Unsqueeze
      mut as map: t_unsqueezed = tensorUnsqueeze(t9x3, 1)
      println("4. Unsqueeze [9, 3] no Eixo 1 -> Shape: " + t_unsqueezed["shape"])
      mut as map: t_squeezed = tensorSqueeze(t_unsqueezed)
      println("   Squeeze [1, 9, 3] -> Shape: " + t_squeezed["shape"])

      #L 5. Concatenacao de Dois Tensores 3x3x3 no Eixo 1 -> Shape [6, 3, 3]
      mut as map: ones3d = matrixOnes([3, 3, 3])
      mut as map: concat_tensor = tensorConcatenate(t3x3x3, ones3d, 1)
      println("5. Concat 3x3x3 + 3x3x3 no Eixo 1 -> Shape: " + concat_tensor["shape"])
      println("   Elemento do primeiro bloco [3, 3, 3] (27.0): " + tensorGetAt(concat_tensor, [3, 3, 3]))
      println("   Elemento do segundo bloco [6, 3, 3] (1.0): " + tensorGetAt(concat_tensor, [6, 3, 3]))
}
