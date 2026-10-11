#L ============================================================================
#L Algoritmo: Min-wise Independent Permutations (Broder 1998 - Estimativa Jaccard)
#L Dominio: 02_data_structures / Categoria: 3. Algoritmos de selecao e streaming
#L Complexidade: O(K * |S|) construcao de assinatura | O(K) comparacao | Espaco O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingMinWisePermutations) {
      println("==================================================")
      println("  SciAlgo: Min-wise Independent Permutations")
      println("==================================================")

      #L Dois conjuntos para medicao de similaridade Jaccard:
      #L Conjunto A: {1, 2, 3, 4, 5, 6} (|A| = 6)
      #L Conjunto B: {4, 5, 6, 7, 8, 9} (|B| = 6)
      #L Intersecao = {4, 5, 6} (|A n B| = 3)
      #L Uniao = {1, 2, 3, 4, 5, 6, 7, 8, 9} (|A u B| = 9)
      #L Similaridade Jaccard exata = 3 / 9 = 33,3%
      mut as list of int64: set_a = [1, 2, 3, 4, 5, 6]
      mut as list of int64: set_b = [4, 5, 6, 7, 8, 9]
      mut as int64: len_a = listLength(set_a)
      mut as int64: len_b = listLength(set_b)

      println("1. Conjuntos de teste:")
      println("   Set A (|A| = " + len_a + "): [1, 2, 3, 4, 5, 6]")
      println("   Set B (|B| = " + len_b + "): [4, 5, 6, 7, 8, 9]")

      #L K = 10 funcoes de permutacao hash pseudo-aleatorias
      mut as int64: k_perm = 10
      mut as int64: prime = 10007
      mut as list of int64: hash_a = [2341, 5683, 8929, 1279, 4421, 7151, 3889, 6211, 9187, 1543]
      mut as list of int64: hash_b = [719, 1453, 2897, 4391, 5821, 7129, 8543, 9127, 3671, 6217]

      #L Assinaturas MinHash para A e B
      mut as list of int64: sig_a = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: sig_b = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      println("2. Computando assinaturas de permutacao minima para K = " + k_perm + "...")

      #L Para cada funcao hash k in 1..10
      mut as int64: ki = 1
      infinite (ki <= k_perm) {
            mut as int64: ha = hash_a[ki]
            mut as int64: hb = hash_b[ki]

            #L Menor hash de elementos em Set A
            mut as int64: min_val_a = 99999999
            mut as int64: ai = 1
            infinite (ai <= len_a) {
                  mut as int64: x = set_a[ai]
                  mut as int64: hx = ((ha * x) + hb) /r prime
                  route {
                        hx < min_val_a ==> { min_val_a = hx }
                  }
                  ai = ai + 1
            }
            sig_a[ki] = min_val_a

            #L Menor hash de elementos em Set B
            mut as int64: min_val_b = 99999999
            mut as int64: bi = 1
            infinite (bi <= len_b) {
                  mut as int64: y = set_b[bi]
                  mut as int64: hy = ((ha * y) + hb) /r prime
                  route {
                        hy < min_val_b ==> { min_val_b = hy }
                  }
                  bi = bi + 1
            }
            sig_b[ki] = min_val_b

            ki = ki + 1
      }
      println("   Assinaturas MinHash computadas com sucesso.")

      #L 3. Contagem de colisoes de MinHash: P(sig_a[k] == sig_b[k]) = Jaccard(A, B)
      println("3. Comparando assinaturas de permutacao minima:")
      mut as int64: matches = 0
      ki = 1
      infinite (ki <= k_perm) {
            mut as bool: eq = (sig_a[ki] == sig_b[ki])
            println("   Permutacao " + ki + ": min_a = " + sig_a[ki] + " | min_b = " + sig_b[ki] + " -> match: " + eq)
            route {
                  eq == true ==> {
                        matches = matches + 1
                  }
            }
            ki = ki + 1
      }

      #L Estimativa em porcentagem inteira
      mut as int64: jaccard_pct = (matches * 100) /i k_perm
      println("4. Similaridade Jaccard estimada: " + jaccard_pct + "% (esperado ~33%)")

      #L Verificacao de propriedades teoricas
      mut as bool: ok = (matches > 0) and (matches <= k_perm) and (jaccard_pct >= 20) and (jaccard_pct <= 50)
      println("5. Verificacao geral de Min-wise Permutations: " + ok)
      println("Concluido com Sucesso")
}
