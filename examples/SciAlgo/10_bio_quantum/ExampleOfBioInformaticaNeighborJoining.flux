#L ============================================================================
#L Algoritmo: Neighbor-Joining (Reconstrucao Filogenetica Aditiva Nao-Enraizada)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N^3) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaNeighborJoining) {
      println("==================================================")
      println("  SciAlgo: Neighbor-Joining Phylogenetic Method")
      println("==================================================")

      #L Matriz de distancias aditiva nao-ultrametrica para 4 taxons:
      #L 1=Taxon A, 2=Taxon B, 3=Taxon C, 4=Taxon D
      mut as int64: n = 4
      mut as int64: r_taxa = 4 #L Numero atual de taxons ativos

      #L Distancias escalonadas por 10 para precisao nos comprimentos de ramos
      #L D(A, B)=70, D(A, C)=110, D(A, D)=140
      #L D(B, C)=100, D(B, D)=130
      #L D(C, D)=90
      mut as list of int64: d = [
            0,   70, 110, 140, #L A
           70,    0, 100, 130, #L B
          110,  100,   0,  90, #L C
          140,  130,  90,   0  #L D
      ]

      mut as list of int64: active = [1, 1, 1, 1]

      println("1. Matriz de Distancias Evolutivas Inicial (4 Taxons, escala x10):")
      println("   D(A, B) = 7.0 | D(A, C) = 11.0 | D(A, D) = 14.0")
      println("   D(B, C) = 10.0 | D(B, D) = 13.0 | D(C, D) = 9.0")

      println("==================================================")
      println("2. Ciclo de Decomposicao em Estrela (Criterio da Matriz Q):")

      #L 2.1 Calcula soma das distancias R_i para cada taxon ativo
      mut as list of int64: r_sums = [0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: s_val = 0
            route {
                  active[i] == 1 ==> {
                        mut as int64: j = 1
                        infinite (j <= n) {
                              route {
                                    active[j] == 1 ==> {
                                          s_val = s_val + d[((i - 1) * n) + j]
                                    }
                                    _ ==> {}
                              }
                              j = j + 1
                        }
                  }
                  _ ==> {}
            }
            r_sums[i] = s_val
            i = i + 1
      }

      println("   Somas de Distancia R: A=" + r_sums[1] + ", B=" + r_sums[2] + ", C=" + r_sums[3] + ", D=" + r_sums[4])

      #L 2.2 Avalia o criterio Q(i, j) = (r - 2) * D(i, j) - R_i - R_j
      mut as int64: min_q = 999999
      mut as int64: best_f = 0
      mut as int64: best_g = 0

      mut as int64: u = 1
      infinite (u <= n) {
            route {
                  active[u] == 1 ==> {
                        mut as int64: v = u + 1
                        infinite (v <= n) {
                              route {
                                    active[v] == 1 ==> {
                                          mut as int64: dij = d[((u - 1) * n) + v]
                                          mut as int64: q_val = ((r_taxa - 2) * dij) - r_sums[u] - r_sums[v]
                                          println("   Q(" + u + ", " + v + ") = " + q_val)

                                          route {
                                                q_val < min_q ==> {
                                                      min_q = q_val
                                                      best_f = u
                                                      best_g = v
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }
                  }
                  _ ==> {}
            }
            u = u + 1
      }

      println("==================================================")
      println("3. Selecao do Par Vizinho e Calculo do Comprimento de Ramos:")
      println("   Vizinhos mais proximos: Taxon " + best_f + " e Taxon " + best_g + " (Min Q = " + min_q + ")")

      #L Comprimento de ramo: limb(f) = (D(f,g)/2) + (R_f - R_g) / (2 * (r - 2))
      mut as int64: dfg = d[((best_f - 1) * n) + best_g]
      mut as int64: limb_f = (dfg /i 2) + ((r_sums[best_f] - r_sums[best_g]) /i (2 * (r_taxa - 2)))
      mut as int64: limb_g = dfg - limb_f

      println("   Ramo para no intermediario U: Ramo(" + best_f + ") = " + (limb_f /i 10) + "." + (limb_f /r 10))
      println("   Ramo para no intermediario U: Ramo(" + best_g + ") = " + (limb_g /i 10) + "." + (limb_g /r 10))

      #L 2.3 Atualizacao das distancias para o novo no interno U (armazenado em best_f)
      #L D(U, k) = (D(f, k) + D(g, k) - D(f, g)) / 2
      mut as int64: k = 1
      infinite (k <= n) {
            route {
                  active[k] == 1 and k != best_f and k != best_g ==> {
                        mut as int64: dfk = d[((best_f - 1) * n) + k]
                        mut as int64: dgk = d[((best_g - 1) * n) + k]
                        mut as int64: duk = (dfk + dgk - dfg) /i 2
                        d[((best_f - 1) * n) + k] = duk
                        d[((k - 1) * n) + best_f] = duk
                        println("   Nova Distancia D(No U, Taxon " + k + ") = " + (duk /i 10) + "." + (duk /r 10))
                  }
                  _ ==> {}
            }
            k = k + 1
      }

      active[best_g] = 0
      r_taxa = r_taxa - 1

      println("==================================================")
      println("4. Resumo da Arvore Filogenetica Nao-Enraizada (NJ):")
      println("   Estrutura Aditiva: Topologia resolvida sem pressuposto de relogio molecular")
      println("   Neighbor-Joining concluido com sucesso!")
      println("==================================================")
}
