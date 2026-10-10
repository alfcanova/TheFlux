#L ============================================================================
#L Algoritmo: First-In, First-Out (FIFO) Page Replacement
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) substituicao com fila circular de ponteiro FIFO
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisFIFOPageReplacement) {
      println("==================================================")
      println("  SciAlgo: FIFO Page Replacement Algorithm")
      println("==================================================")

      #L O algoritmo FIFO substitui a pagina que foi carregada ha mais tempo
      #L na memoria, independentemente de quantas vezes foi acessada.
      #L E implementado atraves de um ponteiro circular sobre os quadros fisicos.

      mut as int64: num_frames = 3
      mut as list of int64: frames = [-1, -1, -1]
      mut as int64: fifo_ptr = 1

      mut as int64: num_refs = 10
      mut as list of int64: refs = [7, 0, 1, 2, 0, 3, 0, 4, 2, 3]

      println("1. Parametros:")
      println("   Numero de Quadros: " + num_frames)
      println("   Sequencia de Acessos: [7, 0, 1, 2, 0, 3, 0, 4, 2, 3]")

      println("==================================================")
      println("2. [Simulacao do FIFO de Paginas]:")

      mut as int64: page_faults = 0
      mut as int64: page_hits = 0

      mut as int64: t = 1
      infinite (t <= num_refs) {
            mut as int64: page = refs[t]
            mut as int64: is_hit = 0

            #L Verifica se a pagina ja reside na memoria
            mut as int64: f = 1
            infinite (f <= num_frames) {
                  route {
                        frames[f] == page ==> { is_hit = 1 }
                        _ ==> {}
                  }
                  f = f + 1
            }

            route {
                  is_hit == 1 ==> {
                        page_hits = page_hits + 1
                        println("   [Acesso " + t + "] Pagina " + page + " -> HIT!")
                  }
                  _ ==> {
                        page_faults = page_faults + 1
                        mut as int64: old_page = frames[fifo_ptr]
                        frames[fifo_ptr] = page

                        route {
                              old_page == -1 ==> {
                                    println("   [Acesso " + t + "] Pagina " + page + " -> FAULT! Alocada no Quadro " + fifo_ptr)
                              }
                              _ ==> {
                                    println("   [Acesso " + t + "] Pagina " + page + " -> FAULT! Substitui Pagina " + old_page + " no Quadro " + fifo_ptr)
                              }
                        }

                        #L Avanca ponteiro circular FIFO
                        fifo_ptr = (fifo_ptr /r num_frames) + 1
                  }
            }
            t = t + 1
      }

      println("==================================================")
      println("3. Resultados do FIFO:")
      println("   Total de Referencias: " + num_refs)
      println("   Page Faults: " + page_faults)
      println("   Page Hits:   " + page_hits)
      println("   Substituicao estritamente FIFO concluida!")
      println("==================================================")
}
