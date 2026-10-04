#L ============================================================================
#L Algoritmo: Floyd Random Sampling (Amostragem Aleatoria de Robert Floyd)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(M) tempo | O(M) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysFloydRandomSampling) {
      println("==================================================")
      println("  SciAlgo: Floyd Random Sampling")
      println("==================================================")

      #L Sorteio de M = 5 inteiros distintos no universo 1..N = 20
      mut as int64: n = 20
      mut as int64: m = 5
      println("1. Parametros: Universo N = " + n + " | Tamanho da amostra M = " + m)

      #L Tabela de presenca (1..N) para busca O(1) de pertinencia
      mut as list of int64: present = []
      mut as int64: p = 1
      infinite (p <= n) {
            present = listPushBack(present, 0)
            p = p + 1
      }

      mut as list of int64: sample = []
      mut as int64: rng = 543210987

      #L Algoritmo de Floyd: J varia de N - M + 1 ate N
      mut as int64: j = n - m + 1
      infinite (j <= n) {
            rng = (rng * 1103515245 + 12345) /r 2147483647
            route {
                  rng < 0 ==> {
                        rng = rng + 2147483647
                  }
                  _ ==> {
                  }
            }

            #L Sorteia T no intervalo [1..J]
            mut as int64: t = (rng /r j) + 1

            route {
                  present[t] == 0 ==> {
                        present[t] = 1
                        sample = listPushBack(sample, t)
                  }
                  _ ==> {
                        present[j] = 1
                        sample = listPushBack(sample, j)
                  }
            }
            j = j + 1
      }

      println("2. Amostra obtida por Floyd: " + sample)
      println("3. Total de elementos amostrados: " + listLength(sample))

      #L Ordenacao da amostra para exibicao estruturada
      mut as int64: s_len = listLength(sample)
      mut as int64: a = 1
      infinite (a <= s_len) {
            mut as int64: b = a + 1
            infinite (b <= s_len) {
                  route {
                        sample[b] < sample[a] ==> {
                              mut as int64: tmp = sample[a]
                              sample[a] = sample[b]
                              sample[b] = tmp
                        }
                        _ ==> {
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }
      println("4. Amostra ordenada: " + sample)
}
