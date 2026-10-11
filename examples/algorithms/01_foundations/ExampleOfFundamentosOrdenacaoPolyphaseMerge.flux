#L ============================================================================
#L Algoritmo: Polyphase Merge Sort (Mesclagem Polifásica com Fitas e Fibonacci)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) tempo | O(1) rebobinamento de fitas | Knuth TAOCP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoPolyphaseMerge) {
      println("==================================================")
      println("  SciAlgo: Polyphase Merge Sort (Fitas de Fibonacci)")
      println("==================================================")

      #L Declarações de variáveis no escopo principal do programa para domínio estrito em LLVM
      mut as int64: p1 = 0
      mut as int64: p2 = 0
      mut as int64: k = 0
      mut as int64: len1 = 0
      mut as int64: len2 = 0
      mut as int64: l_a = 0
      mut as int64: l_b = 0
      mut as int64: m1 = 0

      #L Vetor de entrada particionado em 5 corridas iniciais (Fibonacci: F_4=3 em T1, F_3=2 em T2)
      mut as list of int64: initial_data = [12, 45, 8, 30, 19, 64, 3, 27, 15, 88]
      mut as int64: n = listLength(initial_data)
      println("1. Dados brutos de entrada: " + initial_data)

      #L Inicialização das fitas magnéticas simuladas T1, T2 e T3
      #L Fita 1 recebe 3 corridas de 2 elementos
      mut as list of int64: t1_data = [12, 45, 8, 30, 19, 64]
      mut as list of int64: t1_lens = [2, 2, 2]

      #L Fita 2 recebe 2 corridas de 2 elementos
      mut as list of int64: t2_data = [3, 27, 15, 88]
      mut as list of int64: t2_lens = [2, 2]

      #L Fita 3 inicia vazia (fita de saída da fase 1)
      mut as list of int64: t3_data = []
      mut as list of int64: t3_lens = []

      println("2. Distribuicao inicial nas 3 fitas:")
      println("   Fita 1: " + listLength(t1_lens) + " corridas | " + t1_data)
      println("   Fita 2: " + listLength(t2_lens) + " corridas | " + t2_data)
      println("   Fita 3: " + listLength(t3_lens) + " corridas (vazia)")

      #L ====================================================================
      #L Fase 1: Mescla min(3, 2) = 2 corridas de T1 e T2 para T3
      #L ====================================================================
      m1 = 1
      infinite (m1 <= 2) {
            len1 = t1_lens[1]
            len2 = t2_lens[1]

            #L Remove comprimentos das fitas de entrada
            mut as list of int64: n_l1 = []
            k = 2
            infinite (k <= listLength(t1_lens)) {
                  n_l1 = listPushBack(n_l1, t1_lens[k])
                  k = k + 1
            }
            t1_lens = n_l1

            mut as list of int64: n_l2 = []
            k = 2
            infinite (k <= listLength(t2_lens)) {
                  n_l2 = listPushBack(n_l2, t2_lens[k])
                  k = k + 1
            }
            t2_lens = n_l2

            #L Mescla os elementos
            p1 = 1
            p2 = 1
            infinite ((p1 <= len1) and (p2 <= len2)) {
                  route {
                        t1_data[p1] <= t2_data[p2] ==> {
                              t3_data = listPushBack(t3_data, t1_data[p1])
                              p1 = p1 + 1
                        }
                        _ ==> {
                              t3_data = listPushBack(t3_data, t2_data[p2])
                              p2 = p2 + 1
                        }
                  }
            }
            infinite (p1 <= len1) {
                  t3_data = listPushBack(t3_data, t1_data[p1])
                  p1 = p1 + 1
            }
            infinite (p2 <= len2) {
                  t3_data = listPushBack(t3_data, t2_data[p2])
                  p2 = p2 + 1
            }

            #L Descarta elementos consumidos de T1 e T2
            mut as list of int64: rem_d1 = []
            k = len1 + 1
            infinite (k <= listLength(t1_data)) {
                  rem_d1 = listPushBack(rem_d1, t1_data[k])
                  k = k + 1
            }
            t1_data = rem_d1

            mut as list of int64: rem_d2 = []
            k = len2 + 1
            infinite (k <= listLength(t2_data)) {
                  rem_d2 = listPushBack(rem_d2, t2_data[k])
                  k = k + 1
            }
            t2_data = rem_d2

            t3_lens = listPushBack(t3_lens, len1 + len2)
            m1 = m1 + 1
      }
      println("3. Apos Fase 1: Fita 1 tem " + listLength(t1_lens) + " corridas, Fita 2 vazia, Fita 3 tem " + listLength(t3_lens) + " corridas")

      #L ====================================================================
      #L Fase 2: Mescla min(1, 2) = 1 corrida de T1 e T3 para T2
      #L ====================================================================
      l_a = t1_lens[1]
      l_b = t3_lens[1]
      t1_lens = []
      mut as list of int64: n_l3 = []
      k = 2
      infinite (k <= listLength(t3_lens)) {
            n_l3 = listPushBack(n_l3, t3_lens[k])
            k = k + 1
      }
      t3_lens = n_l3

      p1 = 1
      p2 = 1
      infinite ((p1 <= l_a) and (p2 <= l_b)) {
            route {
                  t1_data[p1] <= t3_data[p2] ==> {
                        t2_data = listPushBack(t2_data, t1_data[p1])
                        p1 = p1 + 1
                  }
                  _ ==> {
                        t2_data = listPushBack(t2_data, t3_data[p2])
                        p2 = p2 + 1
                  }
            }
      }
      infinite (p1 <= l_a) {
            t2_data = listPushBack(t2_data, t1_data[p1])
            p1 = p1 + 1
      }
      infinite (p2 <= l_b) {
            t2_data = listPushBack(t2_data, t3_data[p2])
            p2 = p2 + 1
      }

      t1_data = []
      mut as list of int64: rem_d3 = []
      k = l_b + 1
      infinite (k <= listLength(t3_data)) {
            rem_d3 = listPushBack(rem_d3, t3_data[k])
            k = k + 1
      }
      t3_data = rem_d3
      t2_lens = listPushBack(t2_lens, l_a + l_b)

      println("4. Apos Fase 2: Fita 1 vazia, Fita 2 tem " + listLength(t2_lens) + " corrida, Fita 3 tem " + listLength(t3_lens) + " corrida")

      #L ====================================================================
      #L Fase 3: Mescla 1 corrida de T2 e T3 para T1 (resultado final)
      #L ====================================================================
      l_a = t2_lens[1]
      l_b = t3_lens[1]
      t2_lens = []
      t3_lens = []

      p1 = 1
      p2 = 1
      infinite ((p1 <= l_a) and (p2 <= l_b)) {
            route {
                  t2_data[p1] <= t3_data[p2] ==> {
                        t1_data = listPushBack(t1_data, t2_data[p1])
                        p1 = p1 + 1
                  }
                  _ ==> {
                        t1_data = listPushBack(t1_data, t3_data[p2])
                        p2 = p2 + 1
                  }
            }
      }
      infinite (p1 <= l_a) {
            t1_data = listPushBack(t1_data, t2_data[p1])
            p1 = p1 + 1
      }
      infinite (p2 <= l_b) {
            t1_data = listPushBack(t1_data, t3_data[p2])
            p2 = p2 + 1
      }

      println("5. Fita 1 final consolidada e totalmente ordenada: " + t1_data)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  t1_data[vi] > t1_data[vi + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            vi = vi + 1
      }
      println("6. Validacao de ordenacao polifasica: " + sorted_ok)
      println("==================================================")
}
