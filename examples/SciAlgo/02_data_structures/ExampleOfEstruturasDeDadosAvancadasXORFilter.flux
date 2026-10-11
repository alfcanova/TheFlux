#L ============================================================================
#L Algoritmo: XOR Filter (Filtro Probabilistico Baseado em Hipergrafo XOR)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) consulta com 3 lookups de hash | Espaco O(N) ultra compacto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasXORFilter) {
      println("==================================================")
      println("  SciAlgo: XOR Filter (Graf & Lemire Fast Filter)")
      println("==================================================")

      #L Tabela particionada em 3 blocos (L = 8 slots por bloco, total 24)
      mut as int64: block_size = 8
      mut as list of int64: b_table = [
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
      ]

      #L Chaves do conjunto estatico: [10, 21, 32, 43]
      mut as list of int64: keys = [10, 21, 32, 43]
      mut as int64: n_keys = listLength(keys)

      #L Pre-computando fingerprints e posicoes para cada chave
      #L h0 = (k * 13) % 8 + 1
      #L h1 = (k * 29) % 8 + 9
      #L h2 = (k * 53) % 8 + 17
      #L fp = ((k * 31) % 255) + 1
      println("1. Construindo XOR Filter com 4 chaves:")
      mut as int64: i = 1
      infinite (i <= n_keys) {
            mut as int64: k = keys[i]
            mut as int64: p0 = ((k * 13) /r block_size) + 1
            mut as int64: p1 = ((k * 29) /r block_size) + 9
            mut as int64: p2 = ((k * 53) /r block_size) + 17
            mut as int64: fp = ((k * 31) /r 255) + 1

            #L Atribuicao no bloco 2 para satisfazer: B[p0] ^ B[p1] ^ B[p2] == fp
            #L B[p2] = fp ^ B[p0] ^ B[p1]
            mut as int64: cur_val = b_table[p0] ^ b_table[p1]
            b_table[p2] = fp ^ cur_val

            println("   Chave " + k + " -> Slots (" + p0 + ", " + p1 + ", " + p2 + ") FP: " + fp)
            i = i + 1
      }

      println("2. Consultando presenca das chaves presentes:")
      mut as bool: all_present = true
      i = 1
      infinite (i <= n_keys) {
            mut as int64: k = keys[i]
            mut as int64: p0 = ((k * 13) /r block_size) + 1
            mut as int64: p1 = ((k * 29) /r block_size) + 9
            mut as int64: p2 = ((k * 53) /r block_size) + 17
            mut as int64: expected_fp = ((k * 31) /r 255) + 1

            mut as int64: computed_fp = (b_table[p0] ^ b_table[p1]) ^ b_table[p2]
            mut as bool: found = (computed_fp == expected_fp)
            println("   Contem chave " + k + " (FP=" + computed_fp + "): " + found)
            route {
                  not found ==> {
                        all_present = false
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("3. Consultando chave ausente (999):")
      mut as int64: abs_k = 999
      mut as int64: ap0 = ((abs_k * 13) /r block_size) + 1
      mut as int64: ap1 = ((abs_k * 29) /r block_size) + 9
      mut as int64: ap2 = ((abs_k * 53) /r block_size) + 17
      mut as int64: exp_abs_fp = ((abs_k * 31) /r 255) + 1
      mut as int64: comp_abs_fp = (b_table[ap0] ^ b_table[ap1]) ^ b_table[ap2]
      mut as bool: abs_found = (comp_abs_fp == exp_abs_fp)
      println("   Contem chave 999: " + abs_found)

      mut as bool: valid = all_present and not abs_found
      println("4. Validacao: " + valid)
      println("==================================================")
}
