#L ============================================================================
#L Algoritmo: Offline Algorithm (Algoritmo Offline em Lote)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N + Q) tempo | O(N + Q) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsOfflineAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Offline Algorithm (Consultas em Lote)")
      println("==================================================")

      mut as list of int64: arr = [12, 5, 8, 20, 15, 3, 9, 14, 25, 7]
      mut as int64: n = listLength(arr)
      println("1. Vetor de dados (N = " + n + "): " + arr)

      #L Consultas estaticas conhecidas integralmente a priori:
      #L Q1 = [2, 5], Q2 = [1, 8], Q3 = [4, 9], Q4 = [6, 10]
      mut as list of int64: q_l = [2, 1, 4, 6]
      mut as list of int64: q_r = [5, 8, 9, 10]
      mut as list of int64: q_id = [1, 2, 3, 4]
      mut as int64: num_q = listLength(q_l)

      #L Fase Offline 1: Pre-processamento Global O(N) via Tabela de Prefixos
      #L prefix[k] = soma acumulada de arr[1..k]
      mut as list of int64: prefix = [0]
      mut as int64: run_sum = 0
      mut as int64: i = 1
      infinite (i <= n) {
            run_sum = run_sum + arr[i]
            prefix = listPushBack(prefix, run_sum)
            i = i + 1
      }
      println("2. Tabela de prefixos pre-computada (O(N)): " + prefix)

      #L Fase Offline 2: Ordenacao das consultas por ponto final R para lote
      mut as int64: a = 1
      infinite (a <= num_q) {
            mut as int64: b = a + 1
            infinite (b <= num_q) {
                  route {
                        q_r[b] < q_r[a] ==> {
                              mut as int64: tr = q_r[a]
                              q_r[a] = q_r[b]
                              q_r[b] = tr

                              mut as int64: tl = q_l[a]
                              q_l[a] = q_l[b]
                              q_l[b] = tl

                              mut as int64: tid = q_id[a]
                              q_id[a] = q_id[b]
                              q_id[b] = tid
                        }
                        _ ==> {
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      #L Fase Offline 3: Resposta imediata O(1) por consulta
      mut as list of int64: answers = []
      mut as int64: qi = 1
      infinite (qi <= num_q) {
            mut as int64: l = q_l[qi]
            mut as int64: r = q_r[qi]
            #L prefix tem 0 na posicao 1, entao prefix[r+1] e soma de 1..r e prefix[l] e soma de 1..(l-1)
            mut as int64: ans = prefix[r + 1] - prefix[l]
            answers = listPushBack(answers, ans)
            println("3. Consulta Q" + q_id[qi] + " [" + l + ", " + r + "] respondida em O(1): " + ans)
            qi = qi + 1
      }

      println("4. Respostas do lote processadas com sucesso: " + answers)
      println("Concluido com Sucesso")
}
