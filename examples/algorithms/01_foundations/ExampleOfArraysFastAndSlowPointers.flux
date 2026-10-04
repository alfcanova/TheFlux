#L ============================================================================
#L Algoritmo: Fast and Slow Pointers (Ponteiros Rapido e Lento em Arrays)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysFastAndSlowPointers) {
      println("==================================================")
      println("  SciAlgo: Fast and Slow Pointers")
      println("==================================================")

      #L Teste 1: Array de n+1 inteiros com valores em [1..n]
      #L O mapeamento i -> arr[i] contem um ciclo que revela a duplicata
      mut as list of int64: arr1 = [2, 4, 5, 2, 3]
      println("1. Array 1: " + arr1)

      mut as int64: slow1 = arr1[1]
      mut as int64: fast1 = arr1[arr1[1]]

      #L Fase 1: Intersecao dentro do ciclo
      infinite (slow1 != fast1) {
            slow1 = arr1[slow1]
            fast1 = arr1[arr1[fast1]]
      }

      #L Fase 2: Localizar a entrada do ciclo (duplicata)
      mut as int64: ptr1_1 = 1
      mut as int64: ptr2_1 = slow1
      infinite (ptr1_1 != ptr2_1) {
            ptr1_1 = arr1[ptr1_1]
            ptr2_1 = arr1[ptr2_1]
      }
      println("2. Duplicata encontrada: " + ptr1_1)

      #L Comprimento do ciclo
      mut as int64: cycle_node1 = arr1[ptr1_1]
      mut as int64: clen1 = 1
      infinite (cycle_node1 != ptr1_1) {
            cycle_node1 = arr1[cycle_node1]
            clen1 = clen1 + 1
      }
      println("3. Comprimento do ciclo: " + clen1)

      #L Teste 2: Array com duplicata diferente
      mut as list of int64: arr2 = [3, 1, 3, 4, 2]
      println("4. Array 2: " + arr2)

      mut as int64: slow2 = arr2[1]
      mut as int64: fast2 = arr2[arr2[1]]
      infinite (slow2 != fast2) {
            slow2 = arr2[slow2]
            fast2 = arr2[arr2[fast2]]
      }

      mut as int64: ptr1_2 = 1
      mut as int64: ptr2_2 = slow2
      infinite (ptr1_2 != ptr2_2) {
            ptr1_2 = arr2[ptr1_2]
            ptr2_2 = arr2[ptr2_2]
      }
      println("5. Duplicata encontrada: " + ptr1_2)

      mut as int64: cycle_node2 = arr2[ptr1_2]
      mut as int64: clen2 = 1
      infinite (cycle_node2 != ptr1_2) {
            cycle_node2 = arr2[cycle_node2]
            clen2 = clen2 + 1
      }
      println("6. Comprimento do ciclo: " + clen2)
}
