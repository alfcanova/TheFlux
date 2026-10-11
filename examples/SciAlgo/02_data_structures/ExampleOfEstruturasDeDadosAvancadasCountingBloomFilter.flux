#L ============================================================================
#L Algoritmo: Counting Bloom Filter (Filtro Probabilistico com Suporte a Remocao)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(k) insercao, consulta e remocao | Espaco O(M) contadores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasCountingBloomFilter) {
      println("==================================================")
      println("  SciAlgo: Counting Bloom Filter (Insert/Delete)")
      println("==================================================")

      mut as int64: m = 32
      mut as list of int64: counts = [
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
      ]

      #L Inserir chaves 15, 28, 42
      mut as list of int64: ins_keys = [15, 28, 42]
      mut as int64: n_ins = listLength(ins_keys)
      println("1. Inserindo chaves [15, 28, 42]:")
      mut as int64: i = 1
      infinite (i <= n_ins) {
            mut as int64: k = ins_keys[i]
            mut as int64: h1 = ((k * 17 + 5) /r m) + 1
            mut as int64: h2 = ((k * 37 + 11) /r m) + 1
            mut as int64: h3 = ((k * 71 + 23) /r m) + 1

            counts[h1] = counts[h1] + 1
            counts[h2] = counts[h2] + 1
            counts[h3] = counts[h3] + 1
            println("   Inserido " + k + " -> Hash indices: (" + h1 + ", " + h2 + ", " + h3 + ")")
            i = i + 1
      }

      println("2. Verificando presenca inicial:")
      mut as int64: k_check = 28
      mut as int64: c_h1 = ((k_check * 17 + 5) /r m) + 1
      mut as int64: c_h2 = ((k_check * 37 + 11) /r m) + 1
      mut as int64: c_h3 = ((k_check * 71 + 23) /r m) + 1
      mut as bool: has_28_before = (counts[c_h1] > 0) and (counts[c_h2] > 0) and (counts[c_h3] > 0)
      println("   Contem 28 antes de remover: " + has_28_before)

      println("3. Removendo chave 28 do Counting Bloom Filter:")
      counts[c_h1] = counts[c_h1] - 1
      counts[c_h2] = counts[c_h2] - 1
      counts[c_h3] = counts[c_h3] - 1
      println("   Chave 28 removida decrementando contadores.")

      println("4. Verificando presenca apos remocao:")
      mut as bool: has_28_after = (counts[c_h1] > 0) and (counts[c_h2] > 0) and (counts[c_h3] > 0)
      println("   Contem 28 apos remocao: " + has_28_after)

      #L Verificar se as outras chaves ainda estao presentes
      mut as int64: k15 = 15
      mut as int64: k15_h1 = ((k15 * 17 + 5) /r m) + 1
      mut as int64: k15_h2 = ((k15 * 37 + 11) /r m) + 1
      mut as int64: k15_h3 = ((k15 * 71 + 23) /r m) + 1
      mut as bool: has_15 = (counts[k15_h1] > 0) and (counts[k15_h2] > 0) and (counts[k15_h3] > 0)
      println("   Contem 15 (permanece): " + has_15)

      mut as int64: k42 = 42
      mut as int64: k42_h1 = ((k42 * 17 + 5) /r m) + 1
      mut as int64: k42_h2 = ((k42 * 37 + 11) /r m) + 1
      mut as int64: k42_h3 = ((k42 * 71 + 23) /r m) + 1
      mut as bool: has_42 = (counts[k42_h1] > 0) and (counts[k42_h2] > 0) and (counts[k42_h3] > 0)
      println("   Contem 42 (permanece): " + has_42)

      #L Chave nunca inserida
      mut as int64: k99 = 999
      mut as int64: k99_h1 = ((k99 * 17 + 5) /r m) + 1
      mut as int64: k99_h2 = ((k99 * 37 + 11) /r m) + 1
      mut as int64: k99_h3 = ((k99 * 71 + 23) /r m) + 1
      mut as bool: has_99 = (counts[k99_h1] > 0) and (counts[k99_h2] > 0) and (counts[k99_h3] > 0)
      println("   Contem 999 (nunca inserido): " + has_99)

      mut as bool: valid = has_28_before and (not has_28_after) and has_15 and has_42 and (not has_99)
      println("5. Validacao: " + valid)
      println("==================================================")
}
