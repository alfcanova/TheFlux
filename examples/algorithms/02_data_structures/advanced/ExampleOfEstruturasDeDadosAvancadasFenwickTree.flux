#L ============================================================================
#L Algoritmo: Fenwick Tree (Binary Indexed Tree - BIT)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Atualizacao O(log N) | Consulta de Prefixo O(log N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasFenwickTree) {
      println("==================================================")
      println("  SciAlgo: Fenwick Tree (Binary Indexed Tree)")
      println("==================================================")

      mut as list of int64: arr = [3, 2, -1, 6, 5, 4, -3, 3, 7, 2]
      mut as int64: n = listLength(arr)
      println("1. Vetor original de " + n + " elementos: " + arr)

      #L Inicializacao da arvore com zeros (1-based, tamanho n)
      mut as list of int64: bit = []
      mut as int64: zi = 1
      infinite (zi <= n) {
            bit = listPushBack(bit, 0)
            zi = zi + 1
      }

      #L Construcao da BIT via point updates sucessivos
      println("2. Construindo Fenwick Tree com atualizacoes pontuais...")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: val = arr[i]
            mut as int64: idx = i
            infinite (idx <= n) {
                  bit[idx] = bit[idx] + val
                  idx = idx + (idx & (-idx))
            }
            i = i + 1
      }
      println("   Vetor interno da BIT: " + bit)

      #L Consultas de soma de prefixo
      println("3. Consultas de soma acumulada de prefixo (Prefix Sum):")
      
      #L Prefixo ate indice 5 (esperado 3 + 2 - 1 + 6 + 5 = 15)
      mut as int64: sum_pref_5 = 0
      mut as int64: p5 = 5
      infinite (p5 > 0) {
            sum_pref_5 = sum_pref_5 + bit[p5]
            p5 = p5 - (p5 & (-p5))
      }
      println("   Soma prefixo [1..5] (esperado 15): " + sum_pref_5)

      #L Prefixo total [1..10] (esperado 3+2-1+6+5+4-3+3+7+2 = 28)
      mut as int64: sum_pref_10 = 0
      mut as int64: p10 = 10
      infinite (p10 > 0) {
            sum_pref_10 = sum_pref_10 + bit[p10]
            p10 = p10 - (p10 & (-p10))
      }
      println("   Soma prefixo [1..10] (esperado 28): " + sum_pref_10)

      #L Consultas de soma por faixa (Range Sum Query [L..R] = query(R) - query(L - 1))
      println("4. Consultas de subfaixa:")
      
      #L Faixa [3..7]: arr[3..7] = [-1, 6, 5, 4, -3] -> soma = 11
      mut as int64: sum_r7 = 0
      mut as int64: q7 = 7
      infinite (q7 > 0) {
            sum_r7 = sum_r7 + bit[q7]
            q7 = q7 - (q7 & (-q7))
      }
      mut as int64: sum_l2 = 0
      mut as int64: q2 = 2
      infinite (q2 > 0) {
            sum_l2 = sum_l2 + bit[q2]
            q2 = q2 - (q2 & (-q2))
      }
      mut as int64: range_3_7 = sum_r7 - sum_l2
      println("   Soma subfaixa [3..7] (esperado 11): " + range_3_7)

      #L Atualizacao pontual dinamica: adicionar delta = 10 na posicao 3
      println("5. Atualizando posicao 3 com delta +10 (antigo: -1, novo: 9)...")
      mut as int64: delta = 10
      mut as int64: up_pos = 3
      infinite (up_pos <= n) {
            bit[up_pos] = bit[up_pos] + delta
            up_pos = up_pos + (up_pos & (-up_pos))
      }

      #L Reconsulta na subfaixa [3..7] (deve aumentar em 10 -> esperado 21)
      mut as int64: new_sum_r7 = 0
      mut as int64: nq7 = 7
      infinite (nq7 > 0) {
            new_sum_r7 = new_sum_r7 + bit[nq7]
            nq7 = nq7 - (nq7 & (-nq7))
      }
      mut as int64: new_range_3_7 = new_sum_r7 - sum_l2
      println("   Nova soma subfaixa [3..7] (esperado 21): " + new_range_3_7)

      #L Reconsulta na soma total (deve aumentar de 28 para 38)
      mut as int64: new_sum_total = 0
      mut as int64: nq10 = 10
      infinite (nq10 > 0) {
            new_sum_total = new_sum_total + bit[nq10]
            nq10 = nq10 - (nq10 & (-nq10))
      }
      println("   Nova soma total [1..10] (esperado 38): " + new_sum_total)

      mut as bool: ok = (sum_pref_5 == 15) and (sum_pref_10 == 28) and (range_3_7 == 11) and (new_range_3_7 == 21) and (new_sum_total == 38)
      println("6. Verificacao da Fenwick Tree: " + ok)
      println("Concluido com Sucesso")
}
