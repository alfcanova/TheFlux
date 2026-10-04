#L ============================================================================
#L Algoritmo: Two-Pointer Technique (Tecnica de Dois Ponteiros)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysTwoPointer) {
      println("==================================================")
      println("  SciAlgo: Two-Pointer Technique")
      println("==================================================")

      mut as list of int64: arr = [2, 3, 5, 8, 11, 15, 18]
      mut as int64: n = listLength(arr)
      println("1. Array ordenado (tamanho " + n + "): " + arr)

      #L Caso 1: Buscar par com soma alvo = 19
      mut as int64: target1 = 19
      mut as int64: left1 = 1
      mut as int64: right1 = n
      mut as bool: found1 = false
      mut as int64: idx_l1 = 0
      mut as int64: idx_r1 = 0

      infinite (left1 < right1 and not found1) {
            mut as int64: sum1 = arr[left1] + arr[right1]
            route {
                  sum1 == target1 ==> {
                        found1 = true
                        idx_l1 = left1
                        idx_r1 = right1
                  }
                  sum1 < target1 ==> {
                        left1 = left1 + 1
                  }
                  _ ==> {
                        right1 = right1 - 1
                  }
            }
      }

      route {
            found1 ==> {
                  println("2. Alvo 19: encontrado nos indices " + idx_l1 + " e " + idx_r1 + " (" + arr[idx_l1] + " + " + arr[idx_r1] + " = 19)")
            }
            _ ==> {
                  println("2. Alvo 19: nao encontrado")
            }
      }

      #L Caso 2: Buscar par com soma alvo = 14
      mut as int64: target2 = 14
      mut as int64: left2 = 1
      mut as int64: right2 = n
      mut as bool: found2 = false
      mut as int64: idx_l2 = 0
      mut as int64: idx_r2 = 0

      infinite (left2 < right2 and not found2) {
            mut as int64: sum2 = arr[left2] + arr[right2]
            route {
                  sum2 == target2 ==> {
                        found2 = true
                        idx_l2 = left2
                        idx_r2 = right2
                  }
                  sum2 < target2 ==> {
                        left2 = left2 + 1
                  }
                  _ ==> {
                        right2 = right2 - 1
                  }
            }
      }

      route {
            found2 ==> {
                  println("3. Alvo 14: encontrado nos indices " + idx_l2 + " e " + idx_r2 + " (" + arr[idx_l2] + " + " + arr[idx_r2] + " = 14)")
            }
            _ ==> {
                  println("3. Alvo 14: nao encontrado")
            }
      }

      #L Caso 3: Buscar par com soma alvo = 50 (inexistente)
      mut as int64: target3 = 50
      mut as int64: left3 = 1
      mut as int64: right3 = n
      mut as bool: found3 = false

      infinite (left3 < right3 and not found3) {
            mut as int64: sum3 = arr[left3] + arr[right3]
            route {
                  sum3 == target3 ==> {
                        found3 = true
                  }
                  sum3 < target3 ==> {
                        left3 = left3 + 1
                  }
                  _ ==> {
                        right3 = right3 - 1
                  }
            }
      }

      route {
            found3 ==> {
                  println("4. Alvo 50: encontrado")
            }
            _ ==> {
                  println("4. Alvo 50: nao encontrado (correto)")
            }
      }
}
