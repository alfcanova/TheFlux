#L ============================================================================
#L Algoritmo: XOR Doubly Linked List
#L Dominio: 02_data_structures / Categoria: Listas Compactas
#L Descricao: Lista duplamente encadeada com economia de 50% de ponteiros via campo npx = prev XOR next
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosXorDoublyLinkedList) {
      println("=== Algoritmo: XOR Doubly Linked List ===")

      #L Sequencia de 3 nos com enderecos virtuais:
      #L No A: endereco 10, valor 100
      #L No B: endereco 20, valor 200
      #L No C: endereco 30, valor 300

      #L Campos npx = (prev XOR next):
      #L No A (primeiro no, prev = 0):
      #L npx_A = 0 ^ 20 = 20
      mut as int64: npx_A = 0 ^ 20

      #L No B (no do meio, prev = 10, next = 30):
      #L npx_B = 10 ^ 30 = 20
      mut as int64: npx_B = 10 ^ 30

      #L No C (ultimo no, prev = 20, next = 0):
      #L npx_C = 20 ^ 0 = 20
      mut as int64: npx_C = 20 ^ 0

      println("1. Campo npx do No A (0 ^ 20): " + npx_A)
      println("2. Campo npx do No B (10 ^ 30): " + npx_B)
      println("3. Campo npx do No C (20 ^ 0): " + npx_C)

      #L Percurso para frente (Forward Traversal):
      #L Comeca em A (end 10) com prev = 0:
      #L proximo de A = npx_A ^ 0 = 20 ^ 0 = 20 (endereco do No B!)
      mut as int64: next_A = npx_A ^ 0

      #L No B (end 20), vindo de A (prev = 10):
      #L proximo de B = npx_B ^ 10 = (10 ^ 30) ^ 10 = 30 (endereco do No C!)
      mut as int64: next_B = npx_B ^ 10

      println("4. No alcancado a partir de A: endereco " + next_A)
      println("5. No alcancado a partir de B: endereco " + next_B)

      route {
            next_A == 20 and next_B == 30 ==> {
                  println("6. Percurso bidirecional com campo unico XOR validado com sucesso.")
            }
            _ ==> {
                  println("Falha na XOR Linked List.")
            }
      }
      println("Teste concluido com sucesso.")
}
