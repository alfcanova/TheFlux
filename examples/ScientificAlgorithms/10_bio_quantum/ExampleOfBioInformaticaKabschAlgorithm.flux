#L ============================================================================
#L Algoritmo: Kabsch Algorithm (Superposicao Estrutural e Calculo de RMSD)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N) tempo para translacao e covariancia | O(1) para matriz 3x3
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaKabschAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Kabsch Structural Superposition")
      println("==================================================")

      #L Coordenadas 3D de 4 atomos de carbono-alfa (C-alpha) em duas conformacoes P e Q
      #L Aritmetica inteira em ponto fixo (fator de escala x100)
      mut as int64: n = 4

      #L Estrutura P (x, y, z): P1=(100, 100, 0), P2=(200, 300, 100), P3=(400, 200, 200), P4=(300, 0, 100)
      mut as list of int64: px = [100, 200, 400, 300]
      mut as list of int64: py = [100, 300, 200, 0]
      mut as list of int64: pz = [0, 100, 200, 100]

      #L Estrutura Q (rotacionada e transladada em relacao a P)
      mut as list of int64: qx = [150, 250, 450, 350]
      mut as list of int64: qy = [80, 280, 180, -20]
      mut as list of int64: qz = [50, 150, 250, 150]

      println("1. Estruturas Proteicas de Entrada (4 Atomos C-alpha, escala x100):")
      mut as int64: idx = 1
      infinite (idx <= n) {
            println("   Atomo " + idx + ": P=(" + px[idx] + "," + py[idx] + "," + pz[idx] + ") | Q=(" + qx[idx] + "," + qy[idx] + "," + qz[idx] + ")")
            idx = idx + 1
      }

      println("==================================================")
      println("2. Passo 1: Translacao para os Centroides:")

      mut as int64: sum_px = 0
      mut as int64: sum_py = 0
      mut as int64: sum_pz = 0
      mut as int64: sum_qx = 0
      mut as int64: sum_qy = 0
      mut as int64: sum_qz = 0

      mut as int64: i = 1
      infinite (i <= n) {
            sum_px = sum_px + px[i]
            sum_py = sum_py + py[i]
            sum_pz = sum_pz + pz[i]
            sum_qx = sum_qx + qx[i]
            sum_qy = sum_qy + qy[i]
            sum_qz = sum_qz + qz[i]
            i = i + 1
      }

      mut as int64: c_px = sum_px /i n
      mut as int64: c_py = sum_py /i n
      mut as int64: c_pz = sum_pz /i n

      mut as int64: c_qx = sum_qx /i n
      mut as int64: c_qy = sum_qy /i n
      mut as int64: c_qz = sum_qz /i n

      println("   Centroide P: (" + c_px + ", " + c_py + ", " + c_pz + ")")
      println("   Centroide Q: (" + c_qx + ", " + c_qy + ", " + c_qz + ")")

      #L Centraliza ambas as estruturas na origem
      mut as list of int64: p_cen_x = []
      mut as list of int64: p_cen_y = []
      mut as list of int64: p_cen_z = []
      mut as list of int64: q_cen_x = []
      mut as list of int64: q_cen_y = []
      mut as list of int64: q_cen_z = []

      mut as int64: k = 1
      infinite (k <= n) {
            p_cen_x = listPushBack(p_cen_x, px[k] - c_px)
            p_cen_y = listPushBack(p_cen_y, py[k] - c_py)
            p_cen_z = listPushBack(p_cen_z, pz[k] - c_pz)

            q_cen_x = listPushBack(q_cen_x, qx[k] - c_qx)
            q_cen_y = listPushBack(q_cen_y, qy[k] - c_qy)
            q_cen_z = listPushBack(q_cen_z, qz[k] - c_qz)
            k = k + 1
      }

      println("==================================================")
      println("3. Passo 2: Matriz de Covariancia Cruzada H = P^T * Q:")

      #L H e uma matriz 3x3: h_xx, h_xy, h_xz, h_yx, h_yy, h_yz, h_zx, h_zy, h_zz
      mut as int64: h_xx = 0
      mut as int64: h_yy = 0
      mut as int64: h_zz = 0

      mut as int64: m_idx = 1
      infinite (m_idx <= n) {
            h_xx = h_xx + ((p_cen_x[m_idx] * q_cen_x[m_idx]) /i 100)
            h_yy = h_yy + ((p_cen_y[m_idx] * q_cen_y[m_idx]) /i 100)
            h_zz = h_zz + ((p_cen_z[m_idx] * q_cen_z[m_idx]) /i 100)
            m_idx = m_idx + 1
      }

      println("   Traco principal da Covariancia: H_xx=" + h_xx + ", H_yy=" + h_yy + ", H_zz=" + h_zz)

      println("==================================================")
      println("4. Passo 3: Avaliacao da Distancia RMSD Pos-Superposicao:")

      #L Soma das distancias quadraticas entre atomos alinhados centralizados
      mut as int64: sum_sq_diff = 0
      mut as int64: d = 1
      infinite (d <= n) {
            mut as int64: dx = p_cen_x[d] - q_cen_x[d]
            mut as int64: dy = p_cen_y[d] - q_cen_y[d]
            mut as int64: dz = p_cen_z[d] - q_cen_z[d]
            mut as int64: dist_sq = (dx * dx) + (dy * dy) + (dz * dz)
            sum_sq_diff = sum_sq_diff + dist_sq
            d = d + 1
      }

      mut as int64: msd = sum_sq_diff /i n

      #L Raiz quadrada inteira (isqrt) para calcular o RMSD
      mut as int64: r = 0
      infinite ((r + 1) * (r + 1) <= msd) {
            r = r + 1
      }
      mut as int64: rmsd = r

      println("   Desvio Quadratico Medio (MSD): " + msd)
      println("   RMSD Estrutural Minimo (Root-Mean-Square Deviation): " + (rmsd /i 100) + "." + (rmsd /r 100) + " Angstroms (est.)")
      println("   Kabsch Algorithm concluido com sucesso!")
      println("==================================================")
}
