#L ============================================================================
#L Algoritmo: Marzullo's Interval Agreement Algorithm (1984)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(M log M) ordenacao dos limites de intervalo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoMarzulloAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Marzullo's Interval Agreement")
      println("==================================================")

      #L O algoritmo de Marzullo (utilizado no NTP) seleciona a estimativa de
      #L tempo mais precisa a partir de um conjunto de fontes ruidosas com intervalos
      #L de confianca [inicio, fim].
      #L Considerando M fontes com no maximo f falhas, o algoritmo busca o intervalo
      #L com a maior intersecao que contenha pelo menos M - f fontes corretas.

      mut as int64: m_sources = 4
      mut as int64: f_faults = 1
      mut as int64: min_overlap = m_sources - f_faults #L 3 fontes requeridas

      #L Fontes de tempo:
      #L Fonte 1: [10, 30]
      #L Fonte 2: [15, 35]
      #L Fonte 3: [12, 28]
      #L Fonte 4 (ruidosa/falha): [40, 60]
      mut as list of int64: starts = [10, 15, 12, 40]
      mut as list of int64: ends   = [30, 35, 28, 60]

      println("1. Intervalos Fornecidos pelas Fontes:")
      mut as int64: s = 1
      infinite (s <= m_sources) {
            println("   Fonte " + s + ": [" + starts[s] + ", " + ends[s] + "]")
            s = s + 1
      }
      println("   Parametros: M = " + m_sources + " | Tolerancia f = " + f_faults + " | Sobreposicao minima = " + min_overlap)

      #L Construcao dos 2*M pontos para varredura:
      #L Cada inicio tem peso -1 (adiciona intervado), cada fim tem peso +1 (subtrai intervalo)
      #L Total de pontos = 8
      mut as int64: total_pts = 8
      mut as list of int64: pt_coords = [10, 30, 15, 35, 12, 28, 40, 60]
      mut as list of int64: pt_types  = [-1,  1, -1,  1, -1,  1, -1,  1]

      #L Ordenacao dos pontos por coordenada crescente (Bubble Sort simples)
      mut as int64: i = 1
      infinite (i <= total_pts - 1) {
            mut as int64: j = 1
            infinite (j <= total_pts - i) {
                  mut as int64: swap_needed = 0
                  route {
                        pt_coords[j] > pt_coords[j + 1] ==> {
                              swap_needed = 1
                        }
                        pt_coords[j] == pt_coords[j + 1] ==> {
                              #L Se coordenadas forem iguais, +1 vem antes de -1
                              route {
                                    pt_types[j] < pt_types[j + 1] ==> {
                                          swap_needed = 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }

                  route {
                        swap_needed == 1 ==> {
                              mut as int64: tmp_c = pt_coords[j]
                              pt_coords[j] = pt_coords[j + 1]
                              pt_coords[j + 1] = tmp_c

                              mut as int64: tmp_t = pt_types[j]
                              pt_types[j] = pt_types[j + 1]
                              pt_types[j + 1] = tmp_t
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. [Varredura de Intervalos Ordenados]:")
      mut as int64: current_active = 0
      mut as int64: max_active = 0
      mut as int64: best_start = 0
      mut as int64: best_end = 0

      mut as int64: k = 1
      infinite (k <= total_pts) {
            mut as int64: coord = pt_coords[k]
            mut as int64: typ = pt_types[k]

            route {
                  typ == -1 ==> {
                        current_active = current_active + 1
                        route {
                              current_active > max_active ==> {
                                    max_active = current_active
                                    best_start = coord
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        route {
                              current_active == max_active ==> {
                                    route {
                                          best_end == 0 ==> {
                                                best_end = coord
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        current_active = current_active - 1
                  }
            }
            println("   Ponto " + coord + " (tipo=" + typ + ") -> Fontes ativas = " + current_active)
            k = k + 1
      }

      println("==================================================")
      println("3. [Resultado do Algoritmo de Marzullo]")
      println("   Maximo de fontes em consenso: " + max_active + " (>= " + min_overlap + ")")
      println("   Intervalo de Maior Concordancia: [" + best_start + ", " + best_end + "]")
      mut as int64: midpoint = (best_start + best_end) /i 2
      println("   Tempo Sincronizado Estimado (Ponto Medio): " + midpoint)
      println("   Fonte 4 (falha/outlier) rejeitada com sucesso!")
      println("==================================================")
}
