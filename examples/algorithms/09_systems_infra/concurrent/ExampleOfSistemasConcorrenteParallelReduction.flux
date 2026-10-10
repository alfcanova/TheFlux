#L ============================================================================
#L Algoritmo: Parallel Tree Reduction (Reducao em Arvore Concorrente)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N) operacoes | O(log N) etapas paralelas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelReduction) {
      println("==================================================")
      println("  SciAlgo: Parallel Tree Reduction Algorithm      ")
      println("==================================================")

      #L Vetor de N = 8 elementos a ser reduzido em paralelo (soma e maximo)
      mut as int64: n = 8
      mut as list of int64: data_sum = [12, 5, 8, 20, 15, 7, 3, 10]
      mut as list of int64: data_max = [12, 5, 8, 20, 15, 7, 3, 10]

      println("1. Vetor Original (N = 8):")
      mut as string: v_str = ""
      mut as int64: i = 1
      infinite (i <= n) {
            v_str = v_str + data_sum[i] + " "
            i = i + 1
      }
      println("   Vetor = [ " + v_str + "]")

      println("2. Executando Reducao Paralela em Arvore (log2(N) passos):")

      #L Stride halving: s = n/2, n/4, ..., 1
      mut as int64: stride = n /i 2
      mut as int64: step = 1

      infinite (stride >= 1) {
            println("   Passo Paralelo " + step + " (Stride = " + stride + ", Threads ativas = " + stride + "):")
            mut as int64: tid = 1
            infinite (tid <= stride) {
                  #L Reducao de Soma:
                  data_sum[tid] = data_sum[tid] + data_sum[tid + stride]

                  #L Reducao de Maximo:
                  route {
                        data_max[tid + stride] > data_max[tid] ==> {
                              data_max[tid] = data_max[tid + stride]
                        }
                        _ ==> {}
                  }

                  tid = tid + 1
            }
            stride = stride /i 2
            step = step + 1
      }

      mut as int64: final_sum = data_sum[1]
      mut as int64: final_max = data_max[1]

      println("3. Resultados da Reducao Paralela:")
      println("   Soma Total Reduzida: " + final_sum)
      println("   Valor Maximo Reduzido: " + final_max)

      #L Verificacao deterministica:
      #L Soma: 12 + 5 + 8 + 20 + 15 + 7 + 3 + 10 = 80
      #L Maximo: 20
      mut as bool: correct = (final_sum == 80) and (final_max == 20)
      println("4. Verificacao de Integridade da Reducao: " + correct)

      println("Parallel Reduction concluido com sucesso.")
}
