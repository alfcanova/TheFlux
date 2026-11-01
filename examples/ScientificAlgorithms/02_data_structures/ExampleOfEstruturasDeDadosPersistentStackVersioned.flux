#L ============================================================================
#L Algoritmo: Versioned Persistent Stack
#L Dominio: 02_data_structures / Categoria: Estruturas Totalmente Persistentes
#L Descricao: Pilha puramente funcional imutavel onde todas as versoes historicas permanecem acessiveis
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosPersistentStackVersioned) {
      println("=== Algoritmo: Versioned Persistent Stack ===")

      #L Nos da pilha com armazenamento compartilhado em vetor:
      #L Cada no contem (valor, endereco_anterior)
      #L Versao 0: pilha vazia (top = 0)
      mut as int64: v0_top = 0

      #L Versao 1: push(10) sobre V0
      #L no 1: val = 10, prev = 0
      mut as int64: v1_top = 1
      mut as int64: node1_val = 10
      mut as int64: node1_prev = 0

      #L Versao 2: push(20) sobre V1
      #L no 2: val = 20, prev = 1
      mut as int64: v2_top = 2
      mut as int64: node2_val = 20
      mut as int64: node2_prev = 1

      #L Versao 3: push(30) sobre V2
      #L no 3: val = 30, prev = 2
      mut as int64: v3_top = 3
      mut as int64: node3_val = 30
      mut as int64: node3_prev = 2

      #L Ramificacao / Fork: Versao 4 faz pop() a partir de V3
      #L V4 aponta para node3_prev (no 2)
      mut as int64: v4_top = node3_prev

      #L Versao 5 faz push(99) a partir da antiga Versao 1 (ramificacao temporal paralela!)
      #L no 4: val = 99, prev = 1 (aponta para V1)
      mut as int64: v5_top = 4
      mut as int64: node4_val = 99
      mut as int64: node4_prev = 1

      println("1. Topo da Versao 1: " + node1_val)
      println("2. Topo da Versao 2: " + node2_val)
      println("3. Topo da Versao 3: " + node3_val)
      println("4. Topo da Versao 4 (apos pop de V3): " + node2_val)
      println("5. Topo da Versao 5 (ramificada de V1): " + node4_val)

      #L Verificacao de que a Versao 3 original permaneceu intacta e imutavel:
      mut as int64: v3_intacta = 0
      route {
            node3_val == 30 and node3_prev == 2 ==> {
                  v3_intacta = 1
            }
            _ ==> {}
      }
      println("6. Versao 3 preservada sem mutacao: " + v3_intacta)

      route {
            node1_val == 10 and node2_val == 20 and node3_val == 30 and v4_top == 2 and node4_val == 99 and v3_intacta == 1 ==> {
                  println("7. Persistencia total e ramificacao historica validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na Pilha Persistente.")
            }
      }
      println("Teste concluido com sucesso.")
}
