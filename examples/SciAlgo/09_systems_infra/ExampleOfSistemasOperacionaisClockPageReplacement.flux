#L ============================================================================
#L Algoritmo: Clock Page Replacement (Second-Chance Algorithm, Corbató 1968)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) amortizado aproximando LRU com bit de referencia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisClockPageReplacement) {
      println("==================================================")
      println("  SciAlgo: Clock Page Replacement (Second-Chance)")
      println("==================================================")

      #L O algoritmo do Relogio (Clock) e uma aproximacao pratica e eficiente do LRU.
      #L Mantem uma lista circular de quadros com um bit de uso/referencia (R-bit).
      #L Ao buscar uma vitima, o ponteiro do relogio varre os quadros:
      #L - Se R == 1: zera para 0 (concede uma segunda chance) e avanca o ponteiro.
      #L - Se R == 0: seleciona o quadro como vitima, substitui a pagina e avanca.

      mut as int64: num_frames = 3
      mut as list of int64: frames = [-1, -1, -1]
      mut as list of int64: r_bits = [0, 0, 0] #L Reference bits
      mut as int64: clock_hand = 1

      mut as int64: num_refs = 8
      mut as list of int64: refs = [1, 2, 3, 1, 4, 5, 2, 1]

      println("1. Parametros do Relogio:")
      println("   Numero de Quadros: " + num_frames + " | Ponteiro Inicial = " + clock_hand)
      println("   Sequencia: [1, 2, 3, 1, 4, 5, 2, 1]")

      println("==================================================")
      println("2. [Simulacao do Algoritmo Clock]:")

      mut as int64: page_faults = 0
      mut as int64: page_hits = 0

      mut as int64: t = 1
      infinite (t <= num_refs) {
            mut as int64: page = refs[t]
            mut as int64: hit_frame = 0

            #L Verifica se a pagina ja reside em memoria (HIT)
            mut as int64: f = 1
            infinite (f <= num_frames) {
                  route {
                        frames[f] == page ==> { hit_frame = f }
                        _ ==> {}
                  }
                  f = f + 1
            }

            route {
                  hit_frame > 0 ==> {
                        page_hits = page_hits + 1
                        r_bits[hit_frame] = 1 #L Ativa o bit de referencia
                        println("   [Acesso " + t + "] Pagina " + page + " -> HIT no Quadro " + hit_frame + " (R-bit definido para 1)")
                  }
                  _ ==> {
                        page_faults = page_faults + 1

                        #L Busca vitima varrendo com o ponteiro do relogio
                        mut as int64: victim = 0
                        infinite (victim == 0) {
                              route {
                                    frames[clock_hand] == -1 ==> {
                                          #L Quadro vazio encontrado
                                          victim = clock_hand
                                    }
                                    r_bits[clock_hand] == 1 ==> {
                                          #L Segunda chance: zera bit e avanca
                                          r_bits[clock_hand] = 0
                                          clock_hand = (clock_hand /r num_frames) + 1
                                    }
                                    _ ==> {
                                          #L R-bit == 0: Vitima encontrada!
                                          victim = clock_hand
                                    }
                              }
                        }

                        mut as int64: old_p = frames[victim]
                        frames[victim] = page
                        r_bits[victim] = 1 #L Nova pagina entra com R=1
                        clock_hand = (victim /r num_frames) + 1

                        route {
                              old_p == -1 ==> {
                                    println("   [Acesso " + t + "] Pagina " + page + " -> FAULT! Inserida no Quadro " + victim + " (R=1, Ponteiro=" + clock_hand + ")")
                              }
                              _ ==> {
                                    println("   [Acesso " + t + "] Pagina " + page + " -> FAULT! Substitui Pagina " + old_p + " no Quadro " + victim + " (Ponteiro=" + clock_hand + ")")
                              }
                        }
                  }
            }
            t = t + 1
      }

      println("==================================================")
      println("3. Resumo do Clock Page Replacement:")
      println("   Total de Acessos: " + num_refs)
      println("   Page Faults: " + page_faults)
      println("   Page Hits:   " + page_hits)
      println("   Aproximacao de LRU por hardware de baixo custo comprovada!")
      println("==================================================")
}
