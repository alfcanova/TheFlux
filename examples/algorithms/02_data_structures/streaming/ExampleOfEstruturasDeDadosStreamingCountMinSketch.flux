#L ============================================================================
#L Algoritmo: Count-Min Sketch (Streaming Frequency Estimation)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados / Streaming
#L Complexidade: update O(d) | query O(d) | Espaco O(d * w)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingCountMinSketch) {
      println("==================================================")
      println("  SciAlgo: Count-Min Sketch (Frequencia em Stream)")
      println("==================================================")

      #L Parametros do Sketch: profundidade d = 4 tabelas, largura w = 16 contadores
      mut as int64: d = 4
      mut as int64: w = 16
      println("1. Inicializando Count-Min Sketch com d = 4 hash tables, w = 16 colunas...")

      #L Inicializa 4 linhas de contadores (1-based, tamanho 16 cada)
      mut as list of int64: row1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: row2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: row3 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: row4 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      #L Stream de entrada: pares (item, incremento)
      #L item 10 adicionado 5 vezes
      #L item 20 adicionado 3 vezes
      #L item 30 adicionado 8 vezes
      #L item 40 adicionado 2 vezes
      mut as list of int64: stream_items = [10, 20, 30, 10, 30, 20, 10, 30, 30, 10, 40, 30, 20, 10, 30, 40, 30, 30]
      mut as int64: num_events = listLength(stream_items)
      println("2. Processando stream de " + num_events + " eventos...")

      mut as int64: idx = 1
      infinite (idx <= num_events) {
            mut as int64: item = stream_items[idx]

            #L Funcao hash 1: ((item * 17 + 5) /r 997) /r 16 + 1
            mut as int64: c1 = (((item * 17) + 5) /r 997) /r w + 1
            row1[c1] = row1[c1] + 1

            #L Funcao hash 2: ((item * 31 + 13) /r 997) /r 16 + 1
            mut as int64: c2 = (((item * 31) + 13) /r 997) /r w + 1
            row2[c2] = row2[c2] + 1

            #L Funcao hash 3: ((item * 67 + 29) /r 997) /r 16 + 1
            mut as int64: c3 = (((item * 67) + 29) /r 997) /r w + 1
            row3[c3] = row3[c3] + 1

            #L Funcao hash 4: ((item * 101 + 43) /r 997) /r 16 + 1
            mut as int64: c4 = (((item * 101) + 43) /r 997) /r w + 1
            row4[c4] = row4[c4] + 1

            idx = idx + 1
      }
      println("   Stream processado com sucesso.")

      #L 3. Consultas de frequencia (minimo das 4 linhas)
      println("3. Executando consultas pontuais de frequencia no Count-Min Sketch:")

      #L Consulta item 10 (frequencia real = 5)
      mut as int64: q1_c1 = (((10 * 17) + 5) /r 997) /r w + 1
      mut as int64: q1_c2 = (((10 * 31) + 13) /r 997) /r w + 1
      mut as int64: q1_c3 = (((10 * 67) + 29) /r 997) /r w + 1
      mut as int64: q1_c4 = (((10 * 101) + 43) /r 997) /r w + 1

      mut as int64: est_10 = row1[q1_c1]
      route {
            row2[q1_c2] < est_10 ==> { est_10 = row2[q1_c2] }
      }
      route {
            row3[q1_c3] < est_10 ==> { est_10 = row3[q1_c3] }
      }
      route {
            row4[q1_c4] < est_10 ==> { est_10 = row4[q1_c4] }
      }
      println("   Estimativa para item 10 (real = 5): " + est_10)

      #L Consulta item 20 (frequencia real = 3)
      mut as int64: q2_c1 = (((20 * 17) + 5) /r 997) /r w + 1
      mut as int64: q2_c2 = (((20 * 31) + 13) /r 997) /r w + 1
      mut as int64: q2_c3 = (((20 * 67) + 29) /r 997) /r w + 1
      mut as int64: q2_c4 = (((20 * 101) + 43) /r 997) /r w + 1

      mut as int64: est_20 = row1[q2_c1]
      route {
            row2[q2_c2] < est_20 ==> { est_20 = row2[q2_c2] }
      }
      route {
            row3[q2_c3] < est_20 ==> { est_20 = row3[q2_c3] }
      }
      route {
            row4[q2_c4] < est_20 ==> { est_20 = row4[q2_c4] }
      }
      println("   Estimativa para item 20 (real = 3): " + est_20)

      #L Consulta item 30 (frequencia real = 8)
      mut as int64: q3_c1 = (((30 * 17) + 5) /r 997) /r w + 1
      mut as int64: q3_c2 = (((30 * 31) + 13) /r 997) /r w + 1
      mut as int64: q3_c3 = (((30 * 67) + 29) /r 997) /r w + 1
      mut as int64: q3_c4 = (((30 * 101) + 43) /r 997) /r w + 1

      mut as int64: est_30 = row1[q3_c1]
      route {
            row2[q3_c2] < est_30 ==> { est_30 = row2[q3_c2] }
      }
      route {
            row3[q3_c3] < est_30 ==> { est_30 = row3[q3_c3] }
      }
      route {
            row4[q3_c4] < est_30 ==> { est_30 = row4[q3_c4] }
      }
      println("   Estimativa para item 30 (real = 8): " + est_30)

      #L Consulta item 40 (frequencia real = 2)
      mut as int64: q4_c1 = (((40 * 17) + 5) /r 997) /r w + 1
      mut as int64: q4_c2 = (((40 * 31) + 13) /r 997) /r w + 1
      mut as int64: q4_c3 = (((40 * 67) + 29) /r 997) /r w + 1
      mut as int64: q4_c4 = (((40 * 101) + 43) /r 997) /r w + 1

      mut as int64: est_40 = row1[q4_c1]
      route {
            row2[q4_c2] < est_40 ==> { est_40 = row2[q4_c2] }
      }
      route {
            row3[q4_c3] < est_40 ==> { est_40 = row3[q4_c3] }
      }
      route {
            row4[q4_c4] < est_40 ==> { est_40 = row4[q4_c4] }
      }
      println("   Estimativa para item 40 (real = 2): " + est_40)

      #L Consulta item 99 (item ausente, frequencia real = 0)
      mut as int64: q99_c1 = (((99 * 17) + 5) /r 997) /r w + 1
      mut as int64: q99_c2 = (((99 * 31) + 13) /r 997) /r w + 1
      mut as int64: q99_c3 = (((99 * 67) + 29) /r 997) /r w + 1
      mut as int64: q99_c4 = (((99 * 101) + 43) /r 997) /r w + 1

      mut as int64: est_99 = row1[q99_c1]
      route {
            row2[q99_c2] < est_99 ==> { est_99 = row2[q99_c2] }
      }
      route {
            row3[q99_c3] < est_99 ==> { est_99 = row3[q99_c3] }
      }
      route {
            row4[q99_c4] < est_99 ==> { est_99 = row4[q99_c4] }
      }
      println("   Estimativa para item 99 ausente (real = 0): " + est_99)

      #L Propriedades fundamentais do Count-Min Sketch:
      #L 1. Sem falso negativo: est(x) >= real(x)
      #L 2. Cotas superiores bem aproximadas
      mut as bool: ok = (est_10 >= 5) and (est_20 >= 3) and (est_30 >= 8) and (est_40 >= 2) and (est_99 >= 0)
      println("4. Verificacao de propriedades do Count-Min Sketch: " + ok)
      println("Concluido com Sucesso")
}
