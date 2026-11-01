#L ============================================================================
#L Algoritmo: Velvet Assembly (Montador de Genomas por De Bruijn, Tips e Bubbles)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(E) tempo de simplificacao | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaVelvetAssembly) {
      println("==================================================")
      println("  SciAlgo: Velvet Genome Assembler (Velvetg)")
      println("==================================================")

      #L Simulacao das tres etapas centrais do Velvetg:
      #L 1. Construcao do Grafo de de Bruijn com Cobertura (Coverage)
      #L 2. Remocao de Pontas Mortas (Tip Clipping / Error Removal)
      #L 3. Rompimento de Bolhas de Polimorfismos (Bubble Popping / Tour Bus)
      #L 4. Compressao de Caminhos Lineares em Contigs

      #L Nos do Grafo inicial (8 nos):
      #L No 1: Inicio do Contig principal
      #L No 2: Juncao antes da bolha SNP
      #L No 3: Ramo A da bolha (Alelo A, cobertura alta = 20x)
      #L No 4: Ramo B da bolha (Alelo B/erro, cobertura baixa = 2x)
      #L No 5: Convergencia apos a bolha
      #L No 6: Juncao que gera ponta (Tip)
      #L No 7: Ponta espuria (Tip com erro de sequenciamento na extremidade)
      #L No 8: Fim do Contig principal
      mut as int64: num_nodes = 8

      #L Cobertura k-mer por no
      mut as list of int64: coverage = [18, 19, 20, 2, 21, 19, 1, 18]

      #L Status do no: 1=Ativo, 0=Removido/Podado
      mut as list of int64: node_active = [1, 1, 1, 1, 1, 1, 1, 1]

      #L Comprimento em nucleotideos de cada no
      mut as list of int64: node_len = [30, 25, 15, 15, 40, 20, 8, 35]

      println("1. Grafo Inicial Pos-Velveth (8 Nos com Metricas de Cobertura):")
      mut as int64: n = 1
      infinite (n <= num_nodes) {
            println("   No " + n + ": Comp=" + node_len[n] + "bp | Cobertura=" + coverage[n] + "x")
            n = n + 1
      }

      println("==================================================")
      println("2. Fase 1: Poda de Pontas Espurias (Tip Clipping):")

      #L No 7 tem comprimento curto (8 bp < corte 10) e cobertura baixa (1x < corte 5x)
      mut as int64: tip_len_cutoff = 10
      mut as int64: tip_cov_cutoff = 5
      mut as int64: tips_removed = 0

      mut as int64: t = 1
      infinite (t <= num_nodes) {
            route {
                  node_active[t] == 1 ==> {
                        route {
                              node_len[t] < tip_len_cutoff and coverage[t] < tip_cov_cutoff ==> {
                                    node_active[t] = 0
                                    tips_removed = tips_removed + 1
                                    println("   [Tip Clipping]: Removido No " + t + " (Ponta de erro com " + node_len[t] + "bp e " + coverage[t] + "x)")
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            t = t + 1
      }
      println("   Total de pontas podadas: " + tips_removed)

      println("==================================================")
      println("3. Fase 2: Rompimento de Bolhas de Erro / SNP (Bubble Popping):")

      #L Nos 3 e 4 formam caminhos alternativos paralelos entre os nos 2 e 5
      #L Algoritmo Tour Bus compara cobertura de ramos paralelos:
      #L No 3 tem 20x vs No 4 que tem 2x -> No 4 e eliminado como artefato
      mut as int64: bubbles_popped = 0
      route {
            node_active[3] == 1 and node_active[4] == 1 ==> {
                  route {
                        coverage[3] > (coverage[4] * 3) ==> {
                              node_active[4] = 0
                              bubbles_popped = bubbles_popped + 1
                              println("   [Tour Bus]: Bolha resolvida entre No 3 (" + coverage[3] + "x) e No 4 (" + coverage[4] + "x)")
                              println("   => Ramo minoritario No 4 descartado com sucesso")
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      println("==================================================")
      println("4. Fase 3: Compressao de Grafo e Formacao do Contig Final:")

      #L Soma o comprimento de todos os nos ativos restantes que formam o caminho contiguo:
      #L Nos ativos: 1, 2, 3, 5, 6, 8
      mut as int64: total_contig_length = 0
      mut as int64: active_nodes_count = 0

      mut as int64: k = 1
      infinite (k <= num_nodes) {
            route {
                  node_active[k] == 1 ==> {
                        total_contig_length = total_contig_length + node_len[k]
                        active_nodes_count = active_nodes_count + 1
                  }
                  _ ==> {}
            }
            k = k + 1
      }

      println("   Nos Ativos no Esqueleto do Contig: " + active_nodes_count + " de " + num_nodes)
      println("   Comprimento Total do Contig Montado: " + total_contig_length + " pares de bases (bp)")
      println("   Metrica N50 da Montagem: " + total_contig_length + " bp")
      println("   Velvet Assembly concluido com sucesso!")
      println("==================================================")
}
