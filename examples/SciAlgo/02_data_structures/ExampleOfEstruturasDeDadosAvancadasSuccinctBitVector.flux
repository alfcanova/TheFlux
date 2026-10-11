#L ============================================================================
#L Algoritmo: Succinct Bit Vector (Estrutura Sucinta com Rank e Select O(1))
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) rank e select com o(N) bits de espaco adicional
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSuccinctBitVector) {
      println("==================================================")
      println("  SciAlgo: Succinct Bit Vector (Rank & Select)")
      println("==================================================")

      #L Bit vector de 16 bits
      #L Indices: 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
      #L Bits:    1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1
      mut as list of int64: bits = [
            1, 0, 1, 1,
            0, 0, 1, 0,
            1, 1, 0, 1,
            0, 0, 0, 1
      ]
      mut as int64: n = listLength(bits)

      #L Blocos de tamanho B = 4. Total de blocos = 4.
      #L Pre-computando prefix rank por bloco (1-based, tamanho 4)
      mut as list of int64: block_rank = [0, 0, 0, 0]
      mut as int64: cum = 0
      mut as int64: b = 1
      infinite (b <= 4) {
            mut as int64: b_count = 0
            mut as int64: j = 1
            infinite (j <= 4) {
                  mut as int64: idx = (b - 1) * 4 + j
                  b_count = b_count + bits[idx]
                  j = j + 1
            }
            cum = cum + b_count
            block_rank[b] = cum
            println("   Bloco " + b + " rank acumulado: " + cum)
            b = b + 1
      }

      println("1. Consultas de Rank1:")
      #L rank1(4): deve ser 3
      #L rank1(8): deve ser 4
      #L rank1(10): deve ser bloco 2 (4) + bits 9 e 10 (1+1) = 6
      mut as int64: q1 = 4
      mut as int64: r_q1 = 0
      mut as int64: i = 1
      infinite (i <= q1) {
            r_q1 = r_q1 + bits[i]
            i = i + 1
      }
      println("   rank1(4) = " + r_q1)

      mut as int64: q2 = 10
      mut as int64: b_idx = (q2 - 1) /i 4
      mut as int64: r_q2 = 0
      route {
            b_idx > 0 ==> {
                  r_q2 = block_rank[b_idx]
            }
            _ ==> {
            }
      }
      i = b_idx * 4 + 1
      infinite (i <= q2) {
            r_q2 = r_q2 + bits[i]
            i = i + 1
      }
      println("   rank1(10) com blocos sucintos = " + r_q2)

      println("2. Consultas de Select1:")
      #L select1(k): encontra indice do k-esimo bit 1
      #L select1(1) = 1
      #L select1(4) = 7
      #L select1(7) = 12
      mut as list of int64: sel_queries = [1, 4, 7]
      mut as list of int64: sel_results = []
      mut as int64: sq = 1
      infinite (sq <= listLength(sel_queries)) {
            mut as int64: target_k = sel_queries[sq]
            mut as int64: cur_count = 0
            mut as int64: found_pos = 0
            mut as int64: pos = 1
            infinite (pos <= n and found_pos == 0) {
                  cur_count = cur_count + bits[pos]
                  route {
                        cur_count == target_k ==> {
                              found_pos = pos
                        }
                        _ ==> {
                        }
                  }
                  pos = pos + 1
            }
            sel_results = listPushBack(sel_results, found_pos)
            println("   select1(" + target_k + ") = " + found_pos)
            sq = sq + 1
      }

      mut as bool: valid = (r_q1 == 3) and (r_q2 == 6) and (sel_results[1] == 1) and (sel_results[2] == 7) and (sel_results[3] == 12)
      println("3. Validacao: " + valid)
      println("==================================================")
}
