use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_VectorGeometryContract) {
      println("==================================================")
      println("  Exemplo: VectorGeometryContract (Geometria 3D)")
      println("==================================================")

      #L 1. Produto Escalar (Dot Product)
      mut as list of data: u = [1.0, 2.0, 3.0]
      mut as list of data: v = [4.0, 5.0, 6.0]
      mut as float64: dot = vectorDotProduct(u, v)
      println("1. Produto Escalar (1*4 + 2*5 + 3*6 = 32.0): " + dot)

      #L 2. Produto Vetorial 3D (Cross Product: i x j = k)
      mut as list of data: i_hat = [1.0, 0.0, 0.0]
      mut as list of data: j_hat = [0.0, 1.0, 0.0]
      mut as list of data: k_hat = vectorCrossProduct3D(i_hat, j_hat)
      println("2. Produto Vetorial i x j (deve ser [0.0, 0.0, 1.0]): " + k_hat)

      #L 3. Produto Externo (Outer Product)
      mut as list of data: v1 = [1.0, 2.0]
      mut as list of data: v2 = [3.0, 4.0, 5.0]
      mut as map: outer = vectorOuterProduct(v1, v2)
      println("3. Produto Externo Shape: " + outer["shape"])
      println("   Elemento [1, 1] (1*3=3): " + tensorGetAt(outer, [1, 1]))
      println("   Elemento [2, 3] (2*5=10): " + tensorGetAt(outer, [2, 3]))

      #L 4. Normas Vetoriais (L1, L2, LInf) no vetor [3.0, -4.0]
      mut as list of data: vec2d = [3.0, -4.0]
      println("4. Norma L1 (Manhattan |3|+|-4|=7): " + vectorNormL1(vec2d))
      println("   Norma L2 (Euclidiana sqrt(3^2 + 4^2)=5): " + vectorNormL2(vec2d))
      println("   Norma LInf (Chebyshev max(3, 4)=4): " + vectorNormLInf(vec2d))

      #L 5. Normalizacao para Vetor Unitario
      mut as list of data: vec3d = [0.0, 3.0, 4.0]
      mut as list of data: unit = vectorNormalize(vec3d)
      println("5. Vetor Normalizado (deve ser [0.0, 0.6, 0.8]): " + unit)
      println("   Norma do Normalizado: " + vectorNormL2(unit))

      #L 6. Projecao Vetorial de u sobre v
      mut as list of data: a = [3.0, 4.0]
      mut as list of data: b = [1.0, 0.0]
      mut as list of data: proj = vectorProjection(a, b)
      println("6. Projecao de [3, 4] sobre o eixo X [1, 0]: " + proj)
}
