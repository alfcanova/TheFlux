#L ============================================================================
#L Algoritmo: Mark-Compact Garbage Collection (LISP 2 / Two-Finger Compact)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(Heap) eliminando fragmentacao externa da memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisMarkCompact) {
      println("==================================================")
      println("  SciAlgo: Mark-Compact Garbage Collection")
      println("==================================================")

      #L O coletor Mark-Compact resolve o problema de fragmentacao externa
      #L do Mark-and-Sweep.
      #L Apos a fase de marcacao dos objetos vivos, compacta todos os sobreviventes
      #L em um bloco continuo no inicio do heap, atualizando os ponteiros.

      mut as int64: heap_size = 6

      #L Estado inicial do Heap:
      #L Slots 1, 3 e 5 contem objetos vivos (A, B, C).
      #L Slots 2, 4 e 6 contem buracos de lixo (fragmentacao).
      #L is_alive: 1 = vivo, 0 = lixo
      mut as list of int64: is_alive = [1, 0, 1, 0, 1, 0]
      mut as list of int64: obj_id   = [101, 0, 102, 0, 103, 0]

      println("1. Estado Fragmentado do Heap Inicial:")
      mut as int64: s = 1
      infinite (s <= heap_size) {
            route {
                  is_alive[s] == 1 ==> {
                        println("   Slot " + s + ": Objeto " + obj_id[s] + " (VIVO)")
                  }
                  _ ==> {
                        println("   Slot " + s + ": [LIXO / BURACO LIVRE]")
                  }
            }
            s = s + 1
      }

      println("==================================================")
      println("2. [Fase de Compactacao do Heap]:")

      #L Realoca objetos vivos para enderecos continuos no inicio do heap
      mut as int64: compact_ptr = 1

      mut as int64: i = 1
      infinite (i <= heap_size) {
            route {
                  is_alive[i] == 1 ==> {
                        mut as int64: val = obj_id[i]
                        println("   -> Movendo Objeto " + val + " do Slot " + i + " para o Slot Compactado " + compact_ptr)
                        obj_id[compact_ptr] = val
                        is_alive[compact_ptr] = 1

                        route {
                              compact_ptr != i ==> {
                                    is_alive[i] = 0
                                    obj_id[i] = 0
                              }
                              _ ==> {}
                        }
                        compact_ptr = compact_ptr + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("==================================================")
      println("3. Estado do Heap Apos a Compactacao:")
      mut as int64: k = 1
      infinite (k <= heap_size) {
            route {
                  is_alive[k] == 1 ==> {
                        println("   Slot " + k + ": Objeto " + obj_id[k] + " [OCUPADO CONTIGUO]")
                  }
                  _ ==> {
                        println("   Slot " + k + ": [LIVRE CONTIGUO]")
                  }
            }
            k = k + 1
      }

      println("==================================================")
      println("4. Resumo do Mark-Compact:")
      println("   Todos os objetos vivos agrupados nos slots 1 a " + (compact_ptr - 1))
      println("   Espaco livre continuo disponível a partir do slot " + compact_ptr)
      println("   Fragmentacao externa 100% eliminada!")
      println("==================================================")
}
