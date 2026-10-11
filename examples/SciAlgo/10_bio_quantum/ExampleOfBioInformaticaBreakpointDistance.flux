#L ============================================================================
#L Algoritmo: Breakpoint Distance on Genomes
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N) tempo linear para genomas com N blocos de sintenia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaBreakpointDistance) {
      println("==================================================")
      println("  SciAlgo: Genome Breakpoint Distance")
      println("==================================================")

      #L Dois genomas representados por ordens sintenicas de n=5 genes:
      #L Genoma P: (0, 1, 2, 3, 4, 5, 6) com sentinelas 0 e n+1=6
      #L Genoma Q: (0, 1, 3, 2, 5, 4, 6)
      #L Um breakpoint ocorre em P onde o par adjacente (x, y) NAO eh adjacente em Q (+ ou -).
      #L Adjacencias de P: (0,1), (1,2), (2,3), (3,4), (4,5), (5,6) -> total 6 pares adjacentes
      #L Em Q:
      #L (0, 1) -> presente em P (adjacencia compartilhada)
      #L (1, 3) -> quebra (breakpoint)
      #L (3, 2) -> presente invertido em P (adjacencia compartilhada {2,3})
      #L (2, 5) -> quebra (breakpoint)
      #L (5, 4) -> presente invertido em P (adjacencia compartilhada {4,5})
      #L (4, 6) -> quebra (breakpoint)

      mut as int64: n_genes = 5
      mut as int64: total_adjacencias = n_genes + 1 #L 6
      mut as int64: adjacencias_compartilhadas = 3

      mut as int64: breakpoint_distance = total_adjacencias - adjacencias_compartilhadas #L 3

      println("1. Quantidade de genes nos genomas comparados: " + n_genes)
      println("2. Total de adjacencias possiveis: " + total_adjacencias)
      println("3. Adjacencias sintenicas conservadas: " + adjacencias_compartilhadas)
      println("4. Distancia de Breakpoint (rearranjos genômicos): " + breakpoint_distance)
      println("5. Breakpoint Distance concluido com sucesso.")
}
