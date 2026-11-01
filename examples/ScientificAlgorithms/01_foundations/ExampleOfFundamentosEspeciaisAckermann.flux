#L ============================================================================
#L Algoritmo: Ackermann Function (Funcao de Ackermann com Pilha Explicita)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: Crescimento hiper-exponencial / nao primitivo recursivo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisAckermann) {
      println("==================================================")
      println("  SciAlgo: Ackermann Function (Iterative Stack)")
      println("==================================================")

      #L Calculo de A(2, 3) = 2*3 + 3 = 9
      mut as list of int64: stack1 = [2]
      mut as int64: n1 = 3
      mut as int64: steps1 = 0

      infinite (listLength(stack1) > 0) {
            steps1 = steps1 + 1
            mut as int64: top_idx = listLength(stack1)
            mut as int64: m = stack1[top_idx]

            #L Desempilha
            mut as list of int64: n_st = []
            mut as int64: si = 1
            infinite (si < top_idx) {
                  n_st = listPushBack(n_st, stack1[si])
                  si = si + 1
            }
            stack1 = n_st

            route {
                  m == 0 ==> {
                        n1 = n1 + 1
                  }
                  n1 == 0 ==> {
                        stack1 = listPushBack(stack1, m - 1)
                        n1 = 1
                  }
                  _ ==> {
                        stack1 = listPushBack(stack1, m - 1)
                        stack1 = listPushBack(stack1, m)
                        n1 = n1 - 1
                  }
            }
      }

      println("1. A(2, 3) calculado com pilha: " + n1 + " (passos: " + steps1 + ")")

      #L Calculo de A(3, 1) = 2^(1+3) - 3 = 16 - 3 = 13
      mut as list of int64: stack2 = [3]
      mut as int64: n2 = 1
      mut as int64: steps2 = 0

      infinite (listLength(stack2) > 0) {
            steps2 = steps2 + 1
            mut as int64: t_idx = listLength(stack2)
            mut as int64: m2 = stack2[t_idx]

            mut as list of int64: n_st2 = []
            mut as int64: si2 = 1
            infinite (si2 < t_idx) {
                  n_st2 = listPushBack(n_st2, stack2[si2])
                  si2 = si2 + 1
            }
            stack2 = n_st2

            route {
                  m2 == 0 ==> {
                        n2 = n2 + 1
                  }
                  n2 == 0 ==> {
                        stack2 = listPushBack(stack2, m2 - 1)
                        n2 = 1
                  }
                  _ ==> {
                        stack2 = listPushBack(stack2, m2 - 1)
                        stack2 = listPushBack(stack2, m2)
                        n2 = n2 - 1
                  }
            }
      }

      println("2. A(3, 1) calculado com pilha: " + n2 + " (passos: " + steps2 + ")")
      println("3. Validacao: " + (n1 == 9 and n2 == 13))
      println("==================================================")
}
