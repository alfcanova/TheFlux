#L ============================================================================
#L Algoritmo: Cheney's Non-Recursive Copying Garbage Collection (1970)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(Live) proporcional apenas ao volume de objetos vivos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisCheneysAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Cheney's Copying Garbage Collection")
      println("==================================================")

      #L O coletor de Cheney (1970) divide a memoria em dois semi-espacos:
      #L From-Space (onde os objetos sao alocados) e To-Space (para onde sao copiados).
      #L Utiliza dois ponteiros (scan e free) para realizar travessia em largura (BFS)
      #L sem recursao e sem pilha auxiliar.
      #L Complexidade: O(Vivos), ignorando completamente os objetos mortos!

      #L Semi-espaco de Origem (From-Space):
      #L Objetos: 1 = Raiz A (aponta para B), 2 = Objeto B, 3 = Lixo C, 4 = Lixo D
      mut as list of int64: from_space = [10, 20, 99, 88]

      #L Semi-espaco de Destino (To-Space - capacidade 4 slots):
      mut as list of int64: to_space = [0, 0, 0, 0]
      mut as int64: scan_ptr = 1
      mut as int64: free_ptr = 1

      println("1. Estado Inicial dos Semi-Espacos:")
      println("   From-Space: [Obj A=10, Obj B=20, Lixo C=99, Lixo D=88]")
      println("   To-Space:   [Vazio]")

      println("==================================================")
      println("2. [Copia das Raizes para o To-Space]:")

      #L Copia Raiz A para o To-Space
      to_space[free_ptr] = from_space[1]
      println("   -> Raiz A (" + from_space[1] + ") copiada para To-Space[" + free_ptr + "]")
      free_ptr = free_ptr + 1

      println("==================================================")
      println("3. [Varredura BFS com Ponteiro Scan (scan < free)]:")

      #L Enquanto scan_ptr < free_ptr, examina campos do objeto sob scan_ptr
      infinite (scan_ptr < free_ptr) {
            mut as int64: cur_obj = to_space[scan_ptr]
            println("   Varrendo To-Space[" + scan_ptr + "] (Objeto " + cur_obj + "):")

            route {
                  cur_obj == 10 ==> {
                        #L Objeto A aponta para Objeto B (20)
                        println("      -> Referencia encontrada para Objeto B (" + from_space[2] + "). Copiando para To-Space[" + free_ptr + "]...")
                        to_space[free_ptr] = from_space[2]
                        free_ptr = free_ptr + 1
                  }
                  _ ==> {}
            }
            scan_ptr = scan_ptr + 1
      }

      println("   Varredura concluida: scan_ptr atingiu free_ptr (" + scan_ptr + " == " + free_ptr + ").")

      println("==================================================")
      println("4. [Flip dos Semi-Espacos]:")
      println("   Invertendo espacos: To-Space passa a ser a memoria ativa.")
      println("   Conteudo do Novo Espaco Ativo:")
      println("   -> Slot 1: " + to_space[1] + " (Objeto A)")
      println("   -> Slot 2: " + to_space[2] + " (Objeto B)")
      println("   From-Space antigo (com lixos 99 e 88) descartado instantaneamente!")
      println("==================================================")
}
