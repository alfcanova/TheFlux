#L ============================================================================
#L Algoritmo: MinHash (Min-wise Independent Permutations)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas e arvores
#L Complexidade: Tempo O(K * |S|) | Espaco O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasMinHash) {
      println("==================================================")
      println("  SciAlgo: MinHash (Estimacao de Similaridade Jaccard)")
      println("==================================================")

      #L 1. Conjuntos A e B representados como listas de inteiros
      #L Conjunto A: {10, 20, 30, 40, 50, 60} (tam = 6)
      #L Conjunto B: {20, 30, 40, 50, 70, 80} (tam = 6)
      #L Intersecao: {20, 30, 40, 50} (tam = 4)
      #L Uniao: {10, 20, 30, 40, 50, 60, 70, 80} (tam = 8)
      #L Jaccard Exato: 4 / 8 = 0.50 (50%)
      mut as list of int64: conjunto_a = [10, 20, 30, 40, 50, 60]
      mut as list of int64: conjunto_b = [20, 30, 40, 50, 70, 80]
      mut as int64: tam_a = listLength(conjunto_a)
      mut as int64: tam_b = listLength(conjunto_b)

      println("1. Conjunto A (tamanho " + tam_a + "): [10, 20, 30, 40, 50, 60]")
      println("   Conjunto B (tamanho " + tam_b + "): [20, 30, 40, 50, 70, 80]")

      #L 2. Coeficientes para k=5 funcoes hash universais:
      #L h_i(x) = ((a_i * x + b_i) % primo)
      mut as list of int64: coef_a = [17, 31, 7, 23, 41]
      mut as list of int64: coef_b = [13, 29, 3, 11, 37]
      mut as int64: primo = 10007
      mut as int64: num_hashes = 5

      println("2. Parametros do MinHash:")
      println("   - Numero de funcoes hash (k): " + num_hashes)
      println("   - Modulo primo: " + primo)

      #L 3. Vetores de assinatura MinHash para A e B
      mut as list of int64: sig_a = [0, 0, 0, 0, 0]
      mut as list of int64: sig_b = [0, 0, 0, 0, 0]

      #L 4. Calculo das assinaturas MinHash
      mut as int64: h_idx = 1
      infinite (h_idx <= num_hashes) {
            mut as int64: ca = coef_a[h_idx]
            mut as int64: cb = coef_b[h_idx]

            #L Menor valor de hash para conjunto A
            mut as int64: min_val_a = 999999
            mut as int64: ia = 1
            infinite (ia <= tam_a) {
                  mut as int64: elem_a = conjunto_a[ia]
                  mut as int64: h_a = (((elem_a * ca) + cb) /r primo)
                  route {
                        h_a < min_val_a ==> { min_val_a = h_a }
                        _ ==> {}
                  }
                  ia = ia + 1
            }
            sig_a[h_idx] = min_val_a

            #L Menor valor de hash para conjunto B
            mut as int64: min_val_b = 999999
            mut as int64: ib = 1
            infinite (ib <= tam_b) {
                  mut as int64: elem_b = conjunto_b[ib]
                  mut as int64: h_b = (((elem_b * ca) + cb) /r primo)
                  route {
                        h_b < min_val_b ==> { min_val_b = h_b }
                        _ ==> {}
                  }
                  ib = ib + 1
            }
            sig_b[h_idx] = min_val_b

            h_idx = h_idx + 1
      }

      println("3. Assinaturas MinHash geradas:")
      println("   - Assinatura A: [" + sig_a[1] + ", " + sig_a[2] + ", " + sig_a[3] + ", " + sig_a[4] + ", " + sig_a[5] + "]")
      println("   - Assinatura B: [" + sig_b[1] + ", " + sig_b[2] + ", " + sig_b[3] + ", " + sig_b[4] + ", " + sig_b[5] + "]")

      #L 5. Comparacao das assinaturas para estimar similaridade de Jaccard
      mut as int64: matches = 0
      mut as int64: ki = 1
      infinite (ki <= num_hashes) {
            route {
                  sig_a[ki] == sig_b[ki] ==> {
                        matches = matches + 1
                  }
                  _ ==> {}
            }
            ki = ki + 1
      }

      mut as int64: jaccard_estimado_pct = (matches * 100) /i num_hashes
      mut as int64: jaccard_real_pct = 50

      println("4. Estimativa de Similaridade:")
      println("   - Coincidencias de assinatura: " + matches + " / " + num_hashes)
      println("   - Similaridade de Jaccard estimada: " + jaccard_estimado_pct + "%")
      println("   - Similaridade de Jaccard exata: " + jaccard_real_pct + "%")
      println("5. MinHash concluido com sucesso.")
}
