#L ============================================================================
#L Algoritmo: Fenwick Tree 2D (Binary Indexed Tree 2D para Soma de Submatriz)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N * log M) consulta e atualizacao | Espaco O(N * M) compacto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasFenwickTree2D) {
      println("==================================================")
      println("  SciAlgo: Fenwick Tree 2D (Binary Indexed Tree)")
      println("==================================================")

      #L Grid 4x4 (N = 4, M = 4)
      mut as int64: n = 4
      mut as int64: m = 4

      #L Tabela BIT 2D linearizada de tamanho 16 (1-based: indices 1 a 16)
      mut as list of int64: bit = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]

      #L Insercoes pontuais em coordenadas (r, c) com delta v
      #L Grid inicial de valores:
      #L (1, 1): 5    (1, 2): 3
      #L (2, 2): 7    (3, 3): 10
      #L (4, 4): 2
      mut as list of int64: ins_r = [1, 1, 2, 3, 4]
      mut as list of int64: ins_c = [1, 2, 2, 3, 4]
      mut as list of int64: ins_v = [5, 3, 7, 10, 2]
      mut as int64: n_ins = listLength(ins_v)

      println("1. Inserindo " + n_ins + " pontos no Fenwick Tree 2D:")
      mut as int64: k = 1
      infinite (k <= n_ins) {
            mut as int64: r = ins_r[k]
            mut as int64: c = ins_c[k]
            mut as int64: delta = ins_v[k]

            #L Atualizacao 2D: r += r & (-r), c += c & (-c)
            mut as int64: ir = r
            infinite (ir <= n) {
                  mut as int64: ic = c
                  infinite (ic <= m) {
                        mut as int64: idx = (ir - 1) * m + ic
                        bit[idx] = bit[idx] + delta
                        #L ic += ic & (-ic)
                        mut as int64: low_c = ic & (0 - ic)
                        ic = ic + low_c
                  }
                  mut as int64: low_r = ir & (0 - ir)
                  ir = ir + low_r
            }
            println("   Ponto (" + r + ", " + c + ") += " + delta)
            k = k + 1
      }

      #L Consulta de soma de prefixo P(R, C) = soma de [1..R] x [1..C]
      #L Consulta P(2, 2): deve englobar (1, 1)=5, (1, 2)=3, (2, 2)=7 -> soma = 15
      println("2. Consultando prefix sum 2D P(2, 2):")
      mut as int64: p_2_2 = 0
      mut as int64: qr = 2
      infinite (qr > 0) {
            mut as int64: qc = 2
            infinite (qc > 0) {
                  mut as int64: idx = (qr - 1) * m + qc
                  p_2_2 = p_2_2 + bit[idx]
                  mut as int64: low_c = qc & (0 - qc)
                  qc = qc - low_c
            }
            mut as int64: low_r = qr & (0 - qr)
            qr = qr - low_r
      }
      println("   P(2, 2) = " + p_2_2)

      #L Consulta total P(4, 4): deve somar 5 + 3 + 7 + 10 + 2 = 27
      mut as int64: p_4_4 = 0
      qr = 4
      infinite (qr > 0) {
            mut as int64: qc = 4
            infinite (qc > 0) {
                  mut as int64: idx = (qr - 1) * m + qc
                  p_4_4 = p_4_4 + bit[idx]
                  mut as int64: low_c = qc & (0 - qc)
                  qc = qc - low_c
            }
            mut as int64: low_r = qr & (0 - qr)
            qr = qr - low_r
      }
      println("   P(4, 4) total = " + p_4_4)

      #L Consulta de regiao submatriz [2..4] x [2..4]:
      #L Soma = P(4, 4) - P(1, 4) - P(4, 1) + P(1, 1)
      #L Valores na regiao [2..4] x [2..4]: (2, 2)=7, (3, 3)=10, (4, 4)=2 -> soma = 19
      mut as int64: p_1_4 = 0
      qr = 1
      infinite (qr > 0) {
            mut as int64: qc = 4
            infinite (qc > 0) {
                  p_1_4 = p_1_4 + bit[(qr - 1) * m + qc]
                  qc = qc - (qc & (0 - qc))
            }
            qr = qr - (qr & (0 - qr))
      }

      mut as int64: p_4_1 = 0
      qr = 4
      infinite (qr > 0) {
            mut as int64: qc = 1
            infinite (qc > 0) {
                  p_4_1 = p_4_1 + bit[(qr - 1) * m + qc]
                  qc = qc - (qc & (0 - qc))
            }
            qr = qr - (qr & (0 - qr))
      }

      mut as int64: p_1_1 = 0
      qr = 1
      infinite (qr > 0) {
            mut as int64: qc = 1
            infinite (qc > 0) {
                  p_1_1 = p_1_1 + bit[(qr - 1) * m + qc]
                  qc = qc - (qc & (0 - qc))
            }
            qr = qr - (qr & (0 - qr))
      }

      mut as int64: submatrix_sum = p_4_4 - p_1_4 - p_4_1 + p_1_1
      println("3. Submatrix Sum [2..4] x [2..4] = " + submatrix_sum)
      println("4. Validacao: " + (p_2_2 == 15 and p_4_4 == 27 and submatrix_sum == 19))
      println("==================================================")
}
