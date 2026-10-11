#L ============================================================================
#L Algoritmo: t-digest (Aproximacao de Quantis e Percentis em Streams)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados streaming
#L Complexidade: O(K) espaco compacto | O(1) insercao amortizada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingTDigest) {
      println("==================================================")
      println("  SciAlgo: t-digest (Quantile Approximation)")
      println("==================================================")

      #L Stream de 10 medidas (ordenadas para simplificacao de clusterizacao)
      mut as list of int64: stream = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
      mut as int64: n = listLength(stream)

      #L Centroides: medias e pesos
      mut as list of int64: c_mean = []
      mut as list of int64: c_weight = []
      mut as int64: max_weight = 3

      println("1. Inserindo dados e comprimindo em centroides (max_weight = 3):")
      mut as int64: i = 1
      mut as int64: cur_mean = stream[1]
      mut as int64: cur_weight = 1

      i = 2
      infinite (i <= n) {
            mut as int64: val = stream[i]
            route {
                  cur_weight < max_weight ==> {
                        #L Atualiza centroide corrente: media ponderada
                        cur_mean = (cur_mean * cur_weight + val) /i (cur_weight + 1)
                        cur_weight = cur_weight + 1
                  }
                  _ ==> {
                        #L Fecha o centroide atual e inicia um novo
                        c_mean = listPushBack(c_mean, cur_mean)
                        c_weight = listPushBack(c_weight, cur_weight)
                        cur_mean = val
                        cur_weight = 1
                  }
            }
            i = i + 1
      }
      #L Adiciona o ultimo centroide
      c_mean = listPushBack(c_mean, cur_mean)
      c_weight = listPushBack(c_weight, cur_weight)

      mut as int64: num_centroids = listLength(c_mean)
      println("   Numero total de centroides: " + num_centroids)
      mut as int64: c = 1
      infinite (c <= num_centroids) {
            println("   Centroide " + c + ": Media = " + c_mean[c] + ", Peso = " + c_weight[c])
            c = c + 1
      }

      println("2. Estimando quantil p50 (Mediana, rank = 5):")
      mut as int64: target_rank = n /i 2
      mut as int64: cum_weight = 0
      mut as int64: est_p50 = 0
      mut as int64: found_idx = 0
      c = 1
      infinite (c <= num_centroids and found_idx == 0) {
            cum_weight = cum_weight + c_weight[c]
            route {
                  cum_weight >= target_rank ==> {
                        est_p50 = c_mean[c]
                        found_idx = c
                  }
                  _ ==> {
                  }
            }
            c = c + 1
      }

      println("   Mediana p50 estimada pelo t-digest: " + est_p50)

      #L Mediana real dos dados [10..100] e 55 (ou centroide em torno de 50)
      mut as bool: valid = (est_p50 >= 45 and est_p50 <= 55)
      println("3. Validacao: " + valid)
      println("==================================================")
}
