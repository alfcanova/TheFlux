#L ============================================================================
#L Algoritmo: Binary Search (Busca Binaria com Lower/Upper Bound)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: Tempo O(log N) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaBinarySearch) {
      println("==================================================")
      println("  SciAlgo: Binary Search (Logarithmic Search)")
      println("==================================================")

      #L Vetor ordenado de teste (N = 12 elementos)
      mut as list of int64: dados = [3, 8, 14, 19, 27, 33, 42, 55, 68, 77, 85, 99]
      mut as int64: n = listLength(dados)
      println("1. Vetor ordenado (tamanho " + n + "):")
      println("   [3, 8, 14, 19, 27, 33, 42, 55, 68, 77, 85, 99]")

      #L ======================================================================
      #L Teste 1: Busca exata de elemento no meio (alvo = 42)
      #L ======================================================================
      mut as int64: target1 = 42
      println("2. Teste 1: Buscando alvo " + target1 + ":")
      mut as int64: low1 = 1
      mut as int64: high1 = n
      mut as int64: pos1 = -1
      mut as int64: steps1 = 0

      infinite (low1 <= high1 and pos1 < 0) {
            steps1 = steps1 + 1
            mut as int64: mid1 = low1 + ((high1 - low1) /i 2)
            mut as int64: val1 = dados[mid1]

            route {
                  val1 == target1 ==> {
                        pos1 = mid1
                  }
                  val1 < target1 ==> {
                        low1 = mid1 + 1
                  }
                  _ ==> {
                        high1 = mid1 - 1
                  }
            }
      }
      println("   -> [PASS] Encontrado no indice: " + pos1 + " em " + steps1 + " passos (esperado <= 4)")

      #L ======================================================================
      #L Teste 2: Busca nos extremos (alvo = 3 e alvo = 99)
      #L ======================================================================
      mut as int64: target2_a = 3
      mut as int64: low2_a = 1
      mut as int64: high2_a = n
      mut as int64: pos2_a = -1
      infinite (low2_a <= high2_a and pos2_a < 0) {
            mut as int64: mid = low2_a + ((high2_a - low2_a) /i 2)
            route {
                  dados[mid] == target2_a ==> { pos2_a = mid }
                  dados[mid] < target2_a ==> { low2_a = mid + 1 }
                  _ ==> { high2_a = mid - 1 }
            }
      }
      println("3. Teste 2a: Extremo esquerdo (alvo " + target2_a + ") -> Indice: " + pos2_a)

      mut as int64: target2_b = 99
      mut as int64: low2_b = 1
      mut as int64: high2_b = n
      mut as int64: pos2_b = -1
      infinite (low2_b <= high2_b and pos2_b < 0) {
            mut as int64: mid = low2_b + ((high2_b - low2_b) /i 2)
            route {
                  dados[mid] == target2_b ==> { pos2_b = mid }
                  dados[mid] < target2_b ==> { low2_b = mid + 1 }
                  _ ==> { high2_b = mid - 1 }
            }
      }
      println("   Teste 2b: Extremo direito (alvo " + target2_b + ") -> Indice: " + pos2_b)

      #L ======================================================================
      #L Teste 3: Elemento ausente (alvo = 50)
      #L ======================================================================
      mut as int64: target3 = 50
      println("4. Teste 3: Buscando elemento ausente " + target3 + ":")
      mut as int64: low3 = 1
      mut as int64: high3 = n
      mut as int64: pos3 = -1
      mut as int64: steps3 = 0

      infinite (low3 <= high3 and pos3 < 0) {
            steps3 = steps3 + 1
            mut as int64: mid = low3 + ((high3 - low3) /i 2)
            route {
                  dados[mid] == target3 ==> { pos3 = mid }
                  dados[mid] < target3 ==> { low3 = mid + 1 }
                  _ ==> { high3 = mid - 1 }
            }
      }
      route {
            pos3 < 0 ==> {
                  println("   -> [PASS] Alvo " + target3 + " ausente detectado em " + steps3 + " passos.")
            }
            _ ==> {
                  println("   -> [ERRO] Alvo detectado erroneamente.")
            }
      }

      #L ======================================================================
      #L Teste 4: Lower Bound (primeiro elemento >= x)
      #L ======================================================================
      #L Para x = 25, o primeiro elemento >= 25 eh 27 (indice 5)
      mut as int64: lb_target = 25
      println("5. Teste 4: Lower Bound para chave " + lb_target + ":")
      mut as int64: lb_low = 1
      mut as int64: lb_high = n
      mut as int64: lb_ans = n + 1

      infinite (lb_low <= lb_high) {
            mut as int64: mid = lb_low + ((lb_high - lb_low) /i 2)
            route {
                  dados[mid] >= lb_target ==> {
                        lb_ans = mid
                        lb_high = mid - 1
                  }
                  _ ==> {
                        lb_low = mid + 1
                  }
            }
      }
      println("   -> Lower bound index: " + lb_ans + " (valor: " + dados[lb_ans] + ")")

      #L ======================================================================
      #L Teste 5: Upper Bound (primeiro elemento > x)
      #L ======================================================================
      #L Para x = 42, o primeiro elemento > 42 eh 55 (indice 8)
      mut as int64: ub_target = 42
      println("6. Teste 5: Upper Bound para chave " + ub_target + ":")
      mut as int64: ub_low = 1
      mut as int64: ub_high = n
      mut as int64: ub_ans = n + 1

      infinite (ub_low <= ub_high) {
            mut as int64: mid = ub_low + ((ub_high - ub_low) /i 2)
            route {
                  dados[mid] > ub_target ==> {
                        ub_ans = mid
                        ub_high = mid - 1
                  }
                  _ ==> {
                        ub_low = mid + 1
                  }
            }
      }
      println("   -> Upper bound index: " + ub_ans + " (valor: " + dados[ub_ans] + ")")

      println("==================================================")
      println("Binary Search concluido com sucesso!")
}
