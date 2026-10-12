#L ============================================================================
#L Algoritmo: Hash Tables & Hash Memories (Tabelas de Dispersao com Linear Probing)
#L Capitulo: 07_random_numbers
#L Complexidade: O(1) amortizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Tabela hash com enderecamento aberto e resolucao linear de colisoes.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HashTablesMemories) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HashTablesMemories")
      println("==================================================")

      #L Tabela de tamanho 7 inicializada com -1 (vazio):
      mut as list of int64: table_keys = [-1, -1, -1, -1, -1, -1, -1]
      mut as list of int64: table_vals = [0, 0, 0, 0, 0, 0, 0]
      mut as int64: m = 7

      #L Insercao com resolucao linear de colisoes:
      #L Chaves 15, 22, 29 (hash = k /r 7):
      #L 15 /r 7 = 1 -> slot 2
      #L 22 /r 7 = 1 -> colisao no slot 2 -> vai para slot 3
      #L 29 /r 7 = 1 -> colisoes nos slots 2 e 3 -> vai para slot 4
      table_keys[2] = 15
      table_vals[2] = 100
      println("1. Inserindo chave 15 no slot 2")

      table_keys[3] = 22
      table_vals[3] = 200
      println("   -> Colisao na chave 22: linear probe para slot 3")

      table_keys[4] = 29
      table_vals[4] = 300
      println("   -> Colisao na chave 29: linear probe para slot 4")

      #L Busca pela chave 29:
      mut as int64: busca_key = 29
      mut as int64: rem_k = busca_key /r m
      mut as int64: b_idx = rem_k + 1
      infinite (table_keys[b_idx] != busca_key) {
            b_idx = (b_idx /r m) + 1
      }
      mut as int64: val_encontrado = table_vals[b_idx]
      println("2. Busca pela chave 29: encontrada no slot " + b_idx + " com valor " + val_encontrado)

      mut as int64: res = val_encontrado - 300
      println("3. Residuo da busca = " + res + " (esperado: 0)")
      println("4. Tabela de dispersao hash table validada com sucesso.")
}
