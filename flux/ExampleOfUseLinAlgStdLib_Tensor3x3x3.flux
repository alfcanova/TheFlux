use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_Tensor3x3x3) {
      println("==================================================")
      println("  Exemplo Completo: Tensores 3x3x3 (LinAlgStdLib)")
      println("==================================================")

      #L --------------------------------------------------
      #L 1. Criacao e Indexacao Tridimensional (3x3x3)
      #L --------------------------------------------------
      mut as map: cube_a = tensorNew([3, 3, 3])
      mut as int64: i = 1
      infinite (i <= 3) {
            mut as int64: j = 1
            infinite (j <= 3) {
                  mut as int64: k = 1
                  infinite (k <= 3) {
                        #L Codifica as coordenadas como centenas, dezenas e unidades
                        mut as float64: val = (i * 100 + j * 10 + k) as float64
                        cube_a = tensorSetAt(cube_a, [i, j, k], val)
                        k = k + 1
                  }
                  j = j + 1
            }
            i = i + 1
      }
      println("1. Tensor Cubico 3x3x3 Criado:")
      println("   Shape: " + cube_a["shape"])
      println("   Ndim: " + cube_a["ndim"])
      println("   Elemento [1, 2, 3] (123.0): " + tensorGetAt(cube_a, [1, 2, 3]))
      println("   Elemento [2, 1, 3] (213.0): " + tensorGetAt(cube_a, [2, 1, 3]))
      println("   Elemento [3, 3, 3] (333.0): " + tensorGetAt(cube_a, [3, 3, 3]))

      #L --------------------------------------------------
      #L 2. Operacoes Elemento a Elemento em Tensores 3x3x3
      #L --------------------------------------------------
      mut as map: cube_ones = matrixOnes([3, 3, 3])
      mut as map: cube_scaled = tensorMulScalar(cube_ones, 10.0)

      #L Adicao 3D
      mut as map: cube_sum = tensorAddElementwise(cube_a, cube_scaled)
      println("2. Adicao 3D (cube_a + 10.0) em [1, 2, 3] (133.0): " + tensorGetAt(cube_sum, [1, 2, 3]))

      #L Subtracao 3D
      mut as map: cube_sub = tensorSubElementwise(cube_sum, cube_scaled)
      println("   Subtracao 3D (cube_sum - 10.0) em [1, 2, 3] (123.0): " + tensorGetAt(cube_sub, [1, 2, 3]))

      #L Multiplicacao Hadamard 3D
      mut as map: cube_hadamard = tensorMulElementwise(cube_ones, cube_scaled)
      println("   Hadamard 3D (1.0 * 10.0) em [2, 2, 2] (10.0): " + tensorGetAt(cube_hadamard, [2, 2, 2]))

      #L --------------------------------------------------
      #L 3. Fatias 2D (Slices) de um Cubo 3x3x3
      #L --------------------------------------------------
      #L Fatia Frontal: fixando i = 1 -> Matriz 3x3 com valores 111 a 133
      mut as map: frontal_slice = tensorExtractSlice(cube_a, 1, 1)
      println("3. Fatia Frontal (i=1) Shape: " + frontal_slice["shape"])
      println("   Frontal [1, 1] (elem [1, 1, 1]=111.0): " + tensorGetAt(frontal_slice, [1, 1]))
      println("   Frontal [2, 3] (elem [1, 2, 3]=123.0): " + tensorGetAt(frontal_slice, [2, 3]))
      println("   Frontal [3, 3] (elem [1, 3, 3]=133.0): " + tensorGetAt(frontal_slice, [3, 3]))

      #L Fatia Horizontal: fixando j = 2 -> Matriz 3x3 com valores onde coluna j=2
      mut as map: horiz_slice = tensorExtractSlice(cube_a, 2, 2)
      println("   Fatia Horizontal (j=2) [1, 3] (elem [1, 2, 3]=123.0): " + tensorGetAt(horiz_slice, [1, 3]))

      #L --------------------------------------------------
      #L 4. Diagonal Espacial 3D e Traco Espacial
      #L --------------------------------------------------
      mut as list of data: diag_space = tensorDiagonal3D(cube_a)
      println("4. Diagonal Espacial 3D [111.0, 222.0, 333.0]: " + diag_space)
      mut as float64: trace_space = tensorTrace3D(cube_a)
      println("   Traco Espacial 3D (111 + 222 + 333 = 666.0): " + trace_space)

      #L --------------------------------------------------
      #L 5. Reducoes Globais e por Eixos no Cubo 3x3x3
      #L --------------------------------------------------
      mut as map: cube_natural = tensorNew([3, 3, 3])
      mut as int64: counter = 1
      i = 1
      infinite (i <= 3) {
            mut as int64: j = 1
            infinite (j <= 3) {
                  mut as int64: k = 1
                  infinite (k <= 3) {
                        cube_natural = tensorSetAt(cube_natural, [i, j, k], counter as float64)
                        counter = counter + 1
                        k = k + 1
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("5. Reducoes no Cubo com valores 1..27:")
      println("   Soma Total (378.0): " + tensorSumAll(cube_natural))
      println("   Media Total (14.0): " + tensorMeanAll(cube_natural))
      println("   Minimo Global (1.0): " + tensorMinAll(cube_natural))
      println("   Maximo Global (27.0): " + tensorMaxAll(cube_natural))

      #L Reducao por Eixo 1 (Soma ao longo do eixo 1 -> shape [1, 3, 3])
      #L Em [1, 1, 1]: 1 + 10 + 19 = 30.0
      mut as map: sum_ax1 = tensorSumAxis(cube_natural, 1)
      println("   Soma Eixo 1 Shape: " + sum_ax1["shape"])
      println("   Soma Eixo 1 em [1, 1, 1] (1+10+19=30.0): " + tensorGetAt(sum_ax1, [1, 1, 1]))

      #L --------------------------------------------------
      #L 6. Multiplicacao Matricial em Lote (Batched MatMul 3D)
      #L --------------------------------------------------
      #L Multiplica 3 pares de matrizes 3x3 em paralelo
      #L Lote de 3 matrizes identidade [3, 3, 3]
      mut as map: batch_identities = tensorNew([3, 3, 3])
      mut as int64: b = 1
      infinite (b <= 3) {
            mut as int64: r = 1
            infinite (r <= 3) {
                  batch_identities = tensorSetAt(batch_identities, [b, r, r], 1.0)
                  r = r + 1
            }
            b = b + 1
      }

      mut as map: batch_res = tensorBatchedMatMul(batch_identities, cube_natural)
      println("6. Batched MatMul (Identidades 3D x Cubo Natural):")
      println("   Shape do Resultado: " + batch_res["shape"])
      println("   Batch 1 [1, 1] (1.0): " + tensorGetAt(batch_res, [1, 1, 1]))
      println("   Batch 2 [2, 2] (14.0): " + tensorGetAt(batch_res, [2, 2, 2]))
      println("   Batch 3 [3, 3] (27.0): " + tensorGetAt(batch_res, [3, 3, 3]))

      #L --------------------------------------------------
      #L 7. Permutacao e Troca de Eixos (Transposicao 3D)
      #L --------------------------------------------------
      mut as map: swapped = tensorSwapAxes(cube_a, 1, 3)
      println("7. Permutacao de Eixos 1 <-> 3:")
      println("   Valor original em [1, 2, 3]: " + tensorGetAt(cube_a, [1, 2, 3]))
      println("   Valor no permutado em [3, 2, 1]: " + tensorGetAt(swapped, [3, 2, 1]))

      #L --------------------------------------------------
      #L 8. Concatenacao Tridimensional
      #L --------------------------------------------------
      mut as map: concat_ax1 = tensorConcatenate(cube_natural, cube_natural, 1)
      println("8. Concatenacao no Eixo 1 -> Shape (deve ser [6, 3, 3]): " + concat_ax1["shape"])
      mut as map: concat_ax3 = tensorConcatenate(cube_natural, cube_natural, 3)
      println("   Concatenacao no Eixo 3 -> Shape (deve ser [3, 3, 6]): " + concat_ax3["shape"])

      println("==================================================")
      println("  Todos os testes com tensores 3x3x3 concluidos!  ")
      println("==================================================")
}
