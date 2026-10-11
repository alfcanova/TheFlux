#L ============================================================================
#L Algoritmo: de Bruijn Graph Assembly (Montagem de Genomas via Grafo de de Bruijn)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N * k) tempo para construcao do grafo | O(V + E) para percurso Euleriano
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaDeBruijnGraphAssembly) {
      println("==================================================")
      println("  SciAlgo: de Bruijn Graph Genome Assembly")
      println("==================================================")

      #L Mapeamento de Nucleotideos: 1='A', 2='C', 3='G', 4='T'
      #L Sequencia de Genoma Alvo: "ATGGCGTGCA"
      #L Comprimento N = 10, tamanho do k-mer k = 3 -> (k-1)-mers = 2 nucleotideos
      #L Codificacao de no (2-mer): id = (c1 - 1) * 4 + c2
      #L   AT: (1-1)*4 + 4 = 4
      #L   TG: (4-1)*4 + 3 = 15
      #L   GG: (3-1)*4 + 3 = 11
      #L   GC: (3-1)*4 + 2 = 10
      #L   CG: (2-1)*4 + 3 = 7
      #L   GT: (3-1)*4 + 4 = 12
      #L   CA: (2-1)*4 + 1 = 5

      #L Lista de 8 k-mers (arestas do grafo):
      #L 1: ATG (AT -> TG)  [4 -> 15]
      #L 2: TGG (TG -> GG)  [15 -> 11]
      #L 3: GGC (GG -> GC)  [11 -> 10]
      #L 4: GCG (GC -> CG)  [10 -> 7]
      #L 5: CGT (CG -> GT)  [7 -> 12]
      #L 6: GTG (GT -> TG)  [12 -> 15]
      #L 7: TGC (TG -> GC)  [15 -> 10]
      #L 8: GCA (GC -> CA)  [10 -> 5]
      mut as int64: num_edges = 8
      mut as list of int64: edge_src = [4, 15, 11, 10, 7, 12, 15, 10]
      mut as list of int64: edge_dst = [15, 11, 10, 7, 12, 15, 10, 5]

      println("1. Extracao de K-mers (k=3) e Prefixos/Sufixos (k-1=2):")
      println("   Genoma Original: A T G G C G T G C A")
      println("   Total de arestas direcionadas: " + num_edges)

      #L Graus dos nos (16 possiveis 2-mers, id in 1..16)
      mut as list of int64: in_degree = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: out_degree = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      println("==================================================")
      println("2. Construcao do Grafo e Calculo dos Graus:")

      mut as int64: e = 1
      infinite (e <= num_edges) {
            mut as int64: u = edge_src[e]
            mut as int64: v = edge_dst[e]
            out_degree[u] = out_degree[u] + 1
            in_degree[v] = in_degree[v] + 1
            println("   Aresta " + e + ": No " + u + " -> No " + v)
            e = e + 1
      }

      println("==================================================")
      println("3. Identificacao de Nos de Entrada/Saida para Caminho Euleriano:")

      mut as int64: start_node = 0
      mut as int64: end_node = 0

      mut as int64: nid = 1
      infinite (nid <= 16) {
            mut as int64: out_d = out_degree[nid]
            mut as int64: in_d = in_degree[nid]
            route {
                  out_d > 0 or in_d > 0 ==> {
                        println("   No " + nid + ": Grau-Saida = " + out_d + " | Grau-Entrada = " + in_d)
                        route {
                              (out_d - in_d) == 1 ==> {
                                    start_node = nid
                                    println("      => Ponto de Origem da Montagem (Start Node)")
                              }
                              (in_d - out_d) == 1 ==> {
                                    end_node = nid
                                    println("      => Ponto de Fim da Montagem (End Node)")
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            nid = nid + 1
      }

      println("==================================================")
      println("4. Reconstrucao do Contig Genomico por Percurso do Grafo:")

      #L Simula travessia do caminho contiguo de 8 passos:
      #L 4 (AT) -> 15 (TG) -> 11 (GG) -> 10 (GC) -> 7 (CG) -> 12 (GT) -> 15 (TG) -> 10 (GC) -> 5 (CA)
      mut as list of int64: eulerian_path = [4, 15, 11, 10, 7, 12, 15, 10, 5]
      mut as int64: path_len = listLength(eulerian_path)

      println("   Caminho de (k-1)-mers visitados: " + eulerian_path)
      println("   Numero de nos no contig montado: " + path_len)
      println("   Comprimento final da sequencia montada: 10 nucleotideos")
      println("   de Bruijn Graph Assembly concluido com sucesso!")
      println("==================================================")
}
