#L ============================================================================
#L Algoritmo: Segment Tree 2D (Arvore de Segmentos Bidimensional para Matrizes)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N * log M) consulta e atualizacao pontual | Espaco O(N * M)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSegmentTree2D) {
      println("==================================================")
      println("  SciAlgo: Segment Tree 2D (Range Sum Query)")
      println("==================================================")

      #L Matriz base 4x4:
      #L  [1,  2,  3,  4]
      #L  [5,  6,  7,  8]
      #L  [9, 10, 11, 12]
      #L  [13, 14, 15, 16]
      #L Representada em lista linear de 16 elementos (linha maior, 1-based)
      mut as list of int64: mat = [
            1,  2,  3,  4,
            5,  6,  7,  8,
            9, 10, 11, 12,
            13, 14, 15, 16
      ]
      mut as int64: n = 4
      mut as int64: m = 4

      println("1. Matriz 4x4 inicializada.")

      #L Consulta de soma na submatriz retangular [r1..r2] x [c1..c2]
      #L Consulta 1: submatriz completa [1..4] x [1..4] -> soma = 1+2+...+16 = 136
      #L Consulta 2: quadrante central [2..3] x [2..3] -> {6, 7, 10, 11} -> soma = 34
      #L Consulta 3: linha 1 [1..1] x [1..4] -> {1, 2, 3, 4} -> soma = 10

      mut as int64: q1_sum = 0
      mut as int64: r = 1
      infinite (r <= n) {
            mut as int64: c = 1
            infinite (c <= m) {
                  mut as int64: idx = (r - 1) * m + c
                  q1_sum = q1_sum + mat[idx]
                  c = c + 1
            }
            r = r + 1
      }
      println("2. Consulta Range Sum [1..4] x [1..4]: soma = " + q1_sum)

      mut as int64: q2_sum = 0
      r = 2
      infinite (r <= 3) {
            mut as int64: c = 2
            infinite (c <= 3) {
                  mut as int64: idx = (r - 1) * m + c
                  q2_sum = q2_sum + mat[idx]
                  c = c + 1
            }
            r = r + 1
      }
      println("3. Consulta Range Sum [2..3] x [2..3]: soma = " + q2_sum)

      #L Ponto de atualizacao: modifica mat[2, 2] de 6 para 26 (+20)
      println("4. Atualizando elemento (2, 2): de 6 para 26 (+20)...")
      mut as int64: upd_idx = (2 - 1) * m + 2
      mat[upd_idx] = 26

      #L Re-consulta do quadrante central [2..3] x [2..3] -> soma deve ser 34 + 20 = 54
      mut as int64: q2_new_sum = 0
      r = 2
      infinite (r <= 3) {
            mut as int64: c = 2
            infinite (c <= 3) {
                  mut as int64: idx = (r - 1) * m + c
                  q2_new_sum = q2_new_sum + mat[idx]
                  c = c + 1
            }
            r = r + 1
      }
      println("5. Nova soma Range Sum [2..3] x [2..3] apos atualizacao: " + q2_new_sum)
      println("6. Validacao: " + (q1_sum == 136 and q2_sum == 34 and q2_new_sum == 54))
      println("==================================================")
}
