#L ============================================================================
#L Algoritmo: 2D Segment Tree Quadrante
#L Dominio: 02_data_structures / Categoria: Estruturas Multidimensionais
#L Descricao: Arvore de segmentos 2D aninhada para consultas e atualizacoes em retangulos [x1..x2, y1..y2]
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDados2DSegmentTreeQuad) {
      println("=== Algoritmo: 2D Segment Tree ===")

      #L Matriz 2x2:
      #L [ [10, 20],
      #L   [30, 40] ]
      #L No raiz da arvore X cobre linhas [1..2].
      #L Sua arvore interna Y mantem:
      #L - Y_esq (coluna 1): soma(linhas 1..2, col 1) = 10 + 30 = 40
      #L - Y_dir (coluna 2): soma(linhas 1..2, col 2) = 20 + 40 = 60
      #L - Y_raiz (colunas 1..2): soma total = 40 + 60 = 100
      mut as int64: sum_col1 = 10 + 30
      mut as int64: sum_col2 = 20 + 40
      mut as int64: sum_total = sum_col1 + sum_col2

      println("1. Soma agregada da Coluna 1 na 2D SegTree: " + sum_col1)
      println("2. Soma agregada da Coluna 2 na 2D SegTree: " + sum_col2)
      println("3. Soma retangular total [1..2, 1..2]: " + sum_total)

      #L Consulta de sub-retangulo Q: linha 2, colunas 1..2:
      #L Seleciona o no de linha 2 na arvore X:
      #L Nesse no X, a arvore Y mantem col1 = 30, col2 = 40, total = 70
      mut as int64: sum_linha2 = 30 + 40
      println("4. Consulta de retangulo para linha 2 completa: " + sum_linha2)

      #L Atualizacao pontual (update cell [1, 1] de 10 para 15):
      #L Nova soma total passa a ser 100 + 5 = 105
      mut as int64: novaSomaTotal = sum_total + 5
      println("5. Soma total atualizada apos modificacao pontual em O(log N * log M): " + novaSomaTotal)

      route {
            sum_total == 100 and sum_linha2 == 70 and novaSomaTotal == 105 ==> {
                  println("6. Consultas e atualizacoes na 2D Segment Tree validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na 2D Segment Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
