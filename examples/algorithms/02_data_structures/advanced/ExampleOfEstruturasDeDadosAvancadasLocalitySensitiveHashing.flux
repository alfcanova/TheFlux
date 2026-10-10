#L ============================================================================
#L Algoritmo: Locality-Sensitive Hashing (LSH com Banding para Busca por Similaridade)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: O(b * r) por documento | O(1) consulta de vizinho candidato
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasLocalitySensitiveHashing) {
      println("==================================================")
      println("  SciAlgo: Locality-Sensitive Hashing (MinHash LSH)")
      println("==================================================")

      #L Parametros de LSH: K = 6 funcoes hash, divididas em b = 3 bandas de r = 2 linhas cada
      mut as int64: num_bands = 3
      mut as int64: rows_per_band = 2
      mut as int64: num_buckets = 100
      println("1. Configurando LSH: b = 3 bandas, r = 2 linhas por banda, 100 baldes...")

      #L Assinaturas MinHash de 3 documentos (K = 6):
      #L Doc 1 e Doc 2 sao muito similares (compartilham bandas 1 e 2)
      #L Doc 3 e dissimular (nenhuma banda em comum)
      mut as list of int64: doc1_sig = [12, 45, 88, 93, 15, 27]
      mut as list of int64: doc2_sig = [12, 45, 88, 93, 77, 64] #L bandas 1 e 2 identicas ao Doc 1
      mut as list of int64: doc3_sig = [99, 10, 44, 11, 23, 91] #L totalmente distinto

      println("2. Assinaturas MinHash dos documentos:")
      println("   Doc 1: [12, 45, 88, 93, 15, 27]")
      println("   Doc 2: [12, 45, 88, 93, 77, 64]")
      println("   Doc 3: [99, 10, 44, 11, 23, 91]")

      #L Computa hashes de banda para cada documento
      #L Banda 1: linhas 1 e 2
      #L Banda 2: linhas 3 e 4
      #L Banda 3: linhas 5 e 6
      #L hash_band(r1, r2) = ((r1 * 31 + r2 * 17 + 5) /r num_buckets) + 1

      mut as list of int64: d1_bands = [0, 0, 0]
      mut as list of int64: d2_bands = [0, 0, 0]
      mut as list of int64: d3_bands = [0, 0, 0]

      mut as int64: b = 1
      infinite (b <= num_bands) {
            mut as int64: idx1 = ((b - 1) * rows_per_band) + 1
            mut as int64: idx2 = idx1 + 1

            d1_bands[b] = (((doc1_sig[idx1] * 31) + (doc1_sig[idx2] * 17) + 5) /r num_buckets) + 1
            d2_bands[b] = (((doc2_sig[idx1] * 31) + (doc2_sig[idx2] * 17) + 5) /r num_buckets) + 1
            d3_bands[b] = (((doc3_sig[idx1] * 31) + (doc3_sig[idx2] * 17) + 5) /r num_buckets) + 1

            b = b + 1
      }

      println("3. Hashes das bandas calculados:")
      println("   Doc 1 bandas: [" + d1_bands[1] + ", " + d1_bands[2] + ", " + d1_bands[3] + "]")
      println("   Doc 2 bandas: [" + d2_bands[1] + ", " + d2_bands[2] + ", " + d2_bands[3] + "]")
      println("   Doc 3 bandas: [" + d3_bands[1] + ", " + d3_bands[2] + ", " + d3_bands[3] + "]")

      #L 4. Identificacao de Pares Candidatos (Candidate Pairs)
      #L Dois documentos formam par candidato se colidirem em pelo menos 1 banda
      mut as bool: cand_1_2 = false
      mut as bool: cand_1_3 = false
      mut as bool: cand_2_3 = false

      b = 1
      infinite (b <= num_bands) {
            route {
                  d1_bands[b] == d2_bands[b] ==> { cand_1_2 = true }
            }
            route {
                  d1_bands[b] == d3_bands[b] ==> { cand_1_3 = true }
            }
            route {
                  d2_bands[b] == d3_bands[b] ==> { cand_2_3 = true }
            }
            b = b + 1
      }

      println("4. Verificacao de pares candidatos por colisoes de bandas:")
      println("   Par (Doc 1, Doc 2) candidato (esperado true): " + cand_1_2)
      println("   Par (Doc 1, Doc 3) candidato (esperado false): " + cand_1_3)
      println("   Par (Doc 2, Doc 3) candidato (esperado false): " + cand_2_3)

      mut as bool: ok = cand_1_2 and (cand_1_3 == false) and (cand_2_3 == false)
      println("5. Verificacao geral de Locality-Sensitive Hashing: " + ok)
      println("Concluido com Sucesso")
}
