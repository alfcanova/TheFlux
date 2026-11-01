use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixEigenvectors) {
      println("==================================================")
      println("  Exemplo: Autovetores Completos (LinAlgStdLib)   ")
      println("==================================================")

      #L --------------------------------------------------
      #L 1. Autovetores Analiticos 2D (matrixEigenvectors2D)
      #L --------------------------------------------------
      #L Matriz A = [[2.0, 1.0], [1.0, 2.0]]
      #L Autovalores teoricos: lambda1 = 3.0, lambda2 = 1.0
      #L Autovetores teoricos normalizados:
      #L   v1 = [1/sqrt(2), 1/sqrt(2)] ~= [0.70710678, 0.70710678]
      #L   v2 = [-1/sqrt(2), 1/sqrt(2)] ~= [-0.70710678, 0.70710678]
      mut as map: a2d = tensorNew([2, 2])
      a2d = tensorSetAt(a2d, [1, 1], 2.0)
      a2d = tensorSetAt(a2d, [1, 2], 1.0)
      a2d = tensorSetAt(a2d, [2, 1], 1.0)
      a2d = tensorSetAt(a2d, [2, 2], 2.0)

      mut as list of data: eig2d = matrixEigenvectors2D(a2d)
      mut as list of data: l2d = eig2d[1] as list of data
      mut as map: v2d = eig2d[2] as map

      mut as float64: l1_val = l2d[1] as float64
      mut as float64: l2_val = l2d[2] as float64
      mut as bool: l2d_ok = (l1_val > 2.9999 and l1_val < 3.0001) and (l2_val > 0.9999 and l2_val < 1.0001)
      println("1. Autovetores 2D:")
      println("   Autovalores 2D calculados (~3.0 e ~1.0): " + l2d_ok)
      mut as list of data: vec1 = [tensorGetAt(v2d, [1, 1]), tensorGetAt(v2d, [2, 1])]
      mut as list of data: vec2 = [tensorGetAt(v2d, [1, 2]), tensorGetAt(v2d, [2, 2])]
      mut as float64: norm_v1 = vectorNormL2(vec1)
      mut as float64: norm_v2 = vectorNormL2(vec2)
      mut as bool: norm_v12_ok = (norm_v1 > 0.9999 and norm_v1 < 1.0001) and (norm_v2 > 0.9999 and norm_v2 < 1.0001)
      println("   Normas unitarias dos autovetores 2D: " + norm_v12_ok)

      #L Verificacao de Ortogonalidade: v1 . v2 == 0.0
      mut as float64: dot_prod = vectorDotProduct(vec1, vec2)
      route { dot_prod < 0.0000000001 and dot_prod > -0.0000000001 ==> { dot_prod = 0.0 } }
      println("   Ortogonalidade v1 . v2 (0.0): " + dot_prod)

      #L --------------------------------------------------
      #L 2. Eigendecomposition Completa NxN (matrixEig)
      #L --------------------------------------------------
      #L Matriz Simetrica 3x3:
      #L [[3.0, 1.0, 0.0],
      #L  [1.0, 3.0, 1.0],
      #L  [0.0, 1.0, 3.0]]
      #L Autovalores teoricos: 3 + sqrt(2) ~= 4.41421356, 3.0, 3 - sqrt(2) ~= 1.58578644
      mut as map: a3x3 = tensorNew([3, 3])
      a3x3 = tensorSetAt(a3x3, [1, 1], 3.0)
      a3x3 = tensorSetAt(a3x3, [1, 2], 1.0)
      a3x3 = tensorSetAt(a3x3, [1, 3], 0.0)
      a3x3 = tensorSetAt(a3x3, [2, 1], 1.0)
      a3x3 = tensorSetAt(a3x3, [2, 2], 3.0)
      a3x3 = tensorSetAt(a3x3, [2, 3], 1.0)
      a3x3 = tensorSetAt(a3x3, [3, 1], 0.0)
      a3x3 = tensorSetAt(a3x3, [3, 2], 1.0)
      a3x3 = tensorSetAt(a3x3, [3, 3], 3.0)

      mut as list of data: eig3x3 = matrixEig(a3x3, 100, 0.0000000001)
      mut as list of data: lambdas3 = eig3x3[1] as list of data
      mut as map: v_mat = eig3x3[2] as map

      mut as float64: lam3_1 = lambdas3[1] as float64
      mut as float64: lam3_2 = lambdas3[2] as float64
      mut as float64: lam3_3 = lambdas3[3] as float64
      mut as bool: lam3_ok = (lam3_1 > 4.414 and lam3_1 < 4.415) and (lam3_2 > 2.999 and lam3_2 < 3.001) and (lam3_3 > 1.585 and lam3_3 < 1.586)
      println("2. Eigendecomposition 3x3 (matrixEig):")
      println("   Autovalores 3x3 aproximados (~4.414, ~3.0, ~1.586): " + lam3_ok)
      println("   Matriz de Autovetores V Shape: " + v_mat["shape"])

      #L Verificacao: A * v_col == lambda * v_col para a coluna 2 (lambda = 3.0)
      #L Coluna 2 de V:
      mut as list of data: u2 = [tensorGetAt(v_mat, [1, 2]), tensorGetAt(v_mat, [2, 2]), tensorGetAt(v_mat, [3, 2])]
      #L Multiplica A * u2:
      mut as float64: au2_1 = 3.0 * (u2[1] as float64) + 1.0 * (u2[2] as float64) + 0.0 * (u2[3] as float64)
      mut as float64: au2_2 = 1.0 * (u2[1] as float64) + 3.0 * (u2[2] as float64) + 1.0 * (u2[3] as float64)
      mut as float64: au2_3 = 0.0 * (u2[1] as float64) + 1.0 * (u2[2] as float64) + 3.0 * (u2[3] as float64)

      #L Razao (A * u2) / u2 deve ser aproximadamente igual a lambda2
      mut as float64: l2_calc = au2_1 /f (u2[1] as float64)
      mut as bool: l2_ok = (l2_calc > 2.999 and l2_calc < 3.001)
      println("   Verificacao A*v = lambda*v (deve ser ~3.0): " + l2_ok)

      #L --------------------------------------------------
      #L 3. Iteracao Inversa de Wielandt (matrixEigenvectorInverseIteration)
      #L --------------------------------------------------
      #L Encontra o autovetor especifico para o autovalor 3.0
      mut as list of data: v_inv = matrixEigenvectorInverseIteration(a3x3, 3.0, 5)
      mut as float64: norm_v = vectorNormL2(v_inv)
      mut as bool: norm_v_ok = (norm_v > 0.9999 and norm_v < 1.0001)
      println("3. Iteracao Inversa para lambda=3.0 norma unitaria (~1.0): " + norm_v_ok)
      mut as float64: ainv1 = 3.0 * (v_inv[1] as float64) + 1.0 * (v_inv[2] as float64) + 0.0 * (v_inv[3] as float64)
      mut as float64: r_inv = ainv1 /f (v_inv[1] as float64)
      mut as bool: r_inv_ok = (r_inv > 2.999 and r_inv < 3.001)
      println("   Autovetor inverso satisfaz A*v = 3*v: " + r_inv_ok)

      println("==================================================")
      println("  Autovetores concluidos e verificados com exito! ")
      println("==================================================")
}
