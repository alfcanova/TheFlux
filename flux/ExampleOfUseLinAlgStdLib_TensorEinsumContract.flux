use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorEinsumContract) {
      println("==================================================")
      println("  Exemplo: TensorEinsumContract (Notacao Einstein)")
      println("==================================================")

      mut as map: m1 = tensorNew([2, 3])
      m1 = tensorSetAt(m1, [1, 1], 1.0)
      m1 = tensorSetAt(m1, [1, 2], 2.0)
      m1 = tensorSetAt(m1, [1, 3], 3.0)
      m1 = tensorSetAt(m1, [2, 1], 4.0)
      m1 = tensorSetAt(m1, [2, 2], 5.0)
      m1 = tensorSetAt(m1, [2, 3], 6.0)

      mut as map: m2 = tensorNew([3, 2])
      m2 = tensorSetAt(m2, [1, 1], 7.0)
      m2 = tensorSetAt(m2, [1, 2], 8.0)
      m2 = tensorSetAt(m2, [2, 1], 9.0)
      m2 = tensorSetAt(m2, [2, 2], 1.0)
      m2 = tensorSetAt(m2, [3, 1], 2.0)
      m2 = tensorSetAt(m2, [3, 2], 3.0)

      #L 1. Contracao Canonica: ij,jk->ik (Multiplicacao Matricial)
      mut as map: res1 = tensorEinsum("ij,jk->ik", [m1, m2])
      println("1. Einsum ij,jk->ik [1, 1] (31): " + tensorGetAt(res1, [1, 1]))
      println("   Einsum ij,jk->ik [1, 2] (19): " + tensorGetAt(res1, [1, 2]))
      println("   Einsum ij,jk->ik [2, 1] (85): " + tensorGetAt(res1, [2, 1]))
      println("   Einsum ij,jk->ik [2, 2] (55): " + tensorGetAt(res1, [2, 2]))

      #L 2. Contracao com Transposicao Geometrica Virtual: ji,jk->ik
      mut as map: m1_t = tensorTranspose2D(m1)
      mut as map: res2 = tensorEinsum("ji,jk->ik", [m1_t, m2])
      println("2. Einsum ji,jk->ik [1, 1] (31): " + tensorGetAt(res2, [1, 1]))
      println("   Einsum ji,jk->ik [1, 2] (19): " + tensorGetAt(res2, [1, 2]))
      println("   Einsum ji,jk->ik [2, 1] (85): " + tensorGetAt(res2, [2, 1]))
      println("   Einsum ji,jk->ik [2, 2] (55): " + tensorGetAt(res2, [2, 2]))
}
