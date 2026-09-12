use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorStridesContract) {
      println("==================================================")
      println("  Exemplo: TensorStridesContract (Strides Avancados)")
      println("==================================================")

      #L 1. Construtor com Strides Customizados (Layout Fortran / Column-Major)
      mut as list of data: f_buf = [10.0, 20.0, 30.0, 40.0]
      #L Matriz 2x2 Fortran: Coluna 1 = [10.0, 20.0], Coluna 2 = [30.0, 40.0] -> Strides [1, 2]
      mut as map: mat_fortran = tensorNewWithStrides([2, 2], [1, 2], 1, f_buf)
      println("1. Matriz Fortran Shape: " + mat_fortran["shape"])
      println("   Matriz Fortran Strides: " + mat_fortran["strides"])
      println("   Elemento [1, 1] (10.0): " + tensorGetAt(mat_fortran, [1, 1]))
      println("   Elemento [2, 1] (20.0): " + tensorGetAt(mat_fortran, [2, 1]))
      println("   Elemento [1, 2] (30.0): " + tensorGetAt(mat_fortran, [1, 2]))
      println("   Elemento [2, 2] (40.0): " + tensorGetAt(mat_fortran, [2, 2]))

      #L 2. Janela Deslizante com as_strided em O(1) Zero-Copy (Im2Col / Patches)
      #L Buffer 1D: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
      mut as map: signal_1d = tensorNew([6])
      mut as int64: s_i = 1
      infinite (s_i <= 6) {
            signal_1d = tensorSetAt(signal_1d, [s_i], s_i as float64)
            s_i = s_i + 1
      }
      #L Visao de Janela Deslizante 4x3 (4 janelas de tamanho 3 com passo 1): strides [1, 1]
      mut as map: windows = tensorAsStrided(signal_1d, [4, 3], [1, 1], 1)
      println("2. Janela 1 [1, 1..3]: [" + tensorGetAt(windows, [1, 1]) + ", " + tensorGetAt(windows, [1, 2]) + ", " + tensorGetAt(windows, [1, 3]) + "]")
      println("   Janela 2 [2, 1..3]: [" + tensorGetAt(windows, [2, 1]) + ", " + tensorGetAt(windows, [2, 2]) + ", " + tensorGetAt(windows, [2, 3]) + "]")
      println("   Janela 4 [4, 1..3]: [" + tensorGetAt(windows, [4, 1]) + ", " + tensorGetAt(windows, [4, 2]) + ", " + tensorGetAt(windows, [4, 3]) + "]")

      #L 3. Slicing e Sub-Visao Zero-Copy O(1)
      #L Matriz 3x3: Linhas 1..3, Colunas 1..3
      mut as map: m3x3 = tensorNew([3, 3])
      mut as int64: r = 1
      infinite (r <= 3) {
            mut as int64: c = 1
            infinite (c <= 3) {
                  m3x3 = tensorSetAt(m3x3, [r, c], ((r - 1) * 3 + c) as float64)
                  c = c + 1
            }
            r = r + 1
      }
      #L Extrai sub-visao 2x2 do canto inferior direito (linhas 2..3, colunas 2..3, passo 1)
      mut as map: sub_view = tensorSliceView(m3x3, [2, 2], [3, 3], [1, 1])
      println("3. Sub-Visao Shape: " + sub_view["shape"])
      println("   Sub-Visao [1, 1] (elem [2, 2]=5.0): " + tensorGetAt(sub_view, [1, 1]))
      println("   Sub-Visao [2, 2] (elem [3, 3]=9.0): " + tensorGetAt(sub_view, [2, 2]))

      #L 4. Broadcasting com Stride Zero em O(1)
      mut as map: row_vec = tensorNew([1, 3])
      row_vec = tensorSetAt(row_vec, [1, 1], 100.0)
      row_vec = tensorSetAt(row_vec, [1, 2], 200.0)
      row_vec = tensorSetAt(row_vec, [1, 3], 300.0)

      #L Broadcast para [3, 3] com stride 0 na primeira dimensao
      mut as map: bcast = tensorBroadcastTo(row_vec, [3, 3])
      println("4. Broadcast Shape: " + bcast["shape"])
      println("   Broadcast Strides: " + bcast["strides"])
      println("   Linha 1 [1, 2]: " + tensorGetAt(bcast, [1, 2]))
      println("   Linha 3 [3, 2] (mesmo dado sem copiar memoria): " + tensorGetAt(bcast, [3, 2]))

      #L 5. Verificacao de Contiguidade e Consolidacao
      mut as map: orig = tensorNew([2, 3])
      println("5. Original e contiguo (true): " + tensorIsContiguous(orig))
      mut as map: transp = tensorTranspose2D(orig)
      println("   Transposto e contiguo (false): " + tensorIsContiguous(transp))
      mut as map: dense_transp = tensorContiguous(transp)
      println("   Apos consolidar com tensorContiguous (true): " + tensorIsContiguous(dense_transp))
}
