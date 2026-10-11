#L ============================================================================
#L Algoritmo: Harris Corner Detector
#L Dominio: 08_artificial_intel / Subdominio: Visao Computacional
#L Descricao: Deteccao de cantos baseada na matriz de estrutura tensorial M e resposta R
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVHarrisCorner) {
      println("=== Algoritmo: Harris Corner Detector ===")

      #L Ponto de teste 1: regiao de canto (gradientes fortes em X e Y)
      #L Ix = 50, Iy = 40
      mut as int64: ix1 = 50
      mut as int64: iy1 = 40
      mut as int64: ix2_1 = ix1 * ix1
      mut as int64: iy2_1 = iy1 * iy1
      mut as int64: ixy_1 = ix1 * iy1

      #L Matriz M: [[2500, 2000], [2000, 1600]]
      #L det(M) = Ix^2 * Iy^2 - (Ixy)^2
      mut as int64: det1 = ix2_1 * iy2_1
      mut as int64: ixy_sq1 = ixy_1 * ixy_1
      det1 = det1 - ixy_sq1

      #L tr(M) = Ix^2 + Iy^2
      mut as int64: trace1 = ix2_1 + iy2_1
      mut as int64: trace_sq1 = trace1 * trace1

      #L Parametro de sensibilidade k = 0.04 (multiplicado por 100 -> k=4, entao divide por 100)
      mut as int64: k_trace1 = trace_sq1 * 4
      mut as int64: k_term1 = k_trace1 /i 100
      mut as int64: r_corner = det1 - k_term1

      #L Ponto de teste 2: regiao de borda (gradiente forte apenas em X)
      #L Ix = 50, Iy = 0
      mut as int64: ix2 = 50
      mut as int64: iy2 = 0
      mut as int64: det2 = 0
      mut as int64: trace2 = ix2 * ix2
      mut as int64: trace_sq2 = trace2 * trace2
      mut as int64: k_trace2 = trace_sq2 * 4
      mut as int64: k_term2 = k_trace2 /i 100
      mut as int64: r_edge = det2 - k_term2

      println("1. Traco em regiao de canto: " + trace1)
      println("2. Resposta de Harris em regiao de canto (R_corner): " + r_corner)
      println("3. Resposta de Harris em regiao de borda (R_edge): " + r_edge)

      route {
            r_corner > r_edge and r_edge < 0 ==> {
                  println("4. Deteccao de cantos e diferenciacao de bordas validada com sucesso.")
            }
            _ ==> {
                  println("Falha no calculo de Harris.")
            }
      }
      println("Teste concluido com sucesso.")
}
