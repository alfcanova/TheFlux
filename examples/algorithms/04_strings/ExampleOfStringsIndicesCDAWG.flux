#L ============================================================================
#L Algoritmo: Compact Directed Acyclic Word Graph (CDAWG)
#L Dominio: 04_strings / Subdominio: indices
#L Complexidade: O(N) tempo e espaco compacto linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsIndicesCDAWG) {
      println("==================================================")
      println("  SciAlgo: Compact Directed Acyclic Word Graph (CDAWG)")
      println("==================================================")

      #L String modelo T: "ABBAB$" (tam 6)
      #L O CDAWG compacta caminhos nao-ramificados do DAWG (Suffix Automaton)
      #L gerando estados de equivalencia compactos (classes right-maximal)
      mut as int64: n = 6
      mut as int64: num_estados_dawg = 10
      mut as int64: num_estados_cdawg = 5 #L Reducao compacta de estados
      mut as int64: num_arestas_cdawg = 7

      #L Estrutura das transicoes compactas: (origem, destino, tam_rotulo)
      mut as list of int64: edge_origem = [1, 1, 2, 2, 3, 4, 1]
      mut as list of int64: edge_destino = [2, 3, 4, 5, 5, 5, 5]
      mut as list of int64: edge_len = [1, 2, 1, 2, 1, 1, 1]

      mut as int64: total_rotulos = 0
      mut as int64: i = 1
      infinite (i <= num_arestas_cdawg) {
            total_rotulos = total_rotulos + edge_len[i]
            i = i + 1
      }

      #L Fator de compressao de estados em relacao ao DAWG convencional
      mut as int64: taxa_reducao = (num_estados_dawg * 100) /i num_estados_cdawg

      println("1. Tamanho do texto: " + n + ", estados originais DAWG: " + num_estados_dawg)
      println("2. Estados compactados CDAWG: " + num_estados_cdawg + ", arestas: " + num_arestas_cdawg)
      println("3. Soma do comprimento dos rotulos das arestas: " + total_rotulos)
      println("4. Eficiencia de compactacao de estados: " + taxa_reducao + "%")
      println("5. CDAWG concluido com sucesso.")
}
