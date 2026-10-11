#L ============================================================================
#L Algoritmo: UPGMA (Unweighted Pair Group Method with Arithmetic Mean)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N^3) ingênuo / O(N^2) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaUPGMA) {
      println("==================================================")
      println("  SciAlgo: UPGMA Phylogenetic Tree Construction")
      println("==================================================")

      #L Construcao de arvore filogenetica para 4 taxons:
      #L 1=Humano, 2=Chimpanze, 3=Gorila, 4=Orangotango
      mut as int64: n = 4

      #L Matriz de distancias inicial 4x4 (valores inteiros simetricos)
      #L Dimensoes 4x4: idx = (i - 1) * 4 + j
      mut as list of int64: dist = [
            0,   8,  14,  22, #L Humano
            8,   0,  14,  22, #L Chimpanze
           14,  14,   0,  22, #L Gorila
           22,  22,  22,   0  #L Orangotango
      ]

      #L Tamanho de cada cluster (cardinalidade)
      mut as list of int64: cluster_sizes = [1, 1, 1, 1]

      #L Marcador de clusters ativos (1=ativo, 0=inativo/fundido)
      mut as list of int64: active = [1, 1, 1, 1]

      println("1. Matriz de Distancias Evolutivas Original (4 Taxons):")
      println("   [H] Humano, [C] Chimpanze, [G] Gorila, [O] Orangotango")
      println("   D(H, C) = 8 | D(H, G) = 14 | D(H, O) = 22")
      println("   D(C, G) = 14 | D(C, O) = 22 | D(G, O) = 22")

      println("==================================================")
      println("2. Ciclos de Agrupamento Hierarquico UPGMA:")

      mut as int64: step = 1
      infinite (step < n) {
            #L 2.1 Encontra o par de clusters ativos com menor distancia
            mut as int64: min_d = 999999
            mut as int64: best_u = 0
            mut as int64: best_v = 0

            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        active[i] == 1 ==> {
                              mut as int64: j = i + 1
                              infinite (j <= n) {
                                    route {
                                          active[j] == 1 ==> {
                                                mut as int64: d_val = dist[((i - 1) * n) + j]
                                                route {
                                                      d_val < min_d ==> {
                                                            min_d = d_val
                                                            best_u = i
                                                            best_v = j
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    j = j + 1
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            mut as int64: node_height = min_d /i 2
            println("   Passo " + step + ": Fusao Cluster " + best_u + " e Cluster " + best_v + " (Distancia = " + min_d + ", Altura do No = " + node_height + ")")

            #L 2.2 Atualiza distancias do novo cluster (mantido no indice best_u) para os demais clusters k
            mut as int64: size_u = cluster_sizes[best_u]
            mut as int64: size_v = cluster_sizes[best_v]
            mut as int64: new_size = size_u + size_v

            mut as int64: k = 1
            infinite (k <= n) {
                  route {
                        active[k] == 1 and k != best_u and k != best_v ==> {
                              mut as int64: d_uk = dist[((best_u - 1) * n) + k]
                              mut as int64: d_vk = dist[((best_v - 1) * n) + k]
                              #L Media aritmetica ponderada pelos tamanhos dos clusters
                              mut as int64: d_new = ((size_u * d_uk) + (size_v * d_vk)) /i new_size

                              #L Atualiza na matriz simetrica
                              dist[((best_u - 1) * n) + k] = d_new
                              dist[((k - 1) * n) + best_u] = d_new
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            #L 2.3 Atualiza metadados: best_u recebe novo tamanho, best_v torna-se inativo
            cluster_sizes[best_u] = new_size
            active[best_v] = 0

            step = step + 1
      }

      println("==================================================")
      println("3. Resumo da Arvore Filogenetica Ultrametrica Gerada:")
      println("   Topologia: (((Humano, Chimpanze):4, Gorila):7, Orangotango):11")
      println("   Relogio Molecular: Ramos ultrametricos com distancias aditivas preservadas")
      println("   UPGMA concluido com sucesso!")
      println("==================================================")
}
