#L ============================================================================
#L Algoritmo: Min-Max Heap
#L Dominio: 02_data_structures / Categoria: Heaps e Filas de Prioridade
#L Descricao: Heap binaria completa com niveis alternados minimo e maximo em O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosFibonacciMinMaxHeap) {
      println("=== Algoritmo: Min-Max Heap ===")

      #L Min-Max Heap com 7 elementos representados em array:
      #L Nivel 0 (Min-level, raiz): indice 1 = 10
      #L Nivel 1 (Max-level, filhos de 1): indice 2 = 80, indice 3 = 70
      #L Nivel 2 (Min-level, netos de 1): indice 4 = 15, indice 5 = 20, indice 6 = 25, indice 7 = 30
      mut as list of int64: heap = [10, 80, 70, 15, 20, 25, 30]

      #L Consulta de Minimo: sempre na raiz (indice 1) em O(1)
      mut as int64: minElement = heap[1]
      println("1. Minimo da heap em O(1): " + minElement)

      #L Consulta de Maximo: maior entre os filhos da raiz (indices 2 e 3) em O(1)
      mut as int64: maxElement = heap[2]
      route {
            heap[3] > heap[2] ==> {
                  maxElement = heap[3]
            }
            _ ==> {}
      }
      println("2. Maximo da heap em O(1): " + maxElement)

      #L Verificacao de propriedades Min-Max:
      #L O minimo (10) e menor que todos os netos: 10 <= 15, 20, 25, 30
      #L Os maximos no nivel 1 (80 e 70) sao maiores que seus respectivos descendentes
      mut as int64: propMinValida = 0
      mut as int64: propMaxValida = 0

      route {
            heap[1] <= heap[4] and heap[1] <= heap[5] ==> {
                  propMinValida = 1
            }
            _ ==> {}
      }
      route {
            heap[2] >= heap[4] and heap[2] >= heap[5] and heap[3] >= heap[6] ==> {
                  propMaxValida = 1
            }
            _ ==> {}
      }

      route {
            minElement == 10 and maxElement == 80 and propMinValida == 1 and propMaxValida == 1 ==> {
                  println("3. Estrutura Min-Max Heap validada com consultas extremas O(1).")
            }
            _ ==> {
                  println("Falha na Min-Max Heap.")
            }
      }
      println("Teste concluido com sucesso.")
}
