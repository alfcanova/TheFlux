use LinAlgStdLib

program (ExampleOfUseLinAlgStdLib_MatrixEigenContract) {
      println("==================================================")
      println("  Exemplo: MatrixEigenContract (Autovalores e Simetria)")
      println("==================================================")

      #L 1. Matriz Simetrica 2x2
      #L A = [[2.0, 1.0], [1.0, 2.0]] -> Autovalores devem ser 3.0 e 1.0
      mut as map: sym_mat = tensorNew([2, 2])
      sym_mat = tensorSetAt(sym_mat, [1, 1], 2.0)
      sym_mat = tensorSetAt(sym_mat, [1, 2], 1.0)
      sym_mat = tensorSetAt(sym_mat, [2, 1], 1.0)
      sym_mat = tensorSetAt(sym_mat, [2, 2], 2.0)

      mut as bool: is_s = matrixIsSymmetric(sym_mat, 0.00001)
      println("1. A matriz e simetrica (true): " + is_s)

      #L 2. Autovalores Analiticos 2D: [[2.0, 1.0], [1.0, 2.0]] -> [3.0, 1.0]
      mut as list of data: eig_2d = matrixEigenvalues2D(sym_mat)
      println("2. Autovalores 2D Analiticos (deve ser [3.0, 1.0]): " + eig_2d)

      #L 3. Autovalores via Algoritmo QR Iterativo (100 iteracoes, tolerancia 1e-10)
      mut as list of data: eig_vals = matrixEigenvaluesQR(sym_mat, 100, 0.0000000001)
      mut as float64: ev1 = eig_vals[1] as float64
      mut as float64: ev2 = eig_vals[2] as float64
      mut as bool: ev_ok = (ev1 > 2.9999 and ev1 < 3.0001) and (ev2 > 0.9999 and ev2 < 1.0001)
      println("3. Autovalores encontrados via QR (~3.0 e ~1.0): " + ev_ok)

      #L 4. Autovetores e Autovalores Completos via QR (matrixEigenvectorsQR)
      mut as list of data: qr_res = matrixEigenvectorsQR(sym_mat, 100, 0.0000000001)
      mut as list of data: qr_lambdas = qr_res[1] as list of data
      mut as map: qr_v = qr_res[2] as map
      mut as float64: qlam1 = qr_lambdas[1] as float64
      mut as float64: qlam2 = qr_lambdas[2] as float64
      mut as bool: qlam_ok = (qlam1 > 2.9999 and qlam1 < 3.0001) and (qlam2 > 0.9999 and qlam2 < 1.0001)
      println("4. matrixEigenvectorsQR:")
      println("   Autovalores QR (~3.0 e ~1.0): " + qlam_ok)
      mut as list of data: qrv1 = [tensorGetAt(qr_v, [1, 1]), tensorGetAt(qr_v, [2, 1])]
      mut as list of data: qrv2 = [tensorGetAt(qr_v, [1, 2]), tensorGetAt(qr_v, [2, 2])]
      mut as float64: norm_v1 = vectorNormL2(qrv1)
      mut as float64: norm_v2 = vectorNormL2(qrv2)
      mut as bool: norm_ok = (norm_v1 > 0.9999 and norm_v1 < 1.0001) and (norm_v2 > 0.9999 and norm_v2 < 1.0001)
      println("   Normas unitarias dos autovetores (true): " + norm_ok)

      #L Verificacao A * v1 = lambda1 * v1
      mut as float64: lam1 = qr_lambdas[1] as float64
      mut as float64: av1_x = tensorGetAt(sym_mat, [1, 1]) * (qrv1[1] as float64) + tensorGetAt(sym_mat, [1, 2]) * (qrv1[2] as float64)
      mut as float64: lv1_x = lam1 * (qrv1[1] as float64)
      mut as float64: diff_av = av1_x - lv1_x
      route { diff_av < 0.0 ==> { diff_av = 0.0 - diff_av } }
      mut as bool: av_ok = diff_av < 0.000001
      println("   Verificacao A*v1 == lambda1*v1 (true): " + av_ok)

      #L Ortogonalidade v1 . v2 == 0
      mut as float64: qr_ortho = vectorDotProduct(qrv1, qrv2)
      route { qr_ortho < 0.0000000001 and qr_ortho > -0.0000000001 ==> { qr_ortho = 0.0 } }
      println("   Ortogonalidade v1 . v2 (0.0): " + qr_ortho)

      #L 5. Matriz Nao-Simetrica
      mut as map: non_sym = tensorNew([2, 2])
      non_sym = tensorSetAt(non_sym, [1, 1], 1.0)
      non_sym = tensorSetAt(non_sym, [1, 2], 5.0)
      non_sym = tensorSetAt(non_sym, [2, 1], 2.0)
      non_sym = tensorSetAt(non_sym, [2, 2], 3.0)
      mut as bool: is_non_s = matrixIsSymmetric(non_sym, 0.00001)
      println("5. Matriz nao-simetrica e simetrica (false): " + is_non_s)
}
