#L ============================================================================
#L Algoritmo: Sparse Table (Range Minimum Query O(1))
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Pre-processamento O(N log N) | Consulta O(1) | Espaco O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSparseTable) {
      println("==================================================")
      println("  SciAlgo: Sparse Table (Range Minimum Query O(1))")
      println("==================================================")

      #L Array base de entrada com N = 10 elementos (1-based)
      mut as list of int64: arr = [14, 8, 22, 5, 31, 19, 7, 42, 3, 11]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada com N = " + n + ": [14, 8, 22, 5, 31, 19, 7, 42, 3, 11]")

      #L Tabelas esparsas para potencias de 2 (k = 0, 1, 2, 3) onde 2^3 = 8 <= 10
      #L st0[i] cobre intervalo de tamanho 2^0 = 1
      #L st1[i] cobre intervalo de tamanho 2^1 = 2
      #L st2[i] cobre intervalo de tamanho 2^2 = 4
      #L st3[i] cobre intervalo de tamanho 2^3 = 8
      mut as list of int64: st0 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: st1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: st2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: st3 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      println("2. Pre-computando Sparse Table...")

      #L Nivel k = 0: st0[i] = arr[i]
      mut as int64: i = 1
      infinite (i <= n) {
            st0[i] = arr[i]
            i = i + 1
      }

      #L Nivel k = 1 (span 2): st1[i] = min(st0[i], st0[i + 1])
      i = 1
      infinite (i <= n - 1) {
            mut as int64: v1 = st0[i]
            mut as int64: v2 = st0[i + 1]
            route {
                  v1 <= v2 ==> { st1[i] = v1 }
                  _ ==> { st1[i] = v2 }
            }
            i = i + 1
      }

      #L Nivel k = 2 (span 4): st2[i] = min(st1[i], st1[i + 2])
      i = 1
      infinite (i <= n - 3) {
            mut as int64: v1 = st1[i]
            mut as int64: v2 = st1[i + 2]
            route {
                  v1 <= v2 ==> { st2[i] = v1 }
                  _ ==> { st2[i] = v2 }
            }
            i = i + 1
      }

      #L Nivel k = 3 (span 8): st3[i] = min(st2[i], st2[i + 4])
      i = 1
      infinite (i <= n - 7) {
            mut as int64: v1 = st2[i]
            mut as int64: v2 = st2[i + 4]
            route {
                  v1 <= v2 ==> { st3[i] = v1 }
                  _ ==> { st3[i] = v2 }
            }
            i = i + 1
      }

      println("   Sparse Table construida com sucesso.")

      #L 3. Consultas RMQ O(1) usando sobreposicao idempotente min
      println("3. Executando consultas Range Minimum Query (RMQ):")

      #L Consulta 1: RMQ(1, 10) -> tamanho 10 -> k = 3 (2^3 = 8)
      #L min(st3[1], st3[10 - 8 + 1]) = min(st3[1], st3[3])
      mut as int64: q1_left = st3[1]
      mut as int64: q1_right = st3[3]
      mut as int64: ans1 = q1_left
      route {
            q1_right < ans1 ==> { ans1 = q1_right }
      }
      println("   RMQ(1, 10) [esperado 3]: " + ans1)

      #L Consulta 2: RMQ(1, 3) -> tamanho 3 -> k = 1 (2^1 = 2)
      #L min(st1[1], st1[3 - 2 + 1]) = min(st1[1], st1[2])
      mut as int64: q2_left = st1[1]
      mut as int64: q2_right = st1[2]
      mut as int64: ans2 = q2_left
      route {
            q2_right < ans2 ==> { ans2 = q2_right }
      }
      println("   RMQ(1, 3) [esperado 8]: " + ans2)

      #L Consulta 3: RMQ(3, 6) -> tamanho 4 -> k = 2 (2^2 = 4)
      #L min(st2[3], st2[6 - 4 + 1]) = min(st2[3], st2[3])
      mut as int64: ans3 = st2[3]
      println("   RMQ(3, 6) [esperado 5]: " + ans3)

      #L Consulta 4: RMQ(5, 8) -> tamanho 4 -> k = 2 (2^2 = 4)
      #L min(st2[5], st2[8 - 4 + 1]) = min(st2[5], st2[5])
      mut as int64: ans4 = st2[5]
      println("   RMQ(5, 8) [esperado 7]: " + ans4)

      #L Consulta 5: RMQ(9, 10) -> tamanho 2 -> k = 1 (2^1 = 2)
      mut as int64: ans5 = st1[9]
      println("   RMQ(9, 10) [esperado 3]: " + ans5)

      #L Consulta 6: RMQ(7, 7) -> tamanho 1 -> k = 0
      mut as int64: ans6 = st0[7]
      println("   RMQ(7, 7) [esperado 7]: " + ans6)

      mut as bool: ok = (ans1 == 3) and (ans2 == 8) and (ans3 == 5) and (ans4 == 7) and (ans5 == 3) and (ans6 == 7)
      println("4. Verificacao de todas as consultas RMQ O(1): " + ok)
      println("Concluido com Sucesso")
}
