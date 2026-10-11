#L ============================================================================
#L Algoritmo: Maximum Parsimony (Algoritmo de Fitch para Parcimonia Maxima)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N * M) tempo para N folhas e M caracteres | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaMaximumParsimony) {
      println("==================================================")
      println("  SciAlgo: Maximum Parsimony (Fitch's Algorithm)")
      println("==================================================")

      #L Arvore Filogenetica Binaria com 4 Folhas e 3 Nos Internos (Total 7 nos)
      #L Nos: 1=Sp1, 2=Sp2, 3=Sp3, 4=Sp4
      #L No 5 = ancestral de (1, 2)
      #L No 6 = ancestral de (3, 4)
      #L No 7 = raiz conectando (5, 6)
      #L Mascara de Bits de Nucleotideos: A=1, C=2, G=4, T=8

      #L Alinhamento de 4 sitios (colunas) para as 4 especies:
      #L Sp1: A C G T -> [1, 2, 4, 8]
      #L Sp2: A C G A -> [1, 2, 4, 1]
      #L Sp3: T C A A -> [8, 2, 1, 1]
      #L Sp4: T G A T -> [8, 4, 1, 8]
      mut as int64: num_taxa = 4
      mut as int64: num_sites = 4

      #L Matriz de Caracteres 4x4 (folha x sitio): idx = (taxa - 1) * 4 + site
      mut as list of int64: char_matrix = [
            1, 2, 4, 8, #L Sp1: A, C, G, T
            1, 2, 4, 1, #L Sp2: A, C, G, A
            8, 2, 1, 1, #L Sp3: T, C, A, A
            8, 4, 1, 8  #L Sp4: T, G, A, T
      ]

      println("1. Topologia da Arvore Sob Avaliacao: ((Sp1, Sp2), (Sp3, Sp4))")
      println("   Sp1: [A, C, G, T]")
      println("   Sp2: [A, C, G, A]")
      println("   Sp3: [T, C, A, A]")
      println("   Sp4: [T, G, A, T]")

      println("==================================================")
      println("2. Execucao do Algoritmo de Fitch (Fase Bottom-Up):")

      mut as int64: total_parsimony_score = 0

      mut as int64: col = 1
      infinite (col <= num_sites) {
            #L Conjunto de estados para os 7 nos da arvore no sitio 'col'
            mut as list of int64: node_sets = [0, 0, 0, 0, 0, 0, 0]

            #L Atribui conjuntos unitarios as folhas (1 a 4)
            node_sets[1] = char_matrix[((1 - 1) * 4) + col]
            node_sets[2] = char_matrix[((2 - 1) * 4) + col]
            node_sets[3] = char_matrix[((3 - 1) * 4) + col]
            node_sets[4] = char_matrix[((4 - 1) * 4) + col]

            mut as int64: site_cost = 0

            #L Avalia No 5 (filhos 1 e 2)
            mut as int64: s1 = node_sets[1]
            mut as int64: s2 = node_sets[2]
            mut as int64: inter_5 = s1 & s2
            route {
                  inter_5 > 0 ==> {
                        node_sets[5] = inter_5
                  }
                  _ ==> {
                        node_sets[5] = s1 | s2
                        site_cost = site_cost + 1
                  }
            }

            #L Avalia No 6 (filhos 3 e 4)
            mut as int64: s3 = node_sets[3]
            mut as int64: s4 = node_sets[4]
            mut as int64: inter_6 = s3 & s4
            route {
                  inter_6 > 0 ==> {
                        node_sets[6] = inter_6
                  }
                  _ ==> {
                        node_sets[6] = s3 | s4
                        site_cost = site_cost + 1
                  }
            }

            #L Avalia No 7 (Raiz, filhos 5 e 6)
            mut as int64: s5 = node_sets[5]
            mut as int64: s6 = node_sets[6]
            mut as int64: inter_7 = s5 & s6
            route {
                  inter_7 > 0 ==> {
                        node_sets[7] = inter_7
                  }
                  _ ==> {
                        node_sets[7] = s5 | s6
                        site_cost = site_cost + 1
                  }
            }

            total_parsimony_score = total_parsimony_score + site_cost
            println("   Sitio " + col + ": Mutacoes minimas = " + site_cost + " | Estado ancestral raiz: " + node_sets[7])
            col = col + 1
      }

      println("==================================================")
      println("3. Resumo da Pontuacao de Parcimonia Global:")
      println("   Total Minimo de Passos Evolutivos (Mutacoes): " + total_parsimony_score)
      println("   Criterio de Parcimonia: Topologia otima minimiza homoplasias")
      println("   Maximum Parsimony concluido com sucesso!")
      println("==================================================")
}
