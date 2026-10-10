#L ============================================================================
#L Algoritmo: Reference Counting Garbage Collection (Collins 1960)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) deterministico na desalocacao imediata quando RC = 0
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisReferenceCounting) {
      println("==================================================")
      println("  SciAlgo: Reference Counting Memory Management")
      println("==================================================")

      #L O Gerenciamento por Contagem de Referencias (Collins 1960) rastreia
      #L o numero de ponteiros ativos para cada objeto.
      #L Vantagem: Desalocacao deterministica e imediata quando o contador zera (RC = 0).
      #L Limitacao: Incapacidade de coletar ciclos de referencias isolados sem auxilio.

      mut as int64: num_objs = 3
      #L Objetos: 1 = Node_A, 2 = Node_B, 3 = Node_C
      mut as list of int64: ref_count = [0, 0, 0]
      mut as list of int64: is_allocated = [0, 0, 0]

      println("1. [Criacao de Objetos e Vinculacao de Ponteiros]:")

      #L Ponteiro raiz p1 referencia Node_A
      is_allocated[1] = 1
      ref_count[1] = ref_count[1] + 1
      println("   -> Criado Node_A (Raiz p1 aponta para A) | RC(A) = " + ref_count[1])

      #L Node_A aponta para Node_B
      is_allocated[2] = 1
      ref_count[2] = ref_count[2] + 1
      println("   -> Node_A cria ponteiro para Node_B | RC(B) = " + ref_count[2])

      #L Ponteiro raiz p2 tambem aponta para Node_B
      ref_count[2] = ref_count[2] + 1
      println("   -> Raiz p2 aponta para Node_B | RC(B) = " + ref_count[2])

      println("==================================================")
      println("2. [Remocao de Referencia de p2 para Node_B]:")
      ref_count[2] = ref_count[2] - 1
      println("   -> p2 deixa de apontar para B. RC(B) decrementado para " + ref_count[2] + " (Ainda vivo, pois A aponta para B)")

      println("==================================================")
      println("3. [Desalocacao em Cascata (Cascading Free)]: ")
      println("   Raiz p1 e anulada (p1 = null)...")
      ref_count[1] = ref_count[1] - 1
      println("   -> RC(A) caiu para " + ref_count[1] + " (ZERO)!")

      route {
            ref_count[1] == 0 ==> {
                  is_allocated[1] = 0
                  println("   -> [DEALOCACAO IMEDIATA] Node_A liberado!")
                  println("   -> Como A foi destruido, remove seu ponteiro para B:")
                  ref_count[2] = ref_count[2] - 1
                  println("      RC(B) caiu para " + ref_count[2] + " (ZERO)!")

                  route {
                        ref_count[2] == 0 ==> {
                              is_allocated[2] = 0
                              println("      -> [DEALOCACAO EM CASCATA] Node_B liberado imediatamente!")
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      println("==================================================")
      println("4. Resumo de Reference Counting:")
      println("   Status Node_A: Alocado = " + is_allocated[1] + " (RC = " + ref_count[1] + ")")
      println("   Status Node_B: Alocado = " + is_allocated[2] + " (RC = " + ref_count[2] + ")")
      println("   Liberacao deterministica em cascata executada com exito!")
      println("==================================================")
}
