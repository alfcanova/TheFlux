use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_TensorArithmeticContract) {
      println("==================================================")
      println("  Exemplo: TensorArithmeticContract (Aritmetica IKJ)")
      println("==================================================")

      #L 1. Adicao Elemento a Elemento
      mut as map: a = tensorNew([2, 2])
      a = tensorSetAt(a, [1, 1], 1.0)
      a = tensorSetAt(a, [1, 2], 2.0)
      a = tensorSetAt(a, [2, 1], 3.0)
      a = tensorSetAt(a, [2, 2], 4.0)

      mut as map: b = tensorNew([2, 2])
      b = tensorSetAt(b, [1, 1], 10.0)
      b = tensorSetAt(b, [1, 2], 20.0)
      b = tensorSetAt(b, [2, 1], 30.0)
      b = tensorSetAt(b, [2, 2], 40.0)

      mut as map: soma = tensorAddElementwise(a, b)
      println("1. Adicao Elementwise [1, 1]: " + tensorGetAt(soma, [1, 1]))
      println("   Adicao Elementwise [1, 2]: " + tensorGetAt(soma, [1, 2]))
      println("   Adicao Elementwise [2, 1]: " + tensorGetAt(soma, [2, 1]))
      println("   Adicao Elementwise [2, 2]: " + tensorGetAt(soma, [2, 2]))

      #L 2. Multiplicacao por Escalar
      mut as map: scaled = tensorMulScalar(a, 2.5)
      println("2. Multiplicacao Escalar (2.5 * 2.0) [1, 2]: " + tensorGetAt(scaled, [1, 2]))
      println("   Multiplicacao Escalar (2.5 * 4.0) [2, 2]: " + tensorGetAt(scaled, [2, 2]))

      #L 3. Multiplicacao Matricial 2D (Algoritmo IKJ)
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

      mut as map: prod = tensorMatMul2D(m1, m2)
      println("3. MatMul2D [1, 1] (1*7 + 2*9 + 3*2 = 31): " + tensorGetAt(prod, [1, 1]))
      println("   MatMul2D [1, 2] (1*8 + 2*1 + 3*3 = 19): " + tensorGetAt(prod, [1, 2]))
      println("   MatMul2D [2, 1] (4*7 + 5*9 + 6*2 = 85): " + tensorGetAt(prod, [2, 1]))
      println("   MatMul2D [2, 2] (4*8 + 5*1 + 6*3 = 55): " + tensorGetAt(prod, [2, 2]))

      #L 4. Multiplicacao Matricial em Lote (Batched MatMul 3D)
      mut as map: b1 = tensorNew([1, 2, 2])
      b1 = tensorSetAt(b1, [1, 1, 1], 1.0)
      b1 = tensorSetAt(b1, [1, 1, 2], 2.0)
      b1 = tensorSetAt(b1, [1, 2, 1], 3.0)
      b1 = tensorSetAt(b1, [1, 2, 2], 4.0)

      mut as map: b2 = tensorNew([1, 2, 2])
      b2 = tensorSetAt(b2, [1, 1, 1], 5.0)
      b2 = tensorSetAt(b2, [1, 1, 2], 6.0)
      b2 = tensorSetAt(b2, [1, 2, 1], 7.0)
      b2 = tensorSetAt(b2, [1, 2, 2], 8.0)

      mut as map: bprod = tensorBatchedMatMul(b1, b2)
      println("4. Batched MatMul Batch 1 [1, 1] (1*5 + 2*7 = 19): " + tensorGetAt(bprod, [1, 1, 1]))
      println("   Batched MatMul Batch 1 [1, 2] (1*6 + 2*8 = 22): " + tensorGetAt(bprod, [1, 1, 2]))
      println("   Batched MatMul Batch 1 [2, 1] (3*5 + 4*7 = 43): " + tensorGetAt(bprod, [1, 2, 1]))
      println("   Batched MatMul Batch 1 [2, 2] (3*6 + 4*8 = 50): " + tensorGetAt(bprod, [1, 2, 2]))
}
