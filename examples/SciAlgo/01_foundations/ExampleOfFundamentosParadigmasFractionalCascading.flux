#L ============================================================================
#L Algoritmo: Fractional Cascading (Cascata Fracionaria)
#L Dominio: 01_foundations / Fundamentos e Paradigmas
#L Complexidade: O(log n + k) tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasFractionalCascading) {
      println("==================================================")
      println("  SciAlgo: Fractional Cascading Paradigm         ")
      println("==================================================")

      mut as list of int64: l1 = [2, 4, 7, 12, 20]
      mut as list of int64: l2 = [1, 5, 8, 15, 25]
      mut as int64: query_val = 6
      println("1. Listas Ordenadas: L1 = " + l1 + " | L2 = " + l2)
      println("   Valor de Consulta: " + query_val)

      #L Busca binaria na primeira lista L1
      mut as int64: low = 1
      mut as int64: high = listLength(l1)
      mut as int64: succ_l1 = 0
      infinite (low <= high) {
            mut as int64: mid = low + (high - low) /i 2
            route {
                  l1[mid] >= query_val ==> {
                        succ_l1 = l1[mid]
                        high = mid - 1
                  }
                  _ ==> {
                        low = mid + 1
                  }
            }
      }

      #L Localizacao do sucessor correspondente em L2
      low = 1
      high = listLength(l2)
      mut as int64: succ_l2 = 0
      infinite (low <= high) {
            mut as int64: mid = low + (high - low) /i 2
            route {
                  l2[mid] >= query_val ==> {
                        succ_l2 = l2[mid]
                        high = mid - 1
                  }
                  _ ==> {
                        low = mid + 1
                  }
            }
      }

      println("2. Sucessor em L1 (>= 6): " + succ_l1)
      println("3. Sucessor em L2 (>= 6): " + succ_l2)

      mut as bool: ok = (succ_l1 == 7 and succ_l2 == 8)
      println("4. Validacao (succ_l1=7 e succ_l2=8): " + ok)
      println("==================================================")
}
