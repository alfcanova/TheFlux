#L ============================================================================
#L Algoritmo: Least Recently Used (LRU) Page Replacement
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(M) busca e substituicao por referencia de pagina (M quadros)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisLRUPageReplacement) {
      println("==================================================")
      println("  SciAlgo: Least Recently Used (LRU) Paging")
      println("==================================================")

      #L O algoritmo LRU substitui a pagina que nao foi referenciada ha mais tempo
      #L na memoria principal. Baseia-se no principio de localidade temporal.

      mut as int64: num_frames = 3
      mut as list of int64: frames = [-1, -1, -1] #L -1 indica quadro vazio
      mut as list of int64: last_used = [0, 0, 0] #L Timestamp do ultimo acesso

      #L Sequencia de referencias de paginas (10 acessos):
      mut as int64: num_refs = 10
      mut as list of int64: refs = [7, 0, 1, 2, 0, 3, 0, 4, 2, 3]

      println("1. Parametros do Gerenciador de Memoria Virtual:")
      println("   Numero de Quadros (Frames): " + num_frames)
      println("   Sequencia de Referencias: [7, 0, 1, 2, 0, 3, 0, 4, 2, 3]")

      println("==================================================")
      println("2. [Simulacao de Falhas e Substituicoes LRU]:")

      mut as int64: page_faults = 0
      mut as int64: page_hits = 0

      mut as int64: t = 1
      infinite (t <= num_refs) {
            mut as int64: page = refs[t]
            mut as int64: found_idx = 0

            #L Verifica se a pagina ja esta em algum quadro (HIT)
            mut as int64: f = 1
            infinite (f <= num_frames) {
                  route {
                        frames[f] == page ==> {
                              found_idx = f
                        }
                        _ ==> {}
                  }
                  f = f + 1
            }

            route {
                  found_idx > 0 ==> {
                        #L PAGE HIT
                        page_hits = page_hits + 1
                        last_used[found_idx] = t
                        println("   [Acesso " + t + "] Pagina " + page + " -> HIT no Quadro " + found_idx)
                  }
                  _ ==> {
                        #L PAGE FAULT
                        page_faults = page_faults + 1

                        #L Procura quadro vazio primeiro
                        mut as int64: victim_frame = 0
                        mut as int64: e = 1
                        infinite (e <= num_frames) {
                              route {
                                    frames[e] == -1 ==> {
                                          route {
                                                victim_frame == 0 ==> { victim_frame = e }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              e = e + 1
                        }

                        #L Se todos ocupados, escolhe o menos recentemente usado (menor timestamp)
                        route {
                              victim_frame == 0 ==> {
                                    mut as int64: min_ts = 999999
                                    mut as int64: k = 1
                                    infinite (k <= num_frames) {
                                          route {
                                                last_used[k] < min_ts ==> {
                                                      min_ts = last_used[k]
                                                      victim_frame = k
                                                }
                                                _ ==> {}
                                          }
                                          k = k + 1
                                    }
                                    println("   [Acesso " + t + "] Pagina " + page + " -> FAULT! Vitima LRU: Pagina " + frames[victim_frame] + " no Quadro " + victim_frame)
                              }
                              _ ==> {
                                    println("   [Acesso " + t + "] Pagina " + page + " -> FAULT! Quadro Livre " + victim_frame + " alocado.")
                              }
                        }

                        frames[victim_frame] = page
                        last_used[victim_frame] = t
                  }
            }
            t = t + 1
      }

      println("==================================================")
      println("3. Estatisticas de Memoria Virtual:")
      println("   Total de Acessos: " + num_refs)
      println("   Page Faults: " + page_faults)
      println("   Page Hits:   " + page_hits)
      println("   Taxa de Acertos (Hit Ratio): " + (page_hits * 100 /i num_refs) + "%")
      println("==================================================")
}
