use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorCoreContract) {
      println("==================================================")
      println("  Exemplo: TensorCoreContract (Estrutura e Strides)")
      println("==================================================")

      #L 1. Criacao de Tensores N-Dimensionais
      mut as map: t2d = tensorNew([2, 3])
      println("1. Shape do Tensor 2D: " + t2d["shape"])
      println("   Strides do Tensor 2D: " + t2d["strides"])
      println("   Ndim: " + t2d["ndim"])

      #L 2. Atribuicao e Leitura por Coordenadas N-D (1-indexed)
      t2d = tensorSetAt(t2d, [1, 1], 1.5)
      t2d = tensorSetAt(t2d, [1, 2], 2.5)
      t2d = tensorSetAt(t2d, [1, 3], 3.5)
      t2d = tensorSetAt(t2d, [2, 1], 4.5)
      t2d = tensorSetAt(t2d, [2, 2], 5.5)
      t2d = tensorSetAt(t2d, [2, 3], 6.5)

      println("2. Leitura [1, 2]: " + tensorGetAt(t2d, [1, 2]))
      println("   Leitura [2, 3]: " + tensorGetAt(t2d, [2, 3]))

      #L 3. Transposicao 2D em tempo O(1) via manipulação de Strides
      mut as map: t2d_t = tensorTranspose2D(t2d)
      println("3. Shape apos Transposicao: " + t2d_t["shape"])
      println("   Strides apos Transposicao: " + t2d_t["strides"])
      println("   Leitura [2, 1] no Transposto (deve ser 2.5): " + tensorGetAt(t2d_t, [2, 1]))
      println("   Leitura [3, 2] no Transposto (deve ser 6.5): " + tensorGetAt(t2d_t, [3, 2]))

      #L 4. Permutacao N-Dimensional em O(1)
      mut as map: t3d = tensorNew([2, 3, 4])
      t3d = tensorSetAt(t3d, [1, 2, 3], 99.0)
      println("4. Tensor 3D Shape Original: " + t3d["shape"])
      println("   Valor em [1, 2, 3]: " + tensorGetAt(t3d, [1, 2, 3]))

      #L Permuta eixos [1, 2, 3] -> [3, 1, 2]
      mut as map: t3d_perm = tensorPermute(t3d, [3, 1, 2])
      println("   Shape apos Permutacao [3, 1, 2]: " + t3d_perm["shape"])
      println("   Valor em [3, 1, 2] no Permutado: " + tensorGetAt(t3d_perm, [3, 1, 2]))
}
