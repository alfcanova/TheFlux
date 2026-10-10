#L ============================================================================
#L Algoritmo: Mark-and-Sweep Garbage Collection (McCarthy 1960)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(V + E) na fase Mark + O(Heap) na fase Sweep
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisMarkAndSweep) {
      println("==================================================")
      println("  SciAlgo: Mark-and-Sweep Garbage Collection")
      println("==================================================")

      #L O coletor de lixo Mark-and-Sweep opera em duas fases:
      #L 1. Fase de Marcacao (Mark): Percorre os objetos alcancaveis a partir
      #L    das raizes (roots) ativando o bit marked = 1.
      #L 2. Fase de Varredura (Sweep): Percorre todo o heap linear; objetos
      #L    marcados tem o bit limpo, e objetos nao marcados sao liberados.

      mut as int64: heap_size = 6

      #L Objetos no Heap: 1 a 6
      #L marked: 0 = nao marcado, 1 = marcado
      mut as list of int64: marked = [0, 0, 0, 0, 0, 0]

      #L Topologia do Heap (Arestas de ponteiros):
      #L Raizes: Objeto 1 e Objeto 2
      #L Objeto 1 aponta para Objeto 3
      #L Objetos 4, 5 e 6 sao inalcançaveis (LIXO)
      println("1. Estado Inicial do Heap (6 objetos):")
      println("   Raizes do Sistema: [Obj 1, Obj 2]")
      println("   Grafo: Obj 1 -> Obj 3")
      println("   Objetos 4, 5 e 6 nao possuem referencias a partir das raizes.")

      #L ======================================================================
      #L Fase 1: Marcacao (Mark Phase)
      #L ======================================================================
      println("==================================================")
      println("2. [Fase 1: Marcacao (Mark Phase)]:")

      #L Marca raizes
      marked[1] = 1
      println("   -> Marcando Raiz: Objeto 1")
      marked[2] = 1
      println("   -> Marcando Raiz: Objeto 2")

      #L Percorre referencias de objetos marcados
      route {
            marked[1] == 1 ==> {
                  marked[3] = 1
                  println("   -> Marcando Objeto 3 (alcancavel via Objeto 1)")
            }
            _ ==> {}
      }

      #L ======================================================================
      #L Fase 2: Varredura e Coleta (Sweep Phase)
      #L ======================================================================
      println("==================================================")
      println("3. [Fase 2: Varredura do Heap (Sweep Phase)]:")

      mut as int64: reclaimed_count = 0
      mut as int64: live_count = 0

      mut as int64: obj = 1
      infinite (obj <= heap_size) {
            route {
                  marked[obj] == 1 ==> {
                        live_count = live_count + 1
                        marked[obj] = 0 #L Reseta para o proximo ciclo de GC
                        println("   [Heap Slot " + obj + "] Objeto " + obj + " SOBREVIVEU (bit resetado para 0).")
                  }
                  _ ==> {
                        reclaimed_count = reclaimed_count + 1
                        println("   [Heap Slot " + obj + "] Objeto " + obj + " INALCANCAVEL -> MEMORIA RECICLADA (Coletado)!")
                  }
            }
            obj = obj + 1
      }

      println("==================================================")
      println("4. Resumo da Coleta de Lixo:")
      println("   Objetos Vivos Mantidos: " + live_count)
      println("   Objetos de Lixo Reciclados: " + reclaimed_count)
      println("   Ciclo Mark-and-Sweep Concluido com Exito!")
      println("==================================================")
}
